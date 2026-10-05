import 'dart:io';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/geo.dart';
import '../../domain/codigos.dart';
import '../../domain/regras.dart';
import '../geo/limite_flona.dart';
import '../local/database.dart';
import 'catalogo_repository.dart';

const versaoApp = '1.0.0+1';
const _uuid = Uuid();

DateTime agoraUtc() => DateTime.now().toUtc();

/// Foto já capturada e comprimida, ainda não gravada no banco.
class FotoCapturada {
  const FotoCapturada({
    required this.caminho,
    required this.tiradaEm,
    this.lat,
    this.lon,
    this.tamanhoBytes,
    this.momento,
  });

  final String caminho;
  final DateTime tiradaEm;
  final double? lat;
  final double? lon;
  final int? tamanhoBytes;
  final String? momento;
}

/// Posição registrada (GPS, ajuste no mapa ou estimada).
class Posicao {
  const Posicao({
    required this.lat,
    required this.lon,
    this.precisaoM,
    this.altitudeM,
    this.origem = OrigemCoordenada.gpsAuto,
  });

  final double lat;
  final double lon;
  final double? precisaoM;
  final double? altitudeM;
  final String origem;

  GeoPonto get ponto => GeoPonto(lat, lon);
}

/// Dados de uma observação (detecção ou revisita) vindos do formulário.
class DadosObservacao {
  DadosObservacao({
    required this.posicao,
    this.presenca = Presenca.presente,
    this.resultado,
    this.quantificacaoTipo,
    this.nIndividuos,
    this.classeAbundancia,
    this.areaM2,
    this.coberturaPct,
    this.estagio,
    this.ambiente,
    this.texto,
    this.ditado = false,
    this.fotos = const [],
    DateTime? dataHora,
  }) : dataHora = dataHora ?? agoraUtc();

  final Posicao posicao;
  final String presenca;
  final String? resultado;
  final String? quantificacaoTipo;
  final int? nIndividuos;
  final String? classeAbundancia;
  final double? areaM2;
  final int? coberturaPct;
  final String? estagio;
  final String? ambiente;
  final String? texto;
  final bool ditado;
  final List<FotoCapturada> fotos;
  final DateTime dataHora;
}

class DadosManejo {
  DadosManejo({
    required this.metodo,
    required this.responsavel,
    required this.nPessoas,
    required this.horas,
    this.metodoTexto,
    this.herbicidaProduto,
    this.herbicidaConcentracao,
    this.herbicidaVolumeL,
    this.nIndividuosTratados,
    this.areaTratadaM2,
    this.destinacao,
    this.epiUtilizado,
    this.condicaoTempo,
    this.texto,
    this.fotos = const [],
    DateTime? inicio,
    this.fim,
  }) : inicio = inicio ?? agoraUtc();

  final String metodo;
  final String responsavel;
  final int nPessoas;
  final double horas;
  final String? metodoTexto;
  final String? herbicidaProduto;
  final String? herbicidaConcentracao;
  final double? herbicidaVolumeL;
  final int? nIndividuosTratados;
  final double? areaTratadaM2;
  final String? destinacao;
  final bool? epiUtilizado;
  final String? condicaoTempo;
  final String? texto;
  final List<FotoCapturada> fotos;
  final DateTime inicio;
  final DateTime? fim;
}

/// Foco com a espécie, para listas e mapa.
class FocoComEspecie {
  const FocoComEspecie(this.foco, this.especie);

  final Foco foco;
  final Especie especie;

  String get nomeExibicao => foco.especieId == especieOutra
      ? (foco.especieTexto?.isNotEmpty == true ? foco.especieTexto! : 'Outra espécie')
      : especie.nomesPopulares.first;

  GeoPonto get ponto => GeoPonto(foco.lat, foco.lon);
}

/// Item da linha do tempo de um foco.
sealed class ItemLinhaDoTempo {
  DateTime get data;
  List<Midia> get midias;
}

class ItemObservacao extends ItemLinhaDoTempo {
  ItemObservacao(this.obs, this.midias);

  final Observacao obs;
  @override
  final List<Midia> midias;
  @override
  DateTime get data => obs.dataHora;
}

class ItemManejo extends ItemLinhaDoTempo {
  ItemManejo(this.acao, this.midias);

