import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show Intl;

import 'app/providers.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'data/geo/limite_flona.dart';
import 'data/local/database.dart';
import 'data/local/seed.dart';
import 'data/remote/supabase_config.dart';
import 'features/intro/intro_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // A abertura começa no primeiro frame; banco, seed e servidor inicializam por baixo.
  runApp(const RaizLume());
}

class _Dependencias {
  const _Dependencias(this.db, this.limite);

  final AppDatabase db;
  final LimiteFlona limite;
}

Future<_Dependencias> _inicializar() async {
  Intl.defaultLocale = 'pt_BR';
  await initializeDateFormatting('pt_BR');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  LicenseRegistry.addLicense(() async* {
    for (final (fonte, arquivo) in [('Archivo', 'OFL-Archivo.txt'), ('IBM Plex', 'OFL-IBMPlex.txt')]) {
      yield LicenseEntryWithLineBreaks([fonte], await rootBundle.loadString('assets/fonts/$arquivo'));
    }
  });
  await SupabaseConfig.inicializar();
  final db = AppDatabase();
  await Seeder(db).executar();
  return _Dependencias(db, await LimiteFlona.carregar());
}

/// Raiz: mostra a abertura imediatamente e monta o app quando a inicialização termina.
class RaizLume extends StatefulWidget {
  const RaizLume({super.key});

  @override
  State<RaizLume> createState() => _RaizLumeState();
}

class _RaizLumeState extends State<RaizLume> {
  _Dependencias? _deps;
  Object? _erro;

  @override
  void initState() {
    super.initState();
    _inicializar().then((d) => setState(() => _deps = d), onError: (Object e) => setState(() => _erro = e));
  }

  @override
  Widget build(BuildContext context) {
    final deps = _deps;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery.fromView(
        view: View.of(context),
        child: IntroOverlay(
          pronto: deps != null || _erro != null,
          child: deps != null
              ? ProviderScope(
                  overrides: [
                    databaseProvider.overrideWithValue(deps.db),
                    limiteFlonaProvider.overrideWithValue(deps.limite),
                  ],
                  child: const LumeApp(),
                )
              : ColoredBox(
                  color: LumeCores.fundo,
                  child: _erro == null
                      ? const SizedBox.expand()
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Não foi possível iniciar o Lume: $_erro',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: LumeCores.erro, fontSize: 16),
                            ),
                          ),
                        ),
                ),
        ),
      ),
    );
  }
}

class LumeApp extends ConsumerStatefulWidget {
  const LumeApp({super.key});

  @override
  ConsumerState<LumeApp> createState() => _LumeAppState();
}

class _LumeAppState extends ConsumerState<LumeApp> {
  @override
  void initState() {
    super.initState();
    // Sincroniza ao abrir o app, ao recuperar a conexão e a cada 15 min.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncServiceProvider).iniciarGatilhos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lume',
      debugShowCheckedModeBanner: false,
      theme: temaLume(),
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(routerProvider),
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
