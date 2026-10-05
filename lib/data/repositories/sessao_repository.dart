import 'dart:async';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/codigos.dart';
import '../local/database.dart';
import '../remote/supabase_config.dart';
import 'config_repository.dart';

class FalhaLogin implements Exception {
  FalhaLogin(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}

/// Sessão do usuário. Depois do primeiro acesso, a sessão fica guardada e o
/// app funciona offline (F01).
class SessaoRepository {
  SessaoRepository(this.db, this.config);

  final AppDatabase db;
  final ConfigRepository config;

  bool get modoServidor => SupabaseConfig.configurado;

  /// Usuário logado. Ao entrar ou sair, troca de fluxo imediatamente.
  ///
  /// Não usar `asyncExpand`: ele espera o fluxo interno terminar antes de
  /// reagir à troca, e a consulta do drift nunca termina — o "Sair" não chegava
  /// ao roteador.
  Stream<Usuario?> observarUsuarioAtual() {
    late StreamController<Usuario?> saida;
    StreamSubscription<String?>? subId;
    StreamSubscription<Usuario?>? subUsuario;
    saida = StreamController<Usuario?>(
      onListen: () {
        subId = config.observar(ConfigRepository.usuarioAtual).distinct().listen((id) {
          subUsuario?.cancel();
          if (id == null) {
            subUsuario = null;
            saida.add(null);
          } else {
            subUsuario = (db.select(db.usuarios)..where((u) => u.id.equals(id)))
                .watchSingleOrNull()
                .listen(saida.add, onError: saida.addError);
          }
        }, onError: saida.addError);
      },
      onCancel: () async {
        await subUsuario?.cancel();
        await subId?.cancel();
      },
    );
    return saida.stream;
  }

  /// Modo local (sem servidor configurado): cria o usuário no aparelho.
  Future<Usuario> entrarLocal({
    required String nome,
    required String email,
    String? funcao,
    required String perfil,
  }) async {
    final agora = DateTime.now().toUtc();
    final existente = await (db.select(db.usuarios)..where((u) => u.email.equals(email.trim().toLowerCase())))
        .getSingleOrNull();
    final id = existente?.id ?? const Uuid().v4();
    await db.into(db.usuarios).insertOnConflictUpdate(UsuariosCompanion.insert(
          id: id,
          nome: nome.trim(),
          email: email.trim().toLowerCase(),
          perfil: perfil,
          funcao: Value(funcao?.trim().isEmpty ?? true ? null : funcao!.trim()),
          createdAt: existente?.createdAt ?? agora,
          updatedAt: agora,
          syncStatus: const Value(SyncStatus.enviado),
        ));
    await config.gravar(ConfigRepository.usuarioAtual, id);
    return (await (db.select(db.usuarios)..where((u) => u.id.equals(id))).getSingle());
  }

  /// Modo servidor: e-mail e senha no Supabase Auth; o perfil vem da tabela `usuarios`.
  Future<Usuario> entrarServidor({required String email, required String senha}) async {
    final c = SupabaseConfig.cliente!;
    try {
      final resp = await c.auth.signInWithPassword(email: email.trim(), password: senha);
      final uid = resp.user!.id;
      final perfil = await c.from('usuarios').select().eq('id', uid).maybeSingle();
      if (perfil == null) {
        await c.auth.signOut();
        throw FalhaLogin('Usuário sem cadastro no Lume. Peça ao administrador para liberar o acesso.');
      }
      if (perfil['ativo'] == false) {
        await c.auth.signOut();
        throw FalhaLogin('Usuário desativado.');
      }
      final agora = DateTime.now().toUtc();
      await db.into(db.usuarios).insertOnConflictUpdate(UsuariosCompanion.insert(
            id: uid,
            nome: perfil['nome'] as String,
            email: perfil['email'] as String,
            perfil: perfil['perfil'] as String,
            funcao: Value(perfil['funcao'] as String?),
            createdAt: agora,
            updatedAt: agora,
            syncStatus: const Value(SyncStatus.enviado),
          ));
      await config.gravar(ConfigRepository.usuarioAtual, uid);
      return (await (db.select(db.usuarios)..where((u) => u.id.equals(uid))).getSingle());
    } on AuthException catch (e) {
      throw FalhaLogin(e.message.contains('Invalid login')
          ? 'E-mail ou senha incorretos.'
          : 'Não foi possível entrar: ${e.message}');
    } on FalhaLogin {
      rethrow;
    } catch (e) {
      throw FalhaLogin('Sem conexão com o servidor. O primeiro acesso precisa de internet.');
    }
  }

  Future<void> sair() async {
    if (modoServidor) {
      try {
        await SupabaseConfig.cliente!.auth.signOut();
      } catch (_) {}
    }
    await config.remover(ConfigRepository.usuarioAtual);
  }
}
