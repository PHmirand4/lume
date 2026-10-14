import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/codigos.dart';
import '../../domain/importacao.dart';
import '../../domain/regras.dart';
import '../local/database.dart';
import 'foco_repository.dart' show FotoCapturada, agoraUtc;

/// Vocabulários indexados por lista e código, para traduzir códigos em rótulos.
class Vocabulario {
  Vocabulario(this._itens);

  final Map<String, List<ListaValor>> _itens;

  static final vazio = Vocabulario(const {});

  List<ListaValor> itens(String lista) =>
      (_itens[lista] ?? const []).where((v) => v.ativo).toList();

  String rotulo(String lista, String? codigo) {
    if (codigo == null) return '—';
    for (final v in _itens[lista] ?? const <ListaValor>[]) {
      if (v.codigo == codigo) return v.rotulo;
    }
    return codigo;
  }
}

extension NomesEspecie on Especie {
  /// Nome para a tela: o primeiro nome popular ou, sem ele, o binômio.
  String get nomeComum => nomesPopulares.isNotEmpty ? nomesPopulares.first : binomio;

  /// "Acacia mangium Willd." → "Acacia mangium".
  String get binomio => nomeCientifico.split(' ').take(2).join(' ');

  /// Cadastrada pela equipe no app (não veio do catálogo inicial).
  bool get cadastradaNoApp => criadoPor != null;

  bool get animal => reino == Reino.animal;
}

/// Quantas vezes a espécie apareceu numa unidade e a foto que a representa.
class ResumoEspecie {
  const ResumoEspecie({this.ocorrencias = 0, this.ativas = 0, this.registros = 0, this.foto});

  /// Focos (locais com a espécie), sem os descartados.
  final int ocorrencias;

  /// Focos em que a espécie ainda está presente (detectado, em controle, rebrotou).
  final int ativas;

  /// Visitas registradas (detecções e revisitas).
  final int registros;

  /// Foto da espécie: a do catálogo ou, sem ela, a mais recente dos registros.
  final String? foto;

  static const vazio = ResumoEspecie();
}

/// Resultado de importar uma planilha da lista oficial.
class ResultadoListaOficial {
  const ResultadoListaOficial({
    required this.unidades,
    required this.especiesNovasNoCatalogo,
    required this.linhasIgnoradas,
    required this.antes,
    required this.depois,
  });

  final int unidades;
  final List<String> especiesNovasNoCatalogo;

  /// Linhas de unidades que o app ainda não atende (ex.: parques, reservas).
  final int linhasIgnoradas;
  final Map<String, Set<String>> antes;
  final Map<String, Set<String>> depois;

  Set<String> entraram(String unidade) => (depois[unidade] ?? {}).difference(antes[unidade] ?? {});
  Set<String> sairam(String unidade) =>
      depois.containsKey(unidade) ? (antes[unidade] ?? {}).difference(depois[unidade]!) : {};
}

/// Dados do formulário de espécie (cadastro ou edição).
class DadosEspecie {
  DadosEspecie({
    required this.nomeCientifico,
    required this.nomesPopulares,
    required this.formaVida,
    this.familia,
    this.descricaoIdentificacao,
    this.confusaoCom,
    this.origemNativa,
    this.ambientesInvasao,
    this.impactos,
    this.controleCitado,
    this.metodosSugeridos = const [],
    this.nativaBrasil = false,
    this.reino = Reino.planta,
  });

  final String nomeCientifico;
  final List<String> nomesPopulares;
  final String formaVida;
  final String? familia;
  final String? descricaoIdentificacao;
  final String? confusaoCom;
  final String? origemNativa;
  final String? ambientesInvasao;
  final String? impactos;
  final String? controleCitado;
  final List<String> metodosSugeridos;
  final bool nativaBrasil;
  final String reino;
}

/// Espécies (catálogo nacional), fotos de referência e vocabulários controlados.
class CatalogoRepository {
  CatalogoRepository(this.db);

