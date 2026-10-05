import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/geo/limite_flona.dart';
import '../data/local/database.dart';
import '../data/repositories/catalogo_repository.dart';
import '../data/repositories/config_repository.dart';
import '../data/repositories/foco_repository.dart';
import '../data/repositories/sessao_repository.dart';
import '../data/sync/sync_service.dart';
import '../domain/regras.dart';

// Infraestrutura (sobrescritos em main.dart depois da inicialização).
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError());
final limiteFlonaProvider = Provider<LimiteFlona>((ref) => throw UnimplementedError());

// Repositórios
final configRepoProvider = Provider((ref) => ConfigRepository(ref.watch(databaseProvider)));
final catalogoRepoProvider = Provider((ref) => CatalogoRepository(ref.watch(databaseProvider)));
final focoRepoProvider = Provider((ref) => FocoRepository(
      ref.watch(databaseProvider),
      ref.watch(catalogoRepoProvider),
      ref.watch(limiteFlonaProvider),
    ));
final sessaoRepoProvider = Provider(
    (ref) => SessaoRepository(ref.watch(databaseProvider), ref.watch(configRepoProvider)));

final syncServiceProvider = Provider<SyncService>((ref) {
  final s = SyncService(
    ref.watch(databaseProvider),
    ref.watch(configRepoProvider),
    ref.watch(focoRepoProvider),
  );
  ref.onDispose(s.dispose);
  return s;
});

// Sessão
final usuarioAtualProvider =
    StreamProvider<Usuario?>((ref) => ref.watch(sessaoRepoProvider).observarUsuarioAtual());

// Catálogo
final especiesProvider =
    StreamProvider<List<Especie>>((ref) => ref.watch(catalogoRepoProvider).observarEspecies());

final vocabularioProvider =
    StreamProvider<Vocabulario>((ref) => ref.watch(catalogoRepoProvider).observarVocabulario());

/// Vocabulário já carregado (vazio enquanto carrega — rótulos caem no código).
final vocabProvider =
    Provider<Vocabulario>((ref) => ref.watch(vocabularioProvider).value ?? Vocabulario.vazio);

// Regras configuráveis
class RegrasNotifier extends AsyncNotifier<RegrasConfig> {
  @override
  Future<RegrasConfig> build() => ref.watch(configRepoProvider).lerRegras();

  Future<void> salvar(RegrasConfig r) async {
    await ref.read(configRepoProvider).gravarRegras(r);
    state = AsyncData(r);
  }
}

final regrasProvider = AsyncNotifierProvider<RegrasNotifier, RegrasConfig>(RegrasNotifier.new);

/// Regras já carregadas (padrão enquanto carrega).
final regrasAtuaisProvider =
    Provider<RegrasConfig>((ref) => ref.watch(regrasProvider).value ?? const RegrasConfig());

// Focos
final focosProvider =
    StreamProvider<List<FocoComEspecie>>((ref) => ref.watch(focoRepoProvider).observarFocos());

final focoProvider = StreamProvider.family<FocoComEspecie?, String>(
    (ref, id) => ref.watch(focoRepoProvider).observarFoco(id));

final linhaDoTempoProvider = StreamProvider.family<List<ItemLinhaDoTempo>, String>(
    (ref, id) => ref.watch(focoRepoProvider).observarLinhaDoTempo(id));

// Sincronização
final pendenciasProvider =
    StreamProvider<Pendencias>((ref) => ref.watch(syncServiceProvider).observarPendencias());
