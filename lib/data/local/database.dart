import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

export 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Usuarios,
  Especies,
  Focos,
  Observacoes,
  AcoesManejo,
  Midias,
  ListaValores,
  Configs,
  ErrosSync,
  EspeciesUnidade,
  Priorizacoes,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _abrir());

  // O arquivo continua "lume" para manter os dados de quem já usava o app.
  static QueryExecutor _abrir() => driftDatabase(name: 'lume');

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement('CREATE INDEX idx_focos_especie ON focos (especie_id)');
          await customStatement('CREATE INDEX idx_focos_unidade ON focos (unidade_id)');
          await customStatement('CREATE INDEX idx_obs_foco ON observacoes (foco_id)');
          await customStatement('CREATE INDEX idx_manejo_foco ON acoes_manejo (foco_id)');
          await customStatement('CREATE INDEX idx_midia_dono ON midias (dono_id)');
          await customStatement('CREATE UNIQUE INDEX idx_prior_unidade ON priorizacoes (unidade_id, especie_id)');
        },
        onUpgrade: (m, de, para) async {
          if (de < 2) {
            // v2: várias unidades e catálogo nacional de espécies.
            await m.addColumn(focos, focos.unidadeId);
            await m.addColumn(focos, focos.chaveExterna);
            await customStatement('CREATE INDEX idx_focos_unidade ON focos (unidade_id)');
            for (final c in [
              especies.origemNativa,
              especies.ambientesInvasao,
              especies.impactos,
              especies.controleLiteratura,
              especies.nativaBrasil,
              especies.fonte,
              especies.criadoPor,
              especies.unidadeOrigem,
            ]) {
              await m.addColumn(especies, c);
            }
          }
          if (de < 3) {
            // v3: lista oficial do ICMBio por unidade, fauna, campos da ficha de campo e priorização.
            await m.addColumn(especies, especies.reino);
            for (final c in [observacoes.bloco, observacoes.capCm, observacoes.padraoOcorrencia, observacoes.evidencia]) {
              await m.addColumn(observacoes, c);
            }
            await m.addColumn(acoesManejo, acoesManejo.bloco);
            await m.addColumn(acoesManejo, acoesManejo.capCm);
            await m.createTable(especiesUnidade);
            await m.createTable(priorizacoes);
            await customStatement('CREATE UNIQUE INDEX idx_prior_unidade ON priorizacoes (unidade_id, especie_id)');
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