  final AcaoManejo acao;
  @override
  final List<Midia> midias;
  @override
  DateTime get data => acao.dataHoraInicio;
}

/// Resultado de registrar uma detecção.
class ResultadoDeteccao {
  const ResultadoDeteccao({required this.focoId, required this.codigo, required this.motivosPrecoce});

  final String focoId;
  final String codigo;
  final List<String> motivosPrecoce;
}

class FocoRepository {
  FocoRepository(this.db, this.catalogo, this.limite);

  final AppDatabase db;
  final CatalogoRepository catalogo;
  final LimiteFlona limite;

  // ---------------------------------------------------------------- consultas

  Stream<List<FocoComEspecie>> observarFocos({bool incluirDescartados = true}) {
    final q = db.select(db.focos).join([
      innerJoin(db.especies, db.especies.id.equalsExp(db.focos.especieId)),
    ])
      ..where(db.focos.deleted.equals(false))
      ..orderBy([OrderingTerm.desc(db.focos.ultimaVisitaEm)]);
    if (!incluirDescartados) {
      q.where(db.focos.status.equals(StatusFoco.descartado).not());
    }
    return q.watch().map((linhas) => [
          for (final l in linhas) FocoComEspecie(l.readTable(db.focos), l.readTable(db.especies)),
        ]);
  }

  Stream<FocoComEspecie?> observarFoco(String id) {
    final q = db.select(db.focos).join([
      innerJoin(db.especies, db.especies.id.equalsExp(db.focos.especieId)),
    ])
      ..where(db.focos.id.equals(id));
    return q.watchSingleOrNull().map(
        (l) => l == null ? null : FocoComEspecie(l.readTable(db.focos), l.readTable(db.especies)));
  }

  /// Linha do tempo (mais recente primeiro). Reemite quando observações,
  /// manejos ou mídias mudam.
  Stream<List<ItemLinhaDoTempo>> observarLinhaDoTempo(String focoId) async* {
    yield await linhaDoTempo(focoId);
    await for (final _ in db.tableUpdates(
        TableUpdateQuery.onAllTables([db.observacoes, db.acoesManejo, db.midias]))) {
      yield await linhaDoTempo(focoId);
    }
  }

  Future<List<ItemLinhaDoTempo>> linhaDoTempo(String focoId) async {
    final obs = await (db.select(db.observacoes)
          ..where((o) => o.focoId.equals(focoId) & o.deleted.equals(false)))
        .get();
    final manejos = await (db.select(db.acoesManejo)
          ..where((m) => m.focoId.equals(focoId) & m.deleted.equals(false)))
        .get();
    final donos = [...obs.map((o) => o.id), ...manejos.map((m) => m.id)];
    final midias = donos.isEmpty
        ? <Midia>[]
        : await (db.select(db.midias)
              ..where((m) => m.donoId.isIn(donos) & m.deleted.equals(false))
              ..orderBy([(m) => OrderingTerm.asc(m.tiradaEm)]))
            .get();
    List<Midia> de(String id) => midias.where((m) => m.donoId == id).toList();
    return <ItemLinhaDoTempo>[
      for (final o in obs) ItemObservacao(o, de(o.id)),
      for (final m in manejos) ItemManejo(m, de(m.id)),
    ]..sort((a, b) => b.data.compareTo(a.data));
  }

  Future<List<FocoResumo>> resumos() async {
    final focos = await (db.select(db.focos)..where((f) => f.deleted.equals(false))).get();
    return [
      for (final f in focos)
        FocoResumo(id: f.id, especieId: f.especieId, ponto: GeoPonto(f.lat, f.lon), status: f.status),
    ];
  }

  Future<List<(FocoComEspecie, double)>> focosProximos({
    required String especieId,
    required Posicao posicao,
    required RegrasConfig cfg,
  }) async {
    final achados = focosProximosMesmaEspecie(
      especieId: especieId,
      ponto: posicao.ponto,
      precisaoM: posicao.precisaoM,
      focos: await resumos(),
      cfg: cfg,
    );
    final res = <(FocoComEspecie, double)>[];
    for (final (f, d) in achados) {
      final fe = await observarFoco(f.id).first;
      if (fe != null) res.add((fe, d));
    }
    return res;
  }