  final AppDatabase db;
  static const _uuid = Uuid();

  /// Dono das fotos de referência na tabela `midias`.
  static const donoEspecie = 'especie';

  Stream<List<Especie>> observarEspecies() => (db.select(db.especies)
        ..where((e) => e.ativa.equals(true) & e.deleted.equals(false))
        ..orderBy([(e) => OrderingTerm.asc(e.ordem)]))
      .watch();

  Future<Especie?> especie(String id) =>
      (db.select(db.especies)..where((e) => e.id.equals(id))).getSingleOrNull();

  Stream<Vocabulario> observarVocabulario() =>
      (db.select(db.listaValores)..orderBy([(v) => OrderingTerm.asc(v.ordem)]))
          .watch()
          .map((linhas) {
        final m = <String, List<ListaValor>>{};
        for (final l in linhas) {
          m.putIfAbsent(l.lista, () => []).add(l);
        }
        return Vocabulario(m);
      });

  Future<Vocabulario> vocabulario() => observarVocabulario().first;

  /// Espécie do catálogo com o mesmo binômio (ignora autor, acentos e caixa).
  Future<Especie?> porNomeCientifico(String nome) async {
    final alvo = binomioNormalizado(nome);
    if (alvo.isEmpty) return null;
    final todas = await (db.select(db.especies)..where((e) => e.deleted.equals(false))).get();
    return todas.where((e) => binomioNormalizado(e.nomeCientifico) == alvo).firstOrNull;
  }

  /// Espécie pelo nome científico ou, sem ele, por um dos nomes populares.
  Future<Especie?> procurar(String nome) async {
    final porCientifico = await porNomeCientifico(nome);
    if (porCientifico != null && binomioNormalizado(nome).contains(' ')) return porCientifico;
    final alvo = normalizarTexto(nome);
    if (alvo.isEmpty) return null;
    final todas = await (db.select(db.especies)..where((e) => e.deleted.equals(false))).get();
    return todas.where((e) => e.nomesPopulares.any((n) => normalizarTexto(n) == alvo)).firstOrNull;
  }

  // ------------------------------------------------------------ lista oficial

  /// Espécies da Lista de EEI em UC federais na unidade (ICMBio).
  Stream<Set<String>> observarListaOficial(String unidadeId) => (db.select(db.especiesUnidade)
        ..where((e) => e.unidadeId.equals(unidadeId)))
      .watch()
      .map((l) => {for (final e in l) e.especieId});

  /// Ciclo da lista oficial guardada no aparelho (nulo se não houver).
  Stream<int?> observarCicloLista() => db
      .customSelect('SELECT MAX(ciclo) AS c FROM especies_unidade', readsFrom: {db.especiesUnidade})
      .watchSingle()
      .map((l) => l.readNullable<int>('c'));

  /// A espécie consta na lista oficial da unidade? (Unidade sem nenhuma
  /// espécie listada também conta como "não": qualquer registro é novo.)
  Future<bool> naListaOficial(String unidadeId, String especieId) async =>
      await (db.select(db.especiesUnidade)
            ..where((e) => e.unidadeId.equals(unidadeId) & e.especieId.equals(especieId)))
          .getSingleOrNull() !=
      null;

  /// Troca a lista oficial das unidades presentes em [porUnidade] pela nova
  /// (um ciclo da Lista de EEI em UC federais). Unidades fora do arquivo ficam como estão.
  Future<void> substituirListaOficial(Map<String, Set<String>> porUnidade, {required int ciclo, required String fonte}) =>
      db.transaction(() async {
        for (final MapEntry(key: unidade, value: especiesIds) in porUnidade.entries) {
          await (db.delete(db.especiesUnidade)..where((e) => e.unidadeId.equals(unidade))).go();
          await db.batch((b) {
            for (final id in especiesIds) {
              b.insert(db.especiesUnidade,
                  EspeciesUnidadeCompanion.insert(unidadeId: unidade, especieId: id, ciclo: ciclo, fonte: Value(fonte)));
            }
          });
        }
      });

