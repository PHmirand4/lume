import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/fotos.dart';
import '../../domain/codigos.dart';
import '../local/database.dart';
import '../remote/supabase_config.dart';
import '../repositories/config_repository.dart';
import '../repositories/foco_repository.dart';

/// Estado visível da sincronização.
class EstadoSync {
  const EstadoSync({
    this.rodando = false,
    this.ultimoSucesso,
    this.ultimaMensagem,
    this.erro,
  });

  final bool rodando;
  final DateTime? ultimoSucesso;
  final String? ultimaMensagem;
  final String? erro;

  EstadoSync copyWith({bool? rodando, DateTime? ultimoSucesso, String? ultimaMensagem, String? erro}) =>
      EstadoSync(
        rodando: rodando ?? this.rodando,
        ultimoSucesso: ultimoSucesso ?? this.ultimoSucesso,
        ultimaMensagem: ultimaMensagem ?? this.ultimaMensagem,
        erro: erro,
      );
}

/// Contagem do que falta enviar.
class Pendencias {
  const Pendencias({this.registros = 0, this.fotos = 0, this.erros = 0});

  final int registros;
  final int fotos;
  final int erros;

  bool get vazio => registros == 0 && fotos == 0;
}

/// Serializa datas em ISO 8601 (UTC) e aceita os tipos que vêm do PostgREST.
class _SerializadorSync extends ValueSerializer {
  const _SerializadorSync();

  @override
  T fromJson<T>(dynamic json) {
    if (json == null) return null as T;
    final tipo = <T>[];
    if (tipo is List<DateTime?>) return DateTime.parse(json as String).toUtc() as T;
    if (tipo is List<double?>) return (json as num).toDouble() as T;
    if (tipo is List<int?>) return (json as num).toInt() as T;
    if (tipo is List<List<String>?>) return (json as List).cast<String>().toList() as T;
    return json as T;
  }

  @override
  dynamic toJson<T>(T value) {
    if (value is DateTime) return value.toUtc().toIso8601String();
    return value;
  }
}

const _serializador = _SerializadorSync();

/// Serializador usado na troca com o Supabase (exposto para os testes).
@visibleForTesting
const serializadorSync = _serializador;

String _snake(String camel) =>
    camel.replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

String _camel(String snake) =>
    snake.replaceAllMapped(RegExp(r'_([a-z0-9])'), (m) => m[1]!.toUpperCase());

/// Campos que só existem no aparelho e não sobem para o servidor.
const _soLocais = {'sync_status', 'server_updated_at', 'caminho_local', 'upload_status', 'upload_erro'};

/// Registro local (JSON do drift, camelCase) → linha do Supabase (snake_case).
@visibleForTesting
Map<String, dynamic> paraRemoto(Map<String, dynamic> local) => {
      for (final e in local.entries)
        if (!_soLocais.contains(_snake(e.key))) _snake(e.key): e.value,
    };

/// Linha do Supabase → JSON do drift, completando campos só locais com [padroes].
@visibleForTesting
Map<String, dynamic> paraLocal(Map<String, dynamic> remoto, Map<String, dynamic> padroes) => {
      ...padroes,
      for (final e in remoto.entries) _camel(e.key): e.value,
    };

/// Sincronização offline-first (§14.3): push dos pendentes, upload das fotos,
/// pull das novidades. Idempotente: o ID nasce no aparelho e o servidor faz upsert.
class SyncService {
  SyncService(this.db, this.config, this.focos);

  final AppDatabase db;
  final ConfigRepository config;
  final FocoRepository focos;

  final estado = ValueNotifier(const EstadoSync());
  Timer? _periodico;
  StreamSubscription<List<ConnectivityResult>>? _conexao;
  Future<void>? _emAndamento;

  SupabaseClient? get _cliente => SupabaseConfig.cliente;

  bool get disponivel => _cliente != null;
  bool get logado => _cliente?.auth.currentSession != null;

  /// Gatilhos: abrir o app, recuperar conexão e a cada 15 min com o app aberto.
  void iniciarGatilhos() {
    if (!disponivel) return;
    _conexao = Connectivity().onConnectivityChanged.listen((r) {
      if (!r.contains(ConnectivityResult.none)) sincronizar();
    });
    _periodico = Timer.periodic(const Duration(minutes: 15), (_) => sincronizar());
    sincronizar();
  }

  void dispose() {
    _periodico?.cancel();
    _conexao?.cancel();
  }