  Future<Midia?> primeiraFoto(String focoId) async {
    final q = db.select(db.midias).join([
      innerJoin(db.observacoes, db.observacoes.id.equalsExp(db.midias.donoId)),
    ])
      ..where(db.observacoes.focoId.equals(focoId) & db.midias.deleted.equals(false))
      ..orderBy([OrderingTerm.asc(db.midias.tiradaEm)])
      ..limit(1);
    final l = await q.getSingleOrNull();
    return l?.readTable(db.midias);
  }

  // ---------------------------------------------------------------- escrita

  /// RN06: toda detecção cria um foco e uma observação do tipo `deteccao`.
  Future<ResultadoDeteccao> registrarDeteccao({
    required String especieId,
    String? especieTexto,
    required String usuarioId,
    required DadosObservacao dados,
    required RegrasConfig cfg,
  }) async {
    final especie = await catalogo.especie(especieId);
    if (especie == null) throw StateError('Espécie desconhecida: $especieId');
    if (especieId == especieOutra && dados.fotos.isEmpty) {
      throw ArgumentError('RN18: "Outra espécie" exige ao menos 1 foto.');
    }

    final motivos = motivosDeteccaoPrecoce(
      especieId: especieId,
      ponto: dados.posicao.ponto,
      focosExistentes: await resumos(),
      cfg: cfg,
      nIndividuos: dados.nIndividuos,
      classeAbundancia: dados.classeAbundancia,
      areaM2: dados.areaM2,
    );
    final vocab = await catalogo.vocabulario();
    final focoId = _uuid.v4();
    final agora = agoraUtc();
    late String codigo;

    await db.transaction(() async {
      codigo = await _proximoCodigo(especie.prefixo);
      await db.into(db.focos).insert(FocosCompanion.insert(
            id: focoId,
            especieId: especieId,
            especieTexto: Value(especieTexto),
            codigo: codigo,
            lat: dados.posicao.lat,
            lon: dados.posicao.lon,
            precisaoM: Value(dados.posicao.precisaoM),
            origemCoordenada: dados.posicao.origem,
            ambiente: Value(dados.ambiente),
            status: StatusFoco.detectado,
            deteccaoPrecoce: Value(motivos.isNotEmpty),
            motivosPrecoce: Value(motivos),
            foraDoLimite: Value(!limite.contem(dados.posicao.ponto)),
            criadoPor: usuarioId,
            primeiraDeteccaoEm: dados.dataHora,
            ultimaVisitaEm: dados.dataHora,
            ultimaAbundancia: Value(resumoAbundancia(dados, vocab)),
            createdAt: agora,
            updatedAt: agora,
          ));
      await _inserirObservacao(focoId, TipoObservacao.deteccao, usuarioId, dados);
    });
    return ResultadoDeteccao(focoId: focoId, codigo: codigo, motivosPrecoce: motivos);
  }

  /// Revisita (inclusive quando a detecção é reconhecida como "o mesmo foco").
  Future<void> registrarRevisita({
    required String focoId,
    required String usuarioId,
    required DadosObservacao dados,
    required RegrasConfig cfg,
  }) async {
    final vocab = await catalogo.vocabulario();
    await db.transaction(() async {
      await _inserirObservacao(focoId, TipoObservacao.revisita, usuarioId, dados);
      final foco = await _foco(focoId);
      final ultima = dados.dataHora.isAfter(foco.ultimaVisitaEm) ? dados.dataHora : foco.ultimaVisitaEm;
      await _atualizarFoco(foco, FocosCompanion(
        ultimaVisitaEm: Value(ultima),
        ultimaAbundancia: dados.presenca == Presenca.ausente
            ? const Value('ausente')
            : Value(resumoAbundancia(dados, vocab) ?? foco.ultimaAbundancia),
      ));
      await recalcularStatus(focoId, cfg);
    });
  }

