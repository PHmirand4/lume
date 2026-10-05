import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/data/geo/limite_flona.dart';
import 'package:lume/data/local/database.dart';
import 'package:lume/data/local/seed.dart';
import 'package:lume/data/repositories/catalogo_repository.dart';
import 'package:lume/data/repositories/foco_repository.dart';
import 'package:lume/domain/codigos.dart';
import 'package:lume/domain/regras.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late FocoRepository repo;
  late LimiteFlona limite;
  const cfg = RegrasConfig();
  const usuario = 'usuario-teste';
  const dentro = Posicao(lat: -20.7453, lon: -41.2914, precisaoM: 6);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await Seeder(db).executar();
    limite = await LimiteFlona.carregar();
    repo = FocoRepository(db, CatalogoRepository(db), limite);
  });

  tearDown(() => db.close());

  test('seed carrega 10 espécies + "outra" e os vocabulários', () async {
    final especies = await db.select(db.especies).get();
    expect(especies, hasLength(11));
    final metodos = await (db.select(db.listaValores)..where((v) => v.lista.equals(Listas.metodoManejo))).get();
    expect(metodos.map((m) => m.codigo), contains('anelamento_herbicida'));
    // Rodar de novo não duplica.
    await Seeder(db).executar();
    expect(await db.select(db.especies).get(), hasLength(11));
  });

  test('limite oficial da Flona contém a coordenada de referência', () {
    expect(limite.contem(LimiteFlona.referencia), isTrue);
    expect(limite.contem(dentro.ponto), isTrue);
  });

  test('detecção cria foco + observação, com código sequencial e pendente de sync', () async {
    final r1 = await repo.registrarDeteccao(
      especieId: 'artocarpus_heterophyllus',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: dentro, nIndividuos: 12, quantificacaoTipo: 'contagem'),
      cfg: cfg,
    );
    expect(r1.codigo, 'JAQ-0001');
    expect(r1.motivosPrecoce, contains('Primeira ocorrência da espécie na Flona'));

    final r2 = await repo.registrarDeteccao(
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
      especieId: 'tradescantia_zebrina',
      usuarioId: usuario,
      dados: DadosObservacao(posicao: dentro, areaM2: 30, quantificacaoTipo: 'area'),
      cfg: cfg,
    );
    final proximos = await repo.focosProximos(
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
}