  Stream<Pendencias> observarPendencias() async* {
    yield await pendencias();
    await for (final _ in db.tableUpdates(TableUpdateQuery.onAllTables(
        [db.focos, db.observacoes, db.acoesManejo, db.midias, db.errosSync]))) {
      yield await pendencias();
    }
  }

  Future<Pendencias> pendencias() async {
    Future<int> contar(String tabela) async {
      final r = await db
          .customSelect("SELECT COUNT(*) AS n FROM $tabela WHERE sync_status != 'enviado'")
          .getSingle();
      return r.read<int>('n');
    }

    final registros = await contar('focos') +
        await contar('observacoes') +
        await contar('acoes_manejo') +
        await contar('midias');
    final fotos = (await db
            .customSelect("SELECT COUNT(*) AS n FROM midias "
                "WHERE upload_status != 'enviado' AND caminho_local IS NOT NULL AND deleted = 0")
            .getSingle())
        .read<int>('n');
    final erros = (await db.customSelect('SELECT COUNT(*) AS n FROM erros_sync').getSingle())
        .read<int>('n');
    return Pendencias(registros: registros, fotos: fotos, erros: erros);
  }

  /// Executa um ciclo completo. Chamadas simultâneas reaproveitam o ciclo em andamento.
  Future<void> sincronizar() => _emAndamento ??= _ciclo().whenComplete(() => _emAndamento = null);

  Future<void> _ciclo() async {
    final c = _cliente;
    if (c == null || c.auth.currentSession == null) return;
    final conexao = await Connectivity().checkConnectivity();
    if (conexao.contains(ConnectivityResult.none) && conexao.length == 1) return;

    estado.value = estado.value.copyWith(rodando: true);
    try {
      final enviados = await _push(c);
      final fotos = await _uploadFotos(c, wifi: conexao.contains(ConnectivityResult.wifi));
      if (fotos > 0) await _pushTabela(c, 'midias', db.midias);
      final recebidos = await _pull(c);
      final agora = DateTime.now().toUtc();
      await config.gravar(ConfigRepository.ultimoSync, agora.toIso8601String());
      estado.value = EstadoSync(
        ultimoSucesso: agora,
        ultimaMensagem: _resumo(enviados, fotos, recebidos),
      );
    } catch (e) {
      debugPrint('Sync falhou: $e');
      estado.value = estado.value.copyWith(rodando: false, erro: _mensagemErro(e));
    }
  }

  String _resumo(int enviados, int fotos, int recebidos) {
    if (enviados == 0 && fotos == 0 && recebidos == 0) return 'Tudo sincronizado';
    final partes = [
      if (enviados > 0) '$enviados ${enviados == 1 ? 'registro enviado' : 'registros enviados'}',
      if (fotos > 0) '$fotos ${fotos == 1 ? 'foto enviada' : 'fotos enviadas'}',
      if (recebidos > 0) '$recebidos ${recebidos == 1 ? 'novidade recebida' : 'novidades recebidas'}',
    ];
    return partes.join(' · ');
  }

  String _mensagemErro(Object e) {
    if (e is SocketException) return 'Sem conexão com o servidor.';
    if (e is AuthException) return 'Sessão expirada. Entre de novo.';
    if (e is PostgrestException) return 'Servidor recusou os dados: ${e.message}';
    return 'Erro na sincronização: $e';
  }

  // ------------------------------------------------------------------ push

  Future<int> _push(SupabaseClient c) async {
    var total = 0;
    total += await _pushTabela(c, 'focos', db.focos);
    total += await _pushTabela(c, 'observacoes', db.observacoes);
    total += await _pushTabela(c, 'acoes_manejo', db.acoesManejo);
    total += await _pushTabela(c, 'midias', db.midias);
    return total;
  }

  /// Registros com alteração ainda não enviada (`pendente` ou `erro`).
  ///
  /// A coluna é obtida com tipo estático: `.not()` é método de extensão do
  /// drift e não funciona por chamada dinâmica (quebrava só em tempo de execução).
  Future<List<D>> registrosPendentes<T extends Table, D extends DataClass>(TableInfo<T, D> tabela) {
    final status = tabela.columnsByName['sync_status']! as GeneratedColumn<String>;
    return (db.select(tabela)..where((_) => status.equals(SyncStatus.enviado).not())).get();
  }

