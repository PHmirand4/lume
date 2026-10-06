import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/apresentacao.dart';
import '../features/auth/identificacao_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/configuracoes/configuracoes_screen.dart';
import '../features/configuracoes/sobre_screen.dart';
import '../features/especies/especie_screen.dart';
import '../features/especies/guia_screen.dart';
import '../features/exportacao/exportar_screen.dart';
import '../features/foco/foco_screen.dart';
import '../features/home/home_screen.dart';
import '../features/home/shell.dart';
import '../features/lista/lista_focos_screen.dart';
import '../features/manejo/manejo_screen.dart';
import '../features/mapa/mapa_screen.dart';
import '../features/navegacao/navegacao_screen.dart';
import '../features/ocorrencia/nova_ocorrencia_screen.dart';
import '../features/ocorrencia/revisita_screen.dart';
import '../features/sync/pendencias_screen.dart';
import 'providers.dart';

abstract final class Rotas {
  static const login = '/login';
  static const inicio = '/inicio';
  static const mapa = '/mapa';
  static const focos = '/focos';
  static const guia = '/guia';
  static const novaOcorrencia = '/ocorrencia/nova';
  static const exportar = '/exportar';
  static const pendencias = '/pendencias';
  static const configuracoes = '/configuracoes';
  static const sobre = '/sobre';

  static String foco(String id) => '/foco/$id';
  static String manejo(String id) => '/foco/$id/manejo';
  static String revisita(String id) => '/foco/$id/revisita';
  static String navegar(String id) => '/foco/$id/navegar';
  static String especie(String id) => '/guia/$id';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Notifica o GoRouter quando a sessão muda, sem recriar o roteador.
  final sessao = ValueNotifier<bool?>(null);
  ref.listen(usuarioAtualProvider, (_, prox) {
    if (prox.hasValue) sessao.value = prox.value != null;
  }, fireImmediately: true);
  ref.onDispose(sessao.dispose);

  return GoRouter(
    initialLocation: Rotas.inicio,
    refreshListenable: sessao,
    redirect: (context, state) {
      final logado = sessao.value;
      if (logado == null) return null; // ainda carregando
      final naLogin = state.matchedLocation == Rotas.login;
      if (!logado && !naLogin) return Rotas.login;
      if (logado && naLogin) return Rotas.inicio;
      return null;
    },
    routes: [
      GoRoute(
        path: Rotas.login,
        // Versão de apresentação: só nome e função (ver core/apresentacao.dart).
        builder: (_, _) => modoApresentacao ? const IdentificacaoScreen() : const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => ShellPrincipal(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Rotas.inicio, builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Rotas.mapa, builder: (_, _) => const MapaScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Rotas.focos, builder: (_, _) => const ListaFocosScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Rotas.guia,
              builder: (_, _) => const GuiaScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (_, s) => EspecieScreen(especieId: s.pathParameters['id']!),
                ),
              ],
            ),
          ]),
        ],
      ),
      GoRoute(
        path: Rotas.novaOcorrencia,
        builder: (_, s) => NovaOcorrenciaScreen(especieInicial: s.uri.queryParameters['especie']),
      ),
      GoRoute(
        path: '/foco/:id',
        builder: (_, s) => FocoScreen(focoId: s.pathParameters['id']!),
        routes: [
          GoRoute(path: 'manejo', builder: (_, s) => ManejoScreen(focoId: s.pathParameters['id']!)),
          GoRoute(path: 'revisita', builder: (_, s) => RevisitaScreen(focoId: s.pathParameters['id']!)),
          GoRoute(path: 'navegar', builder: (_, s) => NavegacaoScreen(focoId: s.pathParameters['id']!)),
        ],
      ),
      GoRoute(path: Rotas.exportar, builder: (_, _) => const ExportarScreen()),
      GoRoute(path: Rotas.pendencias, builder: (_, _) => const PendenciasScreen()),
      GoRoute(path: Rotas.configuracoes, builder: (_, _) => const ConfiguracoesScreen()),
      GoRoute(path: Rotas.sobre, builder: (_, _) => const SobreScreen()),
    ],
  );
});
