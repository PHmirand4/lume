import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/codigos.dart';
import '../../domain/priorizacao.dart';
import '../local/database.dart';
import 'foco_repository.dart' show agoraUtc;

/// Priorização de EEI para controle na unidade (uma avaliação por espécie e unidade).
class PriorizacaoRepository {
  PriorizacaoRepository(this.db);

  final AppDatabase db;
  static const _uuid = Uuid();

  /// Avaliações da unidade, por espécie.
  Stream<Map<String, Priorizacao>> observar(String unidadeId) => (db.select(db.priorizacoes)
        ..where((p) => p.unidadeId.equals(unidadeId) & p.deleted.equals(false)))
      .watch()
      .map((l) => {for (final p in l) p.especieId: p});

  Future<Priorizacao?> atual(String unidadeId, String especieId) => (db.select(db.priorizacoes)
        ..where((p) => p.unidadeId.equals(unidadeId) & p.especieId.equals(especieId)))
      .getSingleOrNull();

  /// Grava (ou atualiza) a avaliação; o índice é recalculado aqui.
  Future<int> salvar({
    required String unidadeId,
    required String especieId,
    required Map<int, String> respostas,
    required List<CriterioPriorizacao> criterios,
    required String usuarioId,
    String? observacao,
  }) async {
    final indice = indicePriorizacao(respostas, criterios);
    final agora = agoraUtc();
    final existente = await atual(unidadeId, especieId);
    if (existente == null) {
      await db.into(db.priorizacoes).insert(PriorizacoesCompanion.insert(
            id: _uuid.v4(),
            unidadeId: unidadeId,
            especieId: especieId,
            respostas: respostasParaJson(respostas),
            indice: indice,
            usuarioId: usuarioId,
            observacao: Value(observacao),
            createdAt: agora,
            updatedAt: agora,
          ));
    } else {
      await (db.update(db.priorizacoes)..where((p) => p.id.equals(existente.id))).write(PriorizacoesCompanion(
        respostas: Value(respostasParaJson(respostas)),
        indice: Value(indice),
        usuarioId: Value(usuarioId),
        observacao: Value(observacao),
        deleted: const Value(false),
        updatedAt: Value(agora),
        syncStatus: const Value(SyncStatus.pendente),
        version: Value(existente.version + 1),
      ));
    }
    return indice;
  }
}
