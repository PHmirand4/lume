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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _abrir());

  static QueryExecutor _abrir() => driftDatabase(name: 'lume');

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement('CREATE INDEX idx_focos_especie ON focos (especie_id)');
          await customStatement('CREATE INDEX idx_obs_foco ON observacoes (foco_id)');
          await customStatement('CREATE INDEX idx_manejo_foco ON acoes_manejo (foco_id)');
          await customStatement('CREATE INDEX idx_midia_dono ON midias (dono_id)');
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