  /// Envia os registros pendentes em lotes. Se um lote falhar, envia um a um
  /// para isolar o registro com problema (que fica com status `erro`).
  Future<int> _pushTabela<T extends Table, D extends DataClass>(
      SupabaseClient c, String nome, TableInfo<T, D> tabela) async {
    final pendentes = await registrosPendentes(tabela);
    final prontos = <D>[];
    for (final r in pendentes) {
      if (await _podeTentar(nome, r.toJson()['id'] as String)) prontos.add(r);
    }
    var enviados = 0;
    for (var i = 0; i < prontos.length; i += 200) {
      final lote = prontos.sublist(i, math.min(i + 200, prontos.length));
      try {
        await _enviarLote(c, nome, tabela, lote);
        enviados += lote.length;
      } catch (_) {
        for (final r in lote) {
          try {
            await _enviarLote(c, nome, tabela, [r]);
            enviados++;
          } catch (e) {
            await _registrarErro(nome, tabela, r, e);
          }
        }
      }
    }
    return enviados;
  }

  Future<void> _enviarLote<T extends Table, D extends DataClass>(
      SupabaseClient c, String nome, TableInfo<T, D> tabela, List<D> lote) async {
    final linhas = [for (final r in lote) paraRemoto(r.toJson(serializer: _serializador))];
    final resp = await c.from(nome).upsert(linhas, onConflict: 'id').select('id, server_updated_at');
    final servidor = {
      for (final r in resp) r['id'] as String: DateTime.parse(r['server_updated_at'] as String).toUtc(),
    };
    await db.transaction(() async {
      for (final r in lote) {
        final id = r.toJson()['id'] as String;
        final versao = r.toJson()['version'] as int;
        // Só marca como enviado se o registro não mudou durante o envio.
        await db.customUpdate(
          'UPDATE ${tabela.actualTableName} SET sync_status = ?, server_updated_at = ? '
          'WHERE id = ? AND version = ?',
          variables: [
            Variable.withString(SyncStatus.enviado),
            Variable.withString(servidor[id]?.toIso8601String() ?? DateTime.now().toUtc().toIso8601String()),
            Variable.withString(id),
            Variable.withInt(versao),
          ],
          updates: {tabela},
        );
        await (db.delete(db.errosSync)
              ..where((e) => e.tabela.equals(nome) & e.registroId.equals(id)))
            .go();
      }
    });
  }

  Future<void> _registrarErro<T extends Table, D extends DataClass>(
      String nome, TableInfo<T, D> tabela, D r, Object e) async {
    final id = r.toJson()['id'] as String;
    final anterior = await (db.select(db.errosSync)
          ..where((x) => x.tabela.equals(nome) & x.registroId.equals(id)))
        .getSingleOrNull();
    await db.into(db.errosSync).insertOnConflictUpdate(ErrosSyncCompanion.insert(
          tabela: nome,
          registroId: id,
          mensagem: _mensagemErro(e),
          tentativas: Value((anterior?.tentativas ?? 0) + 1),
          ultimaTentativa: DateTime.now().toUtc(),
        ));
    await db.customUpdate(
      'UPDATE ${tabela.actualTableName} SET sync_status = ? WHERE id = ?',
      variables: [Variable.withString(SyncStatus.erro), Variable.withString(id)],
      updates: {tabela},
    );
  }

  /// Espera crescente entre tentativas de um registro com erro (1, 2, 4… até 60 min).
  Future<bool> _podeTentar(String tabela, String id) async {
    final e = await (db.select(db.errosSync)
          ..where((x) => x.tabela.equals(tabela) & x.registroId.equals(id)))
        .getSingleOrNull();
    if (e == null) return true;
    final espera = Duration(minutes: math.min(60, 1 << math.min(e.tentativas - 1, 6)));
    return DateTime.now().toUtc().isAfter(e.ultimaTentativa.add(espera));
  }

  /// Ignora a espera e tenta de novo tudo o que deu erro.
  Future<void> tentarNovamenteErros() async {
    await db.update(db.errosSync).write(ErrosSyncCompanion(ultimaTentativa: Value(DateTime.utc(2000))));
    await sincronizar();
  }

  // ------------------------------------------------------------------ fotos