  Future<void> registrarManejo({
    required String focoId,
    required String usuarioId,
    required DadosManejo dados,
    required RegrasConfig cfg,
  }) async {
    if (manejoExigeHerbicida(dados.metodo) && (dados.herbicidaProduto?.trim().isEmpty ?? true)) {
      throw ArgumentError('RN20: manejo químico exige o produto.');
    }
    final id = _uuid.v4();
    final agora = agoraUtc();
    await db.transaction(() async {
      await db.into(db.acoesManejo).insert(AcoesManejoCompanion.insert(
            id: id,
            focoId: focoId,
            usuarioId: usuarioId,
            responsavel: dados.responsavel,
            dataHoraInicio: dados.inicio,
            dataHoraFim: Value(dados.fim),
            metodo: dados.metodo,
            metodoTexto: Value(dados.metodoTexto),
            herbicidaProduto: Value(dados.herbicidaProduto),
            herbicidaConcentracao: Value(dados.herbicidaConcentracao),
            herbicidaVolumeL: Value(dados.herbicidaVolumeL),
            nIndividuosTratados: Value(dados.nIndividuosTratados),
            areaTratadaM2: Value(dados.areaTratadaM2),
            nPessoas: dados.nPessoas,
            horas: dados.horas,
            destinacao: Value(dados.destinacao),
            epiUtilizado: Value(dados.epiUtilizado),
            condicaoTempo: Value(dados.condicaoTempo),
            texto: Value(dados.texto),
            createdAt: agora,
            updatedAt: agora,
          ));
      await _inserirMidias('acao_manejo', id, dados.fotos);
      final foco = await _foco(focoId);
      if (dados.inicio.isAfter(foco.ultimaVisitaEm)) {
        await _atualizarFoco(foco, FocosCompanion(ultimaVisitaEm: Value(dados.inicio)));
      }
      await recalcularStatus(focoId, cfg);
    });
  }

  /// RN14: o gestor pode sobrescrever o status (inclusive `descartado`).
  Future<void> alterarStatusManual({
    required String focoId,
    required String status,
    required String usuarioId,
  }) async {
    final foco = await _foco(focoId);
    await _atualizarFoco(foco, FocosCompanion(
      status: Value(status),
      statusManual: const Value(true),
      statusAlteradoPor: Value(usuarioId),
      statusAlteradoEm: Value(agoraUtc()),
    ));
  }

  Future<void> voltarStatusAutomatico(String focoId, RegrasConfig cfg) async {
    final foco = await _foco(focoId);
    await _atualizarFoco(foco, const FocosCompanion(statusManual: Value(false)));
    await recalcularStatus(focoId, cfg);
  }

  /// Ajuste manual da posição de referência do foco (RN03/RN04).
  Future<void> ajustarPosicao(String focoId, GeoPonto p) async {
    final foco = await _foco(focoId);
    await _atualizarFoco(foco, FocosCompanion(
      lat: Value(p.lat),
      lon: Value(p.lon),
      origemCoordenada: const Value(OrigemCoordenada.gpsAjustado),
      foraDoLimite: Value(!limite.contem(p)),
    ));
  }

  /// RN23: exclusão lógica.
  Future<void> excluirObservacao(Observacao o, RegrasConfig cfg) async {
    await db.transaction(() async {
      await (db.update(db.observacoes)..where((t) => t.id.equals(o.id))).write(ObservacoesCompanion(
        deleted: const Value(true),
        updatedAt: Value(agoraUtc()),
        syncStatus: const Value(SyncStatus.pendente),
        version: Value(o.version + 1),
      ));
      await recalcularStatus(o.focoId, cfg);
    });
  }

  Future<void> excluirManejo(AcaoManejo m, RegrasConfig cfg) async {
    await db.transaction(() async {
      await (db.update(db.acoesManejo)..where((t) => t.id.equals(m.id))).write(AcoesManejoCompanion(
        deleted: const Value(true),
        updatedAt: Value(agoraUtc()),
        syncStatus: const Value(SyncStatus.pendente),
        version: Value(m.version + 1),
      ));
      await recalcularStatus(m.focoId, cfg);
    });
  }

  /// Recalcula o status automático (RN09–RN13). Não mexe em status manual.
  /// Retorna true se o status mudou.
  Future<bool> recalcularStatus(String focoId, RegrasConfig cfg) async {
    final foco = await _foco(focoId);
    if (foco.statusManual) return false;
    final obs = await (db.select(db.observacoes)
          ..where((o) => o.focoId.equals(focoId) & o.deleted.equals(false)))
        .get();
    final manejos = await (db.select(db.acoesManejo)
          ..where((m) => m.focoId.equals(focoId) & m.deleted.equals(false)))
        .get();
    final novo = calcularStatus([
      for (final o in obs)
        EventoFoco(
          tipo: o.tipo == TipoObservacao.deteccao ? TipoEvento.deteccao : TipoEvento.revisita,
          data: o.dataHora,
          presenca: o.presenca,
          resultado: o.resultado,
        ),
      for (final m in manejos) EventoFoco(tipo: TipoEvento.manejo, data: m.dataHoraInicio),
    ], cfg);
    if (novo == foco.status) return false;
    await _atualizarFoco(foco, FocosCompanion(status: Value(novo)));
    return true;
  }

