import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/apresentacao.dart';

/// Credenciais do backend, passadas na compilação:
///
/// ```
/// flutter run --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
///             --dart-define=SUPABASE_KEY=sb_publishable_...
/// ```
///
/// Sem elas o app roda em **modo local**: tudo funciona no aparelho, mas não
/// há login no servidor nem sincronização.
abstract final class SupabaseConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');
  /// Chave pública (publishable key) do projeto — nunca a service_role.
  static const chave = String.fromEnvironment('SUPABASE_KEY');
  static const bucketMidias = 'midias';

  /// Na versão de apresentação o servidor fica desligado mesmo com as credenciais.
  static bool get configurado => !modoApresentacao && url.isNotEmpty && chave.isNotEmpty;

  static Future<void> inicializar() async {
    if (!configurado) return;
    await Supabase.initialize(url: url, publishableKey: chave);
  }

  static SupabaseClient? get cliente => configurado ? Supabase.instance.client : null;
}