  Future<int> _uploadFotos(SupabaseClient c, {required bool wifi}) async {
    final soWifi = await config.lerBool(ConfigRepository.fotosSoWifi, padrao: true);
    if (soWifi && !wifi) return 0;
    final pendentes = await (db.select(db.midias)
          ..where((m) =>
              m.uploadStatus.equals(SyncStatus.enviado).not() &
              m.caminhoLocal.isNotNull() &
              m.deleted.equals(false)))
        .get();
    var enviadas = 0;
    for (final m in pendentes) {
      final arquivo = File(m.caminhoLocal!);
      if (!await arquivo.exists()) continue;
      final caminho = '${m.donoTipo}/${m.donoId}/${m.id}.jpg';
      try {
        await c.storage.from(SupabaseConfig.bucketMidias).upload(
              caminho,
              arquivo,
              fileOptions: const FileOptions(upsert: true, contentType: 'image/jpeg'),
            );
        await (db.update(db.midias)..where((x) => x.id.equals(m.id))).write(MidiasCompanion(
          caminhoRemoto: Value(caminho),
          uploadStatus: const Value(SyncStatus.enviado),
          uploadErro: const Value(null),
          syncStatus: const Value(SyncStatus.pendente),
          updatedAt: Value(DateTime.now().toUtc()),
          version: Value(m.version + 1),
        ));
        enviadas++;
      } catch (e) {
        await (db.update(db.midias)..where((x) => x.id.equals(m.id))).write(MidiasCompanion(
          uploadStatus: const Value(SyncStatus.erro),
          uploadErro: Value(_mensagemErro(e)),
        ));
      }
    }
    return enviadas;
  }

  // ------------------------------------------------------------------ pull

  Future<int> _pull(SupabaseClient c) async {
    final anterior = DateTime.tryParse(await config.ler(ConfigRepository.ultimoPull) ?? '') ??
        DateTime.utc(2000);
    // Margem para transações que confirmaram fora de ordem (upsert é idempotente).
    final desde = anterior.subtract(const Duration(minutes: 2)).toIso8601String();
    var maior = anterior;
    var recebidos = 0;
    final focosAfetados = <String>{};

    Future<List<Map<String, dynamic>>> buscar(String tabela) async {
      final todos = <Map<String, dynamic>>[];
      for (var de = 0;; de += 1000) {
        final pagina = await c
            .from(tabela)
            .select()
            .gt('server_updated_at', desde)
            .order('server_updated_at', ascending: true)
            .range(de, de + 999);
        todos.addAll(pagina);
        if (pagina.length < 1000) break;
      }
      for (final r in todos) {
        final s = DateTime.parse(r['server_updated_at'] as String).toUtc();
        if (s.isAfter(maior)) maior = s;
      }
      return todos;
    }

    final padroes = {'syncStatus': SyncStatus.enviado, 'deleted': false, 'version': 1};

    // Catálogos e usuários
    for (final r in await buscar('usuarios')) {
      await db.into(db.usuarios).insertOnConflictUpdate(
          Usuario.fromJson(paraLocal(r, padroes), serializer: _serializador));
    }
    for (final r in await buscar('especies')) {
      await db.into(db.especies).insertOnConflictUpdate(Especie.fromJson(
          paraLocal(r, {...padroes, 'fotosReferencia': <String>[], 'metodosSugeridos': <String>[]}),
          serializer: _serializador));
    }
    await _pullListas(c);

    // Dados de campo
    for (final r in await buscar('focos')) {
      final remoto = Foco.fromJson(
          paraLocal(r, {...padroes, 'motivosPrecoce': <String>[]}), serializer: _serializador);
      final local = await (db.select(db.focos)..where((f) => f.id.equals(remoto.id))).getSingleOrNull();
      if (_localVence(local?.syncStatus, local?.updatedAt, remoto.updatedAt)) continue;
      await db.into(db.focos).insertOnConflictUpdate(remoto);
      recebidos++;
    }
    for (final r in await buscar('observacoes')) {
      final remoto = Observacao.fromJson(paraLocal(r, padroes), serializer: _serializador);
      final local =
          await (db.select(db.observacoes)..where((o) => o.id.equals(remoto.id))).getSingleOrNull();
      if (_localVence(local?.syncStatus, local?.updatedAt, remoto.updatedAt)) continue;
      await db.into(db.observacoes).insertOnConflictUpdate(remoto);
      focosAfetados.add(remoto.focoId);
      recebidos++;
    }
    for (final r in await buscar('acoes_manejo')) {
      final remoto = AcaoManejo.fromJson(paraLocal(r, padroes), serializer: _serializador);
      final local =
          await (db.select(db.acoesManejo)..where((m) => m.id.equals(remoto.id))).getSingleOrNull();
      if (_localVence(local?.syncStatus, local?.updatedAt, remoto.updatedAt)) continue;
      await db.into(db.acoesManejo).insertOnConflictUpdate(remoto);
      focosAfetados.add(remoto.focoId);
      recebidos++;
    }
    for (final r in await buscar('midias')) {
      final local = await (db.select(db.midias)..where((m) => m.id.equals(r['id'] as String)))
          .getSingleOrNull();
      final remoto = Midia.fromJson(
          paraLocal(r, {
            ...padroes,
            'caminhoLocal': local?.caminhoLocal,
            'uploadStatus': r['caminho_remoto'] != null ? SyncStatus.enviado : SyncStatus.pendente,
          }),
          serializer: _serializador);
      if (_localVence(local?.syncStatus, local?.updatedAt, remoto.updatedAt)) continue;
      await db.into(db.midias).insertOnConflictUpdate(remoto);
      if (local?.caminhoLocal == null) await _baixarFoto(c, remoto);
    }

    // Status derivado: recalcula com as observações e manejos recebidos.
    if (focosAfetados.isNotEmpty) {
      final cfg = await config.lerRegras();
      for (final id in focosAfetados) {
        final existe = await (db.select(db.focos)..where((f) => f.id.equals(id))).getSingleOrNull();
        if (existe != null) await focos.recalcularStatus(id, cfg);
      }
    }

    await config.gravar(ConfigRepository.ultimoPull, maior.toIso8601String());
    return recebidos;
  }

