import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/geo.dart';
import 'package:lume/data/geo/unidades.dart';
import 'package:lume/data/local/database.dart';
import 'package:lume/data/local/seed.dart';
import 'package:lume/data/repositories/catalogo_repository.dart';
import 'package:lume/data/repositories/foco_repository.dart';
import 'package:lume/domain/codigos.dart';
import 'package:lume/domain/importacao.dart';
import 'package:lume/domain/regras.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late FocoRepository repo;
  late CatalogoUnidades unidades;
  late Unidade pacotuba;
  late CatalogoRepository catalogo;
  const cfg = RegrasConfig();
  const usuario = 'usuario-teste';
  const dentro = Posicao(lat: -20.7453, lon: -41.2914, precisaoM: 6);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await Seeder(db).executar();
    unidades = await CatalogoUnidades.carregar();
    pacotuba = unidades.porId(CatalogoUnidades.padrao)!;
    catalogo = CatalogoRepository(db);
    repo = FocoRepository(db, catalogo, unidades);
  });

  tearDown(() => db.close());

  test('seed carrega o catálogo nacional, as 10 de Pacotuba e os vocabulários', () async {
    final especies = await db.select(db.especies).get();
    expect(especies.length, greaterThan(250));
    final ids = especies.map((e) => e.id).toSet();
    for (final id in ['acacia_mangium', 'artocarpus_heterophyllus', 'tradescantia_zebrina', 'muntingia_calabura', especieOutra]) {
      expect(ids, contains(id));
    }
    expect(especies.map((e) => e.prefixo).toSet(), hasLength(especies.length), reason: 'prefixos únicos');
    final jaqueira = especies.firstWhere((e) => e.id == 'artocarpus_heterophyllus');
    expect(jaqueira.prefixo, 'JAQ');
    expect(jaqueira.origemNativa, isNotNull);
    final metodos = await (db.select(db.listaValores)..where((v) => v.lista.equals(Listas.metodoManejo))).get();
    expect(metodos.map((m) => m.codigo), contains('anelamento_herbicida'));
    // Rodar de novo não duplica.
    await Seeder(db).executar();
    expect(await db.select(db.especies).get(), hasLength(especies.length));
  });

  test('catálogo de unidades: 68 Flonas com limites oficiais', () {
    expect(unidades.todas.length, 68);
    expect(pacotuba.contem(const GeoPonto(-20.7453, -41.2914)), isTrue);
    expect(pacotuba.contem(dentro.ponto), isTrue);
    expect(unidades.porId('flona_tapajos')!.contem(dentro.ponto), isFalse);
  });

  test('focos ficam na unidade em que foram registrados', () async {
    await repo.registrarDeteccao(
      unidadeId: pacotuba.id,
      especieId: 'acacia_mangium',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: dentro, nIndividuos: 2),
      cfg: cfg,
    );
    final r = await repo.registrarDeteccao(
      unidadeId: 'flona_rio_preto',
      especieId: 'acacia_mangium',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: dentro, nIndividuos: 2),
      cfg: cfg,
    );
    // Código e detecção precoce contam só a unidade.
    expect(r.codigo, 'ACA-0001');
    expect(r.motivosPrecoce, contains('Primeira ocorrência da espécie na Flona'));
    expect(await repo.observarFocos(unidadeId: pacotuba.id).first, hasLength(1));
    expect(await repo.observarFocos(unidadeId: 'flona_rio_preto').first, hasLength(1));
    final foco = await (db.select(db.focos)..where((f) => f.id.equals(r.focoId))).getSingle();
    expect(foco.foraDoLimite, isTrue, reason: 'ponto de Pacotuba fica fora da Flona do Rio Preto');
    final resumos = await catalogo.observarResumos(pacotuba.id).first;
    expect(resumos['acacia_mangium']!.ocorrencias, 1);
    expect(resumos['acacia_mangium']!.registros, 1);
  });

  test('espécie nova entra no catálogo com id, prefixo único e pendente de sync', () async {
    final e = await catalogo.cadastrar(
      DadosEspecie(nomeCientifico: 'Coffea arabica L.', nomesPopulares: ['cafeeiro-teste'], formaVida: 'arbusto'),
      usuarioId: usuario,
      unidadeId: pacotuba.id,
    );
    expect(e.id, startsWith('coffea_arabica'));
    expect(e.syncStatus, SyncStatus.pendente);
    expect(e.criadoPor, usuario);
    final prefixos = (await db.select(db.especies).get()).map((x) => x.prefixo).toList();
    expect(prefixos.where((p) => p == e.prefixo), hasLength(1));
    expect((await catalogo.procurar('Coffea arabica'))?.id, e.id);
    expect((await catalogo.procurar('Jaqueira'))?.id, 'artocarpus_heterophyllus');
  });

  test('importação grava focos, reconhece a espécie e não duplica ao importar de novo', () async {
    final linhas = [
      ['Código', 'Espécie', 'Latitude', 'Longitude', 'Data', 'Nº indivíduos'],
      ['P1', 'Artocarpus heterophyllus', '-20,7453', '-41,2914', '05/03/2025', '3'],
      ['P2', 'planta estranha', '20°44\'43"S', '41°17\'29"O', '2025-04-01', ''],
      ['P3', 'jaqueira', '', '', '', ''],
    ];
    final registros = interpretarLinhas(linhas.skip(1).toList(), detectarColunas(linhas.first));
    var r = await repo.importar(unidadeId: pacotuba.id, usuarioId: usuario, arquivo: 'teste.xlsx', registros: registros);
    expect(r.novos, 2);
    expect(r.invalidos, 1);
    expect(r.semEspecie, 1);
    final focos = await repo.observarFocos(unidadeId: pacotuba.id).first;
    expect(focos.map((f) => f.foco.especieId).toSet(), {'artocarpus_heterophyllus', especieOutra});
    expect(focos.firstWhere((f) => f.foco.especieId == especieOutra).foco.especieTexto, 'planta estranha');
    r = await repo.importar(unidadeId: pacotuba.id, usuarioId: usuario, arquivo: 'teste.xlsx', registros: registros);
    expect(r.novos, 0);
    expect(r.repetidos, 2);
  });

  test('detecção cria foco + observação, com código sequencial e pendente de sync', () async {
    final r1 = await repo.registrarDeteccao(
      unidadeId: pacotuba.id,
      especieId: 'artocarpus_heterophyllus',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: dentro, nIndividuos: 12, quantificacaoTipo: 'contagem'),
      cfg: cfg,
    );
    expect(r1.codigo, 'JAQ-0001');
    expect(r1.motivosPrecoce, contains('Primeira ocorrência da espécie na Flona'));

    final r2 = await repo.registrarDeteccao(
      unidadeId: pacotuba.id,
      especieId: 'artocarpus_heterophyllus',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: const Posicao(lat: -20.7400, lon: -41.2914), nIndividuos: 40),
      cfg: cfg,
    );
    expect(r2.codigo, 'JAQ-0002');

    final foco = await (db.select(db.focos)..where((f) => f.id.equals(r1.focoId))).getSingle();
    expect(foco.status, StatusFoco.detectado);
    expect(foco.syncStatus, SyncStatus.pendente);
    expect(foco.ultimaAbundancia, '12 ind.');
    expect(foco.foraDoLimite, isFalse);
    final obs = await (db.select(db.observacoes)..where((o) => o.focoId.equals(r1.focoId))).get();
    expect(obs.single.tipo, TipoObservacao.deteccao);
  });

  test('ponto fora do limite é marcado (RN05)', () async {
    final r = await repo.registrarDeteccao(
      unidadeId: pacotuba.id,
      especieId: 'acacia_mangium',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: const Posicao(lat: -20.80, lon: -41.20), nIndividuos: 3),
      cfg: cfg,
    );
    final foco = await (db.select(db.focos)..where((f) => f.id.equals(r.focoId))).getSingle();
    expect(foco.foraDoLimite, isTrue);
  });

  test('"outra espécie" sem foto é recusada (RN18)', () async {
    expect(
      () => repo.registrarDeteccao(
        unidadeId: pacotuba.id,
        especieId: especieOutra,
        usuarioId: usuario,
        dados: DadosObservacao(posicao: dentro, nIndividuos: 1),
        cfg: cfg,
      ),
      throwsArgumentError,
    );
  });

  test('ciclo: manejo → em controle; revisita ausente → controlado; foco próximo é encontrado', () async {
    final r = await repo.registrarDeteccao(
      unidadeId: pacotuba.id,
      especieId: 'tradescantia_zebrina',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: dentro, areaM2: 30, quantificacaoTipo: 'area'),
      cfg: cfg,
    );
    final proximos = await repo.focosProximos(
        unidadeId: pacotuba.id,
        especieId: 'tradescantia_zebrina', posicao: const Posicao(lat: -20.74535, lon: -41.2914, precisaoM: 5), cfg: cfg);
    expect(proximos.single.$1.foco.id, r.focoId);

    await repo.registrarManejo(
      focoId: r.focoId,
      usuarioId: usuario,
      dados: DadosManejo(metodo: 'arranquio', responsavel: 'Equipe', nPessoas: 2, horas: 1.5),
      cfg: cfg,
    );
    var foco = await (db.select(db.focos)..where((f) => f.id.equals(r.focoId))).getSingle();
    expect(foco.status, StatusFoco.emControle);

    await repo.registrarRevisita(
      focoId: r.focoId,
      usuarioId: usuario,
      dados: DadosObservacao(
        posicao: dentro,
        presenca: Presenca.ausente,
        resultado: ResultadoRevisita.ausente,
        dataHora: DateTime.now().toUtc().add(const Duration(minutes: 5)),
      ),
      cfg: cfg,
    );
    foco = await (db.select(db.focos)..where((f) => f.id.equals(r.focoId))).getSingle();
    expect(foco.status, StatusFoco.controlado);
    expect(foco.ultimaAbundancia, 'ausente');

    final linha = await repo.linhaDoTempo(r.focoId);
    expect(linha, hasLength(3));
  });

  test('manejo químico sem produto é recusado (RN20)', () async {
    final r = await repo.registrarDeteccao(
      unidadeId: pacotuba.id,
      especieId: 'acacia_mangium',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: dentro, nIndividuos: 2),
      cfg: cfg,
    );
    expect(
      () => repo.registrarManejo(
        focoId: r.focoId,
        usuarioId: usuario,
        dados: DadosManejo(metodo: 'corte_herbicida', responsavel: 'Equipe', nPessoas: 1, horas: 1),
        cfg: cfg,
      ),
      throwsArgumentError,
    );
  });

  test('status manual do gestor não é sobrescrito pelo cálculo (RN14)', () async {
    final r = await repo.registrarDeteccao(
      unidadeId: pacotuba.id,
      especieId: 'acacia_mangium',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: dentro, nIndividuos: 2),
      cfg: cfg,
    );
    await repo.alterarStatusManual(focoId: r.focoId, status: StatusFoco.descartado, usuarioId: 'gestor');
    await repo.registrarManejo(
      focoId: r.focoId,
      usuarioId: usuario,
      dados: DadosManejo(metodo: 'corte_raso', responsavel: 'Equipe', nPessoas: 1, horas: 1),
      cfg: cfg,
    );
    var foco = await (db.select(db.focos)..where((f) => f.id.equals(r.focoId))).getSingle();
    expect(foco.status, StatusFoco.descartado);
    expect(foco.statusAlteradoPor, 'gestor');

    await repo.voltarStatusAutomatico(r.focoId, cfg);
    foco = await (db.select(db.focos)..where((f) => f.id.equals(r.focoId))).getSingle();
    expect(foco.status, StatusFoco.emControle);
  });

  test('exclusão é lógica e recalcula o status (RN23)', () async {
    final r = await repo.registrarDeteccao(
      unidadeId: pacotuba.id,
      especieId: 'acacia_mangium',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: dentro, nIndividuos: 2),
      cfg: cfg,
    );
    await repo.registrarManejo(
      focoId: r.focoId,
      usuarioId: usuario,
      dados: DadosManejo(metodo: 'corte_raso', responsavel: 'Equipe', nPessoas: 1, horas: 1),
      cfg: cfg,
    );
    final manejo = await (db.select(db.acoesManejo)..where((m) => m.focoId.equals(r.focoId))).getSingle();
    await repo.excluirManejo(manejo, cfg);
    final ainda = await (db.select(db.acoesManejo)..where((m) => m.id.equals(manejo.id))).getSingle();
    expect(ainda.deleted, isTrue);
    final foco = await (db.select(db.focos)..where((f) => f.id.equals(r.focoId))).getSingle();
    expect(foco.status, StatusFoco.detectado);
  });

  test('lista oficial do ICMBio: Pacotuba tem plantas e animais; espécie fora da lista vira detecção precoce', () async {
    final lista = await catalogo.observarListaOficial(pacotuba.id).first;
    expect(lista, containsAll(['acacia_mangium', 'aquarana_catesbeiana', 'tradescantia_zebrina']));
    expect(lista, isNot(contains('artocarpus_heterophyllus')), reason: 'jaqueira não consta na lista de Pacotuba');
    final ra = (await catalogo.especie('aquarana_catesbeiana'))!;
    expect(ra.reino, 'animal');

    final dentroDaLista = await repo.registrarDeteccao(
      unidadeId: pacotuba.id,
      especieId: 'acacia_mangium',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: dentro, nIndividuos: 30),
      cfg: cfg,
    );
    expect(dentroDaLista.motivosPrecoce, isNot(contains(motivoForaDaLista)));
    final fora = await repo.registrarDeteccao(
      unidadeId: pacotuba.id,
      especieId: 'artocarpus_heterophyllus',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: dentro, nIndividuos: 30, bloco: 'B1', capCm: 42),
      cfg: cfg,
    );
    expect(fora.motivosPrecoce, contains(motivoForaDaLista));
    final obs = await (db.select(db.observacoes)..where((o) => o.focoId.equals(fora.focoId))).getSingle();
    expect(obs.bloco, 'B1');
    expect(obs.capCm, 42);
  });

  test('importar a lista oficial troca a lista da unidade e cadastra espécies que faltam', () async {
    final linhas = lerListaOficial([
      ['CNUC', 'Unidade de Conservação Federal', 'A espécie do registro é animal ou planta?', 'Grupo', 'Espécie',
        'Nome popular', 'Autor', 'Ambiente'],
      ['0000.00.0101', 'FLORESTA NACIONAL DE PACOTUBA', 'Planta', 'Árvore', 'Artocarpus heterophyllus', 'jaqueira',
        'Lam.', 'terrestre'],
      ['0000.00.0101', 'FLORESTA NACIONAL DE PACOTUBA', 'Animal', 'Invertebrado', 'Bichus inventadus', 'bicho-teste',
        'Fulano, 2026', 'terrestre'],
      ['0000.00.0001', 'ÁREA DE PROTEÇÃO AMBIENTAL ANHATOMIRIM', 'Planta', 'Árvore', 'Acacia mangium', 'acácia', 'Willd.',
        'terrestre'],
    ]);
    final r = await catalogo.importarListaOficial(
      linhas,
      unidadePorCnuc: {for (final u in unidades.todas) u.cnuc: u.id},
      ciclo: 2026,
      fonte: 'teste',
    );
    expect(r.unidades, 1);
    expect(r.linhasIgnoradas, 1);
    expect(r.especiesNovasNoCatalogo, ['bichus_inventadus']);
    expect(r.entraram(pacotuba.id), {'artocarpus_heterophyllus', 'bichus_inventadus'});
    expect(r.sairam(pacotuba.id), contains('acacia_mangium'));
    final novo = (await catalogo.especie('bichus_inventadus'))!;
    expect(novo.reino, 'animal');
    expect(novo.formaVida, 'invertebrado');
    expect(await catalogo.observarListaOficial(pacotuba.id).first, {'artocarpus_heterophyllus', 'bichus_inventadus'});
    expect(await catalogo.observarCicloLista().first, 2026);
  });
}