  /// Aplica uma planilha da Lista de EEI em UC federais: cadastra as espécies
  /// que faltam no catálogo e troca a lista das unidades presentes no arquivo.
  /// Linhas de UC que não estão em [unidadePorCnuc] (ainda não atendidas) são ignoradas.
  Future<ResultadoListaOficial> importarListaOficial(
    List<LinhaListaOficial> linhas, {
    required Map<String, String> unidadePorCnuc,
    required int ciclo,
    required String fonte,
  }) async {
    final porUnidade = <String, Set<String>>{};
    final cache = <String, String>{};
    final novas = <String>[];
    var ignoradas = 0;
    for (final l in linhas) {
      final unidade = unidadePorCnuc[l.cnuc];
      if (unidade == null) {
        ignoradas++;
        continue;
      }
      final chave = binomioNormalizado(l.especie);
      var id = cache[chave];
      if (id == null) {
        final existente = await porNomeCientifico(l.especie);
        if (existente != null) {
          id = existente.id;
          if (existente.naListaOficialIcmbio != true) {
            await (db.update(db.especies)..where((e) => e.id.equals(existente.id)))
                .write(const EspeciesCompanion(naListaOficialIcmbio: Value(true)));
          }
        } else {
          id = await _cadastrarDaLista(l, fonte);
          novas.add(id);
        }
        cache[chave] = id;
      }
      porUnidade.putIfAbsent(unidade, () => {}).add(id);
    }
    final antes = <String, Set<String>>{};
    for (final u in porUnidade.keys) {
      antes[u] = await observarListaOficial(u).first;
    }
    await substituirListaOficial(porUnidade, ciclo: ciclo, fonte: fonte);
    return ResultadoListaOficial(
      unidades: porUnidade.length,
      especiesNovasNoCatalogo: novas,
      linhasIgnoradas: ignoradas,
      antes: antes,
      depois: porUnidade,
    );
  }

  /// Espécie da lista oficial que ainda não está no catálogo (dados básicos da planilha).
  Future<String> _cadastrarDaLista(LinhaListaOficial l, String fonte) async {
    final todas = await db.select(db.especies).get();
    final id = idNovaEspecie(l.especie, {for (final e in todas) e.id});
    final nomes = [
      for (final n in (l.nomePopular ?? '').split(RegExp(r'[,;	]')))
        if (n.trim().length > 2 && n.trim()[0] == n.trim()[0].toLowerCase()) n.trim(),
    ];
    final agora = agoraUtc();
    await db.into(db.especies).insert(EspeciesCompanion.insert(
          id: id,
          prefixo: sugerirPrefixo(nomes.isNotEmpty ? nomes.first : l.especie, {for (final e in todas) e.prefixo}),
          nomeCientifico: l.autor == null ? l.especie : '${l.especie} ${l.autor}',
          nomesPopulares: nomes.take(5).toList(),
          formaVida: grupoListaOficial(l.grupo, animal: l.animal),
          metodosSugeridos: const [],
          fotosReferencia: const [],
          ordem: Value(todas.length + 100),
          ambientesInvasao: Value(l.ambiente == null ? null : 'Ambiente: ${l.ambiente}'),
          naListaOficialIcmbio: const Value(true),
          reino: Value(l.animal ? Reino.animal : Reino.planta),
          fonte: Value(fonte),
          createdAt: agora,
          updatedAt: agora,
        ));
    return id;
  }

  // ------------------------------------------------------------ guia