  /// Última escrita vence (§14.3): só mantém o local se ele tem alteração
  /// pendente mais nova que a do servidor.
  bool _localVence(String? syncStatus, DateTime? localAtualizado, DateTime remotoAtualizado) =>
      syncStatus != null &&
      syncStatus != SyncStatus.enviado &&
      localAtualizado != null &&
      localAtualizado.isAfter(remotoAtualizado);

  Future<void> _pullListas(SupabaseClient c) async {
    try {
      final linhas = await c.from('lista_valor').select();
      if (linhas.isEmpty) return;
      await db.batch((b) {
        for (final r in linhas) {
          b.insert(
            db.listaValores,
            ListaValoresCompanion.insert(
              lista: r['lista'] as String,
              codigo: r['codigo'] as String,
              rotulo: r['rotulo'] as String,
              ordem: (r['ordem'] as num).toInt(),
              ativo: Value(r['ativo'] as bool? ?? true),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
    } catch (e) {
      debugPrint('Listas não sincronizadas: $e');
    }
  }

  Future<void> _baixarFoto(SupabaseClient c, Midia m) async {
    if (m.caminhoRemoto == null) return;
    try {
      final bytes = await c.storage.from(SupabaseConfig.bucketMidias).download(m.caminhoRemoto!);
      final destino = p.join((await ServicoFotos.pastaMidias()).path, '${m.id}.jpg');
      await File(destino).writeAsBytes(bytes);
      await (db.update(db.midias)..where((x) => x.id.equals(m.id)))
          .write(MidiasCompanion(caminhoLocal: Value(destino)));
    } catch (e) {
      debugPrint('Foto ${m.id} não baixada: $e');
    }
  }
}

/// Helper usado pela tela de pendências para listar o que falta enviar.
Future<List<(String, String, String)>> listarPendentes(AppDatabase db) async {
  final res = <(String, String, String)>[];
  for (final f in await (db.select(db.focos)..where((x) => x.syncStatus.equals(SyncStatus.enviado).not())).get()) {
    res.add(('Foco', f.codigo, f.syncStatus));
  }
  final obs = db.select(db.observacoes).join([innerJoin(db.focos, db.focos.id.equalsExp(db.observacoes.focoId))])
    ..where(db.observacoes.syncStatus.equals(SyncStatus.enviado).not());
  for (final l in await obs.get()) {
    final o = l.readTable(db.observacoes);
    res.add((o.tipo == TipoObservacao.deteccao ? 'Detecção' : 'Revisita', l.readTable(db.focos).codigo, o.syncStatus));
  }
  final man = db.select(db.acoesManejo).join([innerJoin(db.focos, db.focos.id.equalsExp(db.acoesManejo.focoId))])
    ..where(db.acoesManejo.syncStatus.equals(SyncStatus.enviado).not());
  for (final l in await man.get()) {
    res.add(('Manejo', l.readTable(db.focos).codigo, l.readTable(db.acoesManejo).syncStatus));
  }
  return res;
}
