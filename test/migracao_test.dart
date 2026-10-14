import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/data/local/database.dart';
import 'package:lume/data/local/seed.dart';
import 'package:sqlite3/sqlite3.dart';

/// Colunas que a v2 e a v3 acrescentaram (somem do esquema para simular a v1).
const _novas = {
  'focos': ['unidade_id', 'chave_externa'],
  'especies': [
    'origem_nativa', 'ambientes_invasao', 'impactos', 'controle_literatura', //
    'nativa_brasil', 'fonte', 'criado_por', 'unidade_origem', 'reino',
  ],
  'observacoes': ['bloco', 'cap_cm', 'padrao_ocorrencia', 'evidencia'],
  'acoes_manejo': ['bloco', 'cap_cm'],
};

/// Tabelas que só existem a partir da v3.
const _tabelasNovas = {'especies_unidade', 'priorizacoes'};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('banco da v1 (só Pacotuba) migra para a v3 sem perder focos', () async {
    final dir = await Directory.systemTemp.createTemp('biolume_migracao');
    final arquivo = File('${dir.path}/v1.sqlite');

    // Esquema da v2, sem as colunas novas = esquema da v1.
    final atual = AppDatabase(NativeDatabase.memory());
    final tabelas = await atual
        .customSelect("SELECT name, sql FROM sqlite_master WHERE type = 'table' AND sql IS NOT NULL")
        .get();
    await atual.close();
    final v1 = sqlite3.open(arquivo.path);
    for (final t in tabelas) {
      if (_tabelasNovas.contains(t.read<String>('name'))) continue;
      var sql = t.read<String>('sql');
      for (final c in _novas[t.read<String>('name')] ?? const <String>[]) {
        // Definição da coluna até a vírgula seguinte (pula a do CHECK (... IN (0, 1))).
        sql = sql.replaceFirst(RegExp('"$c" (?:[^,(]|\\((?:[^()]|\\([^()]*\\))*\\))*, '), '');
      }
      v1.execute(sql);
    }
    v1.execute("INSERT INTO usuarios (id, nome, email, perfil, created_at, updated_at) "
        "VALUES ('u1', 'Ana', 'ana@x', 'gestor', '2026-10-05T12:00:00.000Z', '2026-10-05T12:00:00.000Z')");
    v1.execute("INSERT INTO especies (id, prefixo, nome_cientifico, nomes_populares, forma_vida, metodos_sugeridos, "
        "fotos_referencia, sync_status, created_at, updated_at) VALUES ('artocarpus_heterophyllus', 'JAQ', 'Artocarpus heterophyllus Lam.', "
        "'[\"jaqueira\"]', 'arvore', '[]', '[]', 'enviado', '2026-10-01T00:00:00.000Z', '2026-10-01T00:00:00.000Z')");
    v1.execute("INSERT INTO focos (id, especie_id, codigo, lat, lon, origem_coordenada, status, criado_por, "
        "primeira_deteccao_em, ultima_visita_em, created_at, updated_at) VALUES ('f1', 'artocarpus_heterophyllus', "
        "'JAQ-0001', -20.7453, -41.2914, 'gps_auto', 'detectado', 'u1', "
        "'2026-10-05T12:00:00.000Z', '2026-10-05T12:00:00.000Z', '2026-10-05T12:00:00.000Z', '2026-10-05T12:00:00.000Z')");
    v1.execute('PRAGMA user_version = 1');
    v1.close();

    final db = AppDatabase(NativeDatabase(arquivo));
    await Seeder(db).executar();
    final foco = await db.select(db.focos).getSingle();
    expect(foco.unidadeId, 'flona_pacotuba');
    expect(foco.codigo, 'JAQ-0001');
    final especies = await db.select(db.especies).get();
    expect(especies.length, greaterThan(250));
    expect(especies.firstWhere((e) => e.id == 'artocarpus_heterophyllus').origemNativa, isNotNull);
    expect(especies.where((e) => e.reino == 'animal'), isNotEmpty);
    final lista = await (db.select(db.especiesUnidade)..where((e) => e.unidadeId.equals('flona_pacotuba'))).get();
    expect(lista.map((e) => e.especieId), contains('acacia_mangium'));
    await db.close();
    await dir.delete(recursive: true);
  });
}