  /// Ocorrências, registros e foto de cada espécie numa unidade.
  Stream<Map<String, ResumoEspecie>> observarResumos(String unidadeId) {
    final contagens = db.customSelect(
      '''
      SELECT f.especie_id AS especie,
             COUNT(DISTINCT f.id) AS ocorrencias,
             COUNT(DISTINCT CASE WHEN f.status IN ('${StatusFoco.detectado}', '${StatusFoco.emControle}', '${StatusFoco.rebrotou}')
                   THEN f.id END) AS ativas,
             COUNT(o.id) AS registros
      FROM focos f
      LEFT JOIN observacoes o ON o.foco_id = f.id AND o.deleted = 0
      WHERE f.deleted = 0 AND f.status != '${StatusFoco.descartado}' AND f.unidade_id = ?
      GROUP BY f.especie_id
      ''',
      variables: [Variable.withString(unidadeId)],
      readsFrom: {db.focos, db.observacoes},
    );
    // Foto do catálogo primeiro; depois a mais recente dos registros da unidade.
    final fotos = db.customSelect(
      '''
      SELECT especie, caminho FROM (
        SELECT m.dono_id AS especie, m.caminho_local AS caminho, 0 AS prioridade, m.tirada_em AS quando
        FROM midias m
        WHERE m.dono_tipo = '$donoEspecie' AND m.deleted = 0 AND m.caminho_local IS NOT NULL
        UNION ALL
        SELECT f.especie_id, m.caminho_local, 1, m.tirada_em
        FROM midias m
        JOIN observacoes o ON o.id = m.dono_id
        JOIN focos f ON f.id = o.foco_id
        WHERE m.dono_tipo = 'observacao' AND m.deleted = 0 AND m.caminho_local IS NOT NULL
          AND f.deleted = 0 AND f.unidade_id = ?
      )
      ORDER BY prioridade ASC, quando DESC
      ''',
      variables: [Variable.withString(unidadeId)],
      readsFrom: {db.midias, db.observacoes, db.focos},
    );
    return contagens.watch().asyncMap((linhas) async {
      final fotoPor = <String, String>{};
      for (final l in await fotos.get()) {
        fotoPor.putIfAbsent(l.read<String>('especie'), () => l.read<String>('caminho'));
      }
      final r = <String, ResumoEspecie>{};
      for (final l in linhas) {
        final id = l.read<String>('especie');
        r[id] = ResumoEspecie(
          ocorrencias: l.read<int>('ocorrencias'),
          ativas: l.read<int>('ativas'),
          registros: l.read<int>('registros'),
          foto: fotoPor[id],
        );
      }
      for (final e in fotoPor.entries) {
        r.putIfAbsent(e.key, () => ResumoEspecie(foto: e.value));
      }
      return r;
    });
  }

  /// Fotos de referência de uma espécie (as do catálogo, não as dos registros).
  Stream<List<Midia>> observarFotosEspecie(String especieId) => (db.select(db.midias)
        ..where((m) => m.donoTipo.equals(donoEspecie) & m.donoId.equals(especieId) & m.deleted.equals(false))
        ..orderBy([(m) => OrderingTerm.asc(m.tiradaEm)]))
      .watch();

  /// Fotos dos registros de campo da espécie numa unidade (mais recentes primeiro).
  Stream<List<Midia>> observarFotosRegistros(String especieId, String unidadeId) {
    final q = db.select(db.midias).join([
      innerJoin(db.observacoes, db.observacoes.id.equalsExp(db.midias.donoId)),
      innerJoin(db.focos, db.focos.id.equalsExp(db.observacoes.focoId)),
    ])
      ..where(db.midias.donoTipo.equals('observacao') &
          db.midias.deleted.equals(false) &
          db.focos.deleted.equals(false) &
          db.focos.especieId.equals(especieId) &
          db.focos.unidadeId.equals(unidadeId))
      ..orderBy([OrderingTerm.desc(db.midias.tiradaEm)])
      ..limit(12);
    return q.watch().map((l) => [for (final x in l) x.readTable(db.midias)]);
  }

  // ------------------------------------------------------------ escrita

