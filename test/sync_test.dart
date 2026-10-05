import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/data/geo/limite_flona.dart';
import 'package:lume/data/local/database.dart';
import 'package:lume/data/local/seed.dart';
import 'package:lume/data/repositories/catalogo_repository.dart';
import 'package:lume/data/repositories/config_repository.dart';
import 'package:lume/data/repositories/foco_repository.dart';
import 'package:lume/data/sync/sync_service.dart';
import 'package:lume/domain/codigos.dart';
import 'package:lume/domain/regras.dart';

/// Colunas de cada tabela, lidas das migrações do Supabase.
Map<String, Set<String>> colunasDoServidor() {
  final sql = Directory('supabase/migrations')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.sql'))
      .map((f) => f.readAsStringSync())
      .join('\n');
  final tabelas = <String, Set<String>>{};
  final re = RegExp(r'create table if not exists public\.(\w+) \((.*?)\n\);', dotAll: true);
  for (final m in re.allMatches(sql)) {
    final cols = <String>{};
    for (final linha in m.group(2)!.split('\n')) {
      final c = RegExp(r'^  ([a-z_0-9]+) ').firstMatch(linha);
      if (c != null && !{'primary', 'constraint'}.contains(c.group(1))) cols.add(c.group(1)!);
    }
    tabelas[m.group(1)!] = cols;
  }
  return tabelas;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late FocoRepository repo;
  late SyncService sync;
  const cfg = RegrasConfig();
  const dentro = Posicao(lat: -20.7453, lon: -41.2914, precisaoM: 6);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await Seeder(db).executar();
    repo = FocoRepository(db, CatalogoRepository(db), await LimiteFlona.carregar());
    sync = SyncService(db, ConfigRepository(db), repo);
  });

  tearDown(() => db.close());

  Future<String> criarCenario() async {
    final r = await repo.registrarDeteccao(
      especieId: 'artocarpus_heterophyllus',
      usuarioId: '11111111-1111-4111-8111-111111111111',
      dados: DadosObservacao(
        posicao: dentro,
        nIndividuos: 4,
        quantificacaoTipo: 'contagem',
        texto: 'Jaqueira na beira da trilha',
        fotos: [FotoCapturada(caminho: '/tmp/x.jpg', tiradaEm: DateTime.utc(2026, 10, 4), lat: -20.7, lon: -41.2)],
      ),
      cfg: cfg,
    );
    await repo.registrarManejo(
      focoId: r.focoId,
      usuarioId: '11111111-1111-4111-8111-111111111111',
      dados: DadosManejo(
        metodo: 'anelamento_herbicida',
        herbicidaProduto: 'triclopir',
        herbicidaVolumeL: 0.5,
        responsavel: 'Equipe',
        nPessoas: 2,
        horas: 1.5,
      ),
      cfg: cfg,
    );
    return r.focoId;
  }

  test('registros pendentes: consulta tipada (antes quebrava com .not() dinâmico)', () async {
    await criarCenario();
    expect(await sync.registrosPendentes(db.focos), hasLength(1));
    expect(await sync.registrosPendentes(db.observacoes), hasLength(1));
    expect(await sync.registrosPendentes(db.acoesManejo), hasLength(1));
    expect(await sync.registrosPendentes(db.midias), hasLength(1));

    await db.customStatement("UPDATE focos SET sync_status = 'enviado'");
    expect(await sync.registrosPendentes(db.focos), isEmpty);
    await db.customStatement("UPDATE observacoes SET sync_status = 'erro'");
    expect(await sync.registrosPendentes(db.observacoes), hasLength(1), reason: 'erro também é reenviado');

    final p = await sync.pendencias();
    expect(p.registros, 3); // observação (erro) + manejo + mídia
    expect(p.fotos, 1);
  });

  test('todo campo enviado existe na tabela do Supabase, e os obrigatórios vão preenchidos', () async {
    await criarCenario();
    final servidor = colunasDoServidor();
    final amostras = <String, Map<String, dynamic>>{
      'focos': (await db.select(db.focos).getSingle()).toJson(serializer: serializadorSync),
      'observacoes': (await db.select(db.observacoes).getSingle()).toJson(serializer: serializadorSync),
      'acoes_manejo': (await db.select(db.acoesManejo).getSingle()).toJson(serializer: serializadorSync),
      'midias': (await db.select(db.midias).getSingle()).toJson(serializer: serializadorSync),
    };
    for (final MapEntry(key: tabela, value: local) in amostras.entries) {
      final remoto = paraRemoto(local);
      final colunas = servidor[tabela]!;
      final sobrando = remoto.keys.toSet().difference(colunas);
      expect(sobrando, isEmpty, reason: '$tabela: campos sem coluna no servidor');
      expect(remoto.containsKey('sync_status'), isFalse);
      expect(remoto.containsKey('caminho_local'), isFalse);
      expect(remoto['id'], isA<String>());
      expect(remoto['created_at'], isA<String>(), reason: 'datas vão em ISO 8601');
    }
    expect(paraRemoto(amostras['focos']!)['motivos_precoce'], isA<List<dynamic>>());
    expect(paraRemoto(amostras['acoes_manejo']!)['herbicida_volume_l'], 0.5);
  });

  test('ida e volta local → servidor → local preserva os dados', () async {
    await criarCenario();
    const padroes = {'syncStatus': SyncStatus.enviado, 'deleted': false, 'version': 1};
    final agora = DateTime.utc(2026, 10, 4, 12).toIso8601String();

    final foco = await db.select(db.focos).getSingle();
    final remotoFoco = {...paraRemoto(foco.toJson(serializer: serializadorSync)), 'server_updated_at': agora};
    final voltaFoco = Foco.fromJson(paraLocal(remotoFoco, padroes), serializer: serializadorSync);
    expect(voltaFoco.codigo, foco.codigo);
    expect(voltaFoco.lat, foco.lat);
    expect(voltaFoco.motivosPrecoce, foco.motivosPrecoce);
    expect(voltaFoco.primeiraDeteccaoEm, foco.primeiraDeteccaoEm);
    expect(voltaFoco.serverUpdatedAt, DateTime.parse(agora));

    final manejo = await db.select(db.acoesManejo).getSingle();
    final remotoManejo = {...paraRemoto(manejo.toJson(serializer: serializadorSync)), 'server_updated_at': agora};
    final voltaManejo = AcaoManejo.fromJson(paraLocal(remotoManejo, padroes), serializer: serializadorSync);
    expect(voltaManejo.herbicidaProduto, 'triclopir');
    expect(voltaManejo.horas, 1.5);

    // O PostgREST devolve inteiros onde o drift espera double (ex.: 2 em vez de 2.0).
    final obs = await db.select(db.observacoes).getSingle();
    final remotoObs = {
      ...paraRemoto(obs.toJson(serializer: serializadorSync)),
      'server_updated_at': agora,
      'precisao_m': 6,
    };
    final voltaObs = Observacao.fromJson(paraLocal(remotoObs, padroes), serializer: serializadorSync);
    expect(voltaObs.precisaoM, 6.0);
    expect(voltaObs.texto, 'Jaqueira na beira da trilha');
  });
}