  // ---------------------------------------------------------------- internos

  Future<Foco> _foco(String id) =>
      (db.select(db.focos)..where((f) => f.id.equals(id))).getSingle();

  Future<void> _atualizarFoco(Foco atual, FocosCompanion mudancas) =>
      (db.update(db.focos)..where((f) => f.id.equals(atual.id))).write(mudancas.copyWith(
        updatedAt: Value(agoraUtc()),
        syncStatus: const Value(SyncStatus.pendente),
        version: Value(atual.version + 1),
      ));

  /// Código legível: prefixo da espécie + sequencial (ex.: JAQ-0042).
  Future<String> _proximoCodigo(String prefixo) async {
    final linhas = await (db.selectOnly(db.focos)
          ..addColumns([db.focos.codigo])
          ..where(db.focos.codigo.like('$prefixo-%')))
        .get();
    var maior = 0;
    for (final l in linhas) {
      final n = int.tryParse(l.read(db.focos.codigo)!.split('-').last) ?? 0;
      if (n > maior) maior = n;
    }
    return '$prefixo-${(maior + 1).toString().padLeft(4, '0')}';
  }

  Future<void> _inserirObservacao(
      String focoId, String tipo, String usuarioId, DadosObservacao d) async {
    final id = _uuid.v4();
    final agora = agoraUtc();
    await db.into(db.observacoes).insert(ObservacoesCompanion.insert(
          id: id,
          focoId: focoId,
          tipo: tipo,
          usuarioId: usuarioId,
          dataHora: d.dataHora,
          lat: d.posicao.lat,
          lon: d.posicao.lon,
          precisaoM: Value(d.posicao.precisaoM),
          altitudeM: Value(d.posicao.altitudeM),
          presenca: d.presenca,
          resultado: Value(d.resultado),
          quantificacaoTipo: Value(d.quantificacaoTipo),
          nIndividuos: Value(d.nIndividuos),
          classeAbundancia: Value(d.classeAbundancia),
          areaM2: Value(d.areaM2),
          coberturaPct: Value(d.coberturaPct),
          estagio: Value(d.estagio),
          ambiente: Value(d.ambiente),
          texto: Value(d.texto),
          ditado: Value(d.ditado),
          dispositivo: Value(_dispositivo()),
          versaoApp: const Value(versaoApp),
          createdAt: agora,
          updatedAt: agora,
        ));
    await _inserirMidias('observacao', id, d.fotos);
  }

  Future<void> _inserirMidias(String donoTipo, String donoId, List<FotoCapturada> fotos) async {
    final agora = agoraUtc();
    for (final f in fotos) {
      await db.into(db.midias).insert(MidiasCompanion.insert(
            id: _uuid.v4(),
            donoTipo: donoTipo,
            donoId: donoId,
            momento: Value(f.momento),
            caminhoLocal: Value(f.caminho),
            lat: Value(f.lat),
            lon: Value(f.lon),
            tiradaEm: f.tiradaEm,
            tamanhoBytes: Value(f.tamanhoBytes),
            createdAt: agora,
            updatedAt: agora,
          ));
    }
  }

  static String _dispositivo() {
    try {
      return '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
    } catch (_) {
      return 'desconhecido';
    }
  }
}

/// Resumo curto da quantidade observada (ex.: "12 ind.", "6–20", "35 m²").
String? resumoAbundancia(DadosObservacao d, Vocabulario vocab) {
  if (d.presenca == Presenca.ausente) return 'ausente';
  final partes = <String>[
    if (d.nIndividuos != null) '${d.nIndividuos} ind.',
    if (d.classeAbundancia != null) vocab.rotulo(Listas.classeAbundancia, d.classeAbundancia),
    if (d.areaM2 != null) '${_num(d.areaM2!)} m²',
    if (d.coberturaPct != null) '${d.coberturaPct}%',
  ];
  return partes.isEmpty ? null : partes.join(' · ');
}

String _num(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1).replaceAll('.', ',');
