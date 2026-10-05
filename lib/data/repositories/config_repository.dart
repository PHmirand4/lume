import 'package:drift/drift.dart';

import '../../domain/regras.dart';
import '../local/database.dart';

/// Configurações locais guardadas na tabela `configs`.
class ConfigRepository {
  ConfigRepository(this.db);

  final AppDatabase db;

  static const usuarioAtual = 'usuario_atual_id';
  static const ultimoPull = 'sync_ultimo_pull';
  static const ultimoSync = 'sync_ultimo_ok';
  static const fotosSoWifi = 'fotos_so_wifi';
  static const termoAceito = 'termo_aceito';
  static const corMapaPor = 'mapa_cor_por';

  Future<String?> ler(String chave) async =>
      (await (db.select(db.configs)..where((c) => c.chave.equals(chave))).getSingleOrNull())
          ?.valor;

  Stream<String?> observar(String chave) =>
      (db.select(db.configs)..where((c) => c.chave.equals(chave)))
          .watchSingleOrNull()
          .map((c) => c?.valor);

  Future<void> gravar(String chave, String valor) => db
      .into(db.configs)
      .insertOnConflictUpdate(ConfigsCompanion.insert(chave: chave, valor: valor));

  Future<void> remover(String chave) =>
      (db.delete(db.configs)..where((c) => c.chave.equals(chave))).go();

  Future<bool> lerBool(String chave, {bool padrao = false}) async {
    final v = await ler(chave);
    return v == null ? padrao : v == 'true';
  }

  // --- Regras (seção 13) ---------------------------------------------------

  static const _r = 'regra_';

  Future<RegrasConfig> lerRegras() async {
    final linhas = await (db.select(db.configs)..where((c) => c.chave.like('$_r%'))).get();
    final m = {for (final l in linhas) l.chave.substring(_r.length): l.valor};
    const p = RegrasConfig();
    double d(String k, double padrao) => double.tryParse(m[k] ?? '') ?? padrao;
    int i(String k, int padrao) => int.tryParse(m[k] ?? '') ?? padrao;
    return p.copyWith(
      raioMesmoFocoM: d('raio_mesmo_foco_m', p.raioMesmoFocoM),
      erradicadoRevisitas: i('erradicado_revisitas', p.erradicadoRevisitas),
      erradicadoMeses: i('erradicado_meses', p.erradicadoMeses),
      precoceDistanciaM: d('precoce_distancia_m', p.precoceDistanciaM),
      precoceMaxIndividuos: i('precoce_max_individuos', p.precoceMaxIndividuos),
      precoceMaxAreaM2: d('precoce_max_area_m2', p.precoceMaxAreaM2),
      diasParaRevisita: i('dias_para_revisita', p.diasParaRevisita),
    );
  }

  Future<void> gravarRegras(RegrasConfig r) => db.batch((b) {
        final valores = {
          'raio_mesmo_foco_m': r.raioMesmoFocoM,
          'erradicado_revisitas': r.erradicadoRevisitas,
          'erradicado_meses': r.erradicadoMeses,
          'precoce_distancia_m': r.precoceDistanciaM,
          'precoce_max_individuos': r.precoceMaxIndividuos,
          'precoce_max_area_m2': r.precoceMaxAreaM2,
          'dias_para_revisita': r.diasParaRevisita,
        };
        valores.forEach((k, v) => b.insert(
              db.configs,
              ConfigsCompanion.insert(chave: '$_r$k', valor: '$v'),
              mode: InsertMode.insertOrReplace,
            ));
      });
}
