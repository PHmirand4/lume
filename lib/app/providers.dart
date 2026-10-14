import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/geo/unidades.dart';
import '../data/local/database.dart';
import '../data/repositories/catalogo_repository.dart';
import '../data/repositories/config_repository.dart';
import '../data/repositories/foco_repository.dart';
import '../data/repositories/priorizacao_repository.dart';
import '../data/repositories/sessao_repository.dart';
import '../data/sync/sync_service.dart';
import '../domain/priorizacao.dart';
import '../domain/regras.dart';

// Infraestrutura (sobrescritos em main.dart depois da inicialização).
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError());
final unidadesProvider = Provider<CatalogoUnidades>((ref) => throw UnimplementedError());

// Repositórios
final configRepoProvider = Provider((ref) => ConfigRepository(ref.watch(databaseProvider)));
final catalogoRepoProvider = Provider((ref) => CatalogoRepository(ref.watch(databaseProvider)));
final focoRepoProvider = Provider((ref) => FocoRepository(
      ref.watch(databaseProvider),
      ref.watch(catalogoRepoProvider),
      ref.watch(unidadesProvider),
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

// Unidade de conservação escolhida no aparelho
final unidadeIdProvider = StreamProvider<String?>(
    (ref) => ref.watch(configRepoProvider).observar(ConfigRepository.unidadeAtual).distinct());

/// Unidade escolhida (nula até a pessoa escolher).
final unidadeSelecionadaProvider = Provider<Unidade?>(
    (ref) => ref.watch(unidadesProvider).porId(ref.watch(unidadeIdProvider).value));

/// Unidade em uso nas telas do app (só montadas depois da escolha; o padrão
/// cobre o instante em que a escolha ainda está carregando).
final unidadeAtualProvider = Provider<Unidade>((ref) =>
    ref.watch(unidadeSelecionadaProvider) ??
    ref.watch(unidadesProvider).porId(CatalogoUnidades.padrao)!);

// Catálogo
final especiesProvider =
    StreamProvider<List<Especie>>((ref) => ref.watch(catalogoRepoProvider).observarEspecies());

/// Ocorrências, registros e foto de cada espécie na unidade atual.
final resumosEspeciesProvider = StreamProvider<Map<String, ResumoEspecie>>((ref) =>
    ref.watch(catalogoRepoProvider).observarResumos(ref.watch(unidadeAtualProvider).id));

/// Espécies da Lista de EEI em UC federais (ICMBio) na unidade atual.
final listaOficialProvider = StreamProvider<Set<String>>((ref) =>
    ref.watch(catalogoRepoProvider).observarListaOficial(ref.watch(unidadeAtualProvider).id));

/// Ciclo (ano) da lista oficial guardada no aparelho.
final cicloListaProvider = StreamProvider<int?>((ref) => ref.watch(catalogoRepoProvider).observarCicloLista());

// Priorização (Ferramenta de Priorização de EEI pela UC — ICMBio)
final priorizacaoRepoProvider = Provider((ref) => PriorizacaoRepository(ref.watch(databaseProvider)));

final criteriosPriorizacaoProvider = FutureProvider<List<CriterioPriorizacao>>(
    (ref) async => criteriosDeJson(await rootBundle.loadString('assets/seed/priorizacao.json')));

final priorizacoesProvider = StreamProvider<Map<String, Priorizacao>>((ref) =>
    ref.watch(priorizacaoRepoProvider).observar(ref.watch(unidadeAtualProvider).id));

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
final focosProvider = StreamProvider<List<FocoComEspecie>>((ref) =>
    ref.watch(focoRepoProvider).observarFocos(unidadeId: ref.watch(unidadeAtualProvider).id));

final focoProvider = StreamProvider.family<FocoComEspecie?, String>(
    (ref, id) => ref.watch(focoRepoProvider).observarFoco(id));

final linhaDoTempoProvider = StreamProvider.family<List<ItemLinhaDoTempo>, String>(
    (ref, id) => ref.watch(focoRepoProvider).observarLinhaDoTempo(id));

// Sincronização
final pendenciasProvider =
    StreamProvider<Pendencias>((ref) => ref.watch(syncServiceProvider).observarPendencias());