  /// Cadastra uma espécie nova no catálogo (fica pendente de sincronização).
  Future<Especie> cadastrar(DadosEspecie d, {required String usuarioId, required String unidadeId}) async {
    final todas = await db.select(db.especies).get();
    final id = idNovaEspecie(d.nomeCientifico, {for (final e in todas) e.id});
    final prefixo = sugerirPrefixo(
      d.nomesPopulares.isNotEmpty ? d.nomesPopulares.first : d.nomeCientifico,
      {for (final e in todas) e.prefixo},
    );
    final ultimaOrdem = todas.where((e) => e.id != especieOutra).fold<int>(0, (m, e) => e.ordem > m ? e.ordem : m);
    final agora = agoraUtc();
    await db.into(db.especies).insert(EspeciesCompanion.insert(
          id: id,
          prefixo: prefixo,
          nomeCientifico: d.nomeCientifico.trim(),
          nomesPopulares: d.nomesPopulares,
          familia: Value(_nulo(d.familia)),
          formaVida: d.formaVida,
          descricaoIdentificacao: Value(_nulo(d.descricaoIdentificacao)),
          confusaoCom: Value(_nulo(d.confusaoCom)),
          controleCitado: Value(_nulo(d.controleCitado)),
          metodosSugeridos: d.metodosSugeridos,
          fotosReferencia: const [],
          ordem: Value(ultimaOrdem + 1),
          origemNativa: Value(_nulo(d.origemNativa)),
          ambientesInvasao: Value(_nulo(d.ambientesInvasao)),
          impactos: Value(_nulo(d.impactos)),
          nativaBrasil: Value(d.nativaBrasil),
          fonte: const Value('Cadastrada pela equipe no BioLume'),
          reino: Value(d.reino),
          criadoPor: Value(usuarioId),
          unidadeOrigem: Value(unidadeId),
          createdAt: agora,
          updatedAt: agora,
        ));
    return (await especie(id))!;
  }

  /// Edita os dados de uma espécie (catálogo inicial ou cadastrada no app).
  Future<void> editar(Especie atual, DadosEspecie d) =>
      (db.update(db.especies)..where((e) => e.id.equals(atual.id))).write(EspeciesCompanion(
        nomeCientifico: Value(d.nomeCientifico.trim()),
        nomesPopulares: Value(d.nomesPopulares),
        familia: Value(_nulo(d.familia)),
        formaVida: Value(d.formaVida),
        descricaoIdentificacao: Value(_nulo(d.descricaoIdentificacao)),
        confusaoCom: Value(_nulo(d.confusaoCom)),
        controleCitado: Value(_nulo(d.controleCitado)),
        metodosSugeridos: Value(d.metodosSugeridos),
        origemNativa: Value(_nulo(d.origemNativa)),
        ambientesInvasao: Value(_nulo(d.ambientesInvasao)),
        impactos: Value(_nulo(d.impactos)),
        nativaBrasil: Value(d.nativaBrasil),
        reino: Value(d.reino),
        updatedAt: Value(agoraUtc()),
        syncStatus: const Value(SyncStatus.pendente),
        version: Value(atual.version + 1),
      ));

  Future<void> adicionarFoto(String especieId, FotoCapturada f) async {
    final agora = agoraUtc();
    await db.into(db.midias).insert(MidiasCompanion.insert(
          id: _uuid.v4(),
          donoTipo: donoEspecie,
          donoId: especieId,
          caminhoLocal: Value(f.caminho),
          lat: Value(f.lat),
          lon: Value(f.lon),
          tiradaEm: f.tiradaEm,
          tamanhoBytes: Value(f.tamanhoBytes),
          createdAt: agora,
          updatedAt: agora,
        ));
  }

  /// RN23: exclusão lógica.
  Future<void> removerFoto(Midia m) =>
      (db.update(db.midias)..where((x) => x.id.equals(m.id))).write(MidiasCompanion(
        deleted: const Value(true),
        updatedAt: Value(agoraUtc()),
        syncStatus: const Value(SyncStatus.pendente),
        version: Value(m.version + 1),
      ));

  static String? _nulo(String? s) => (s == null || s.trim().isEmpty) ? null : s.trim();
}
