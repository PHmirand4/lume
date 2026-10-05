import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/data/local/database.dart';
import 'package:lume/data/repositories/config_repository.dart';
import 'package:lume/data/repositories/sessao_repository.dart';
import 'package:lume/domain/codigos.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('entrar e sair chegam a quem observa a sessão (antes o "Sair" travava)', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final sessao = SessaoRepository(db, ConfigRepository(db));
    final eventos = <String?>[];
    final sub = sessao.observarUsuarioAtual().listen((u) => eventos.add(u?.nome));

    await pumpEventQueue();
    expect(eventos.last, isNull);

    await sessao.entrarLocal(nome: 'Ana', email: 'ana@exemplo.org', perfil: Perfil.campo);
    await pumpEventQueue();
    expect(eventos.last, 'Ana');

    await sessao.sair();
    await pumpEventQueue();
    expect(eventos.last, isNull, reason: 'depois de sair, a sessão tem de ficar vazia');

    await sessao.entrarLocal(nome: 'Bruno', email: 'bruno@exemplo.org', perfil: Perfil.gestor);
    await pumpEventQueue();
    expect(eventos.last, 'Bruno');

    await sub.cancel();
    await db.close();
  });
}
