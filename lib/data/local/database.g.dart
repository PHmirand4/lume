// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsuariosTable extends Usuarios with TableInfo<$UsuariosTable, Usuario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendente'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _perfilMeta = const VerificationMeta('perfil');
  @override
  late final GeneratedColumn<String> perfil = GeneratedColumn<String>(
    'perfil',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _funcaoMeta = const VerificationMeta('funcao');
  @override
  late final GeneratedColumn<String> funcao = GeneratedColumn<String>(
    'funcao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    nome,
    email,
    perfil,
    funcao,
    ativo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Usuario> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('perfil')) {
      context.handle(
        _perfilMeta,
        perfil.isAcceptableOrUnknown(data['perfil']!, _perfilMeta),
      );
    } else if (isInserting) {
      context.missing(_perfilMeta);
    }
    if (data.containsKey('funcao')) {
      context.handle(
        _funcaoMeta,
        funcao.isAcceptableOrUnknown(data['funcao']!, _funcaoMeta),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Usuario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Usuario(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      perfil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}perfil'],
      )!,
      funcao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}funcao'],
      ),
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }
}

class Usuario extends DataClass implements Insertable<Usuario> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? serverUpdatedAt;
  final bool deleted;
  final String syncStatus;
  final int version;
  final String id;
  final String nome;
  final String email;
  final String perfil;
  final String? funcao;
  final bool ativo;
  const Usuario({
    required this.createdAt,
    required this.updatedAt,
    this.serverUpdatedAt,
    required this.deleted,
    required this.syncStatus,
    required this.version,
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
    this.funcao,
    required this.ativo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['email'] = Variable<String>(email);
    map['perfil'] = Variable<String>(perfil);
    if (!nullToAbsent || funcao != null) {
      map['funcao'] = Variable<String>(funcao);
    }
    map['ativo'] = Variable<bool>(ativo);
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      deleted: Value(deleted),
      syncStatus: Value(syncStatus),
      version: Value(version),
      id: Value(id),
      nome: Value(nome),
      email: Value(email),
      perfil: Value(perfil),
      funcao: funcao == null && nullToAbsent
          ? const Value.absent()
          : Value(funcao),
      ativo: Value(ativo),
    );
  }

  factory Usuario.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Usuario(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      email: serializer.fromJson<String>(json['email']),
      perfil: serializer.fromJson<String>(json['perfil']),
      funcao: serializer.fromJson<String?>(json['funcao']),
      ativo: serializer.fromJson<bool>(json['ativo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'email': serializer.toJson<String>(email),
      'perfil': serializer.toJson<String>(perfil),
      'funcao': serializer.toJson<String?>(funcao),
      'ativo': serializer.toJson<bool>(ativo),
    };
  }

  Usuario copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    bool? deleted,
    String? syncStatus,
    int? version,
    String? id,
    String? nome,
    String? email,
    String? perfil,
    Value<String?> funcao = const Value.absent(),
    bool? ativo,
  }) => Usuario(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    deleted: deleted ?? this.deleted,
    syncStatus: syncStatus ?? this.syncStatus,
    version: version ?? this.version,
    id: id ?? this.id,
    nome: nome ?? this.nome,
    email: email ?? this.email,
    perfil: perfil ?? this.perfil,
    funcao: funcao.present ? funcao.value : this.funcao,
    ativo: ativo ?? this.ativo,
  );
  Usuario copyWithCompanion(UsuariosCompanion data) {
    return Usuario(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      email: data.email.present ? data.email.value : this.email,
      perfil: data.perfil.present ? data.perfil.value : this.perfil,
      funcao: data.funcao.present ? data.funcao.value : this.funcao,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Usuario(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('perfil: $perfil, ')
          ..write('funcao: $funcao, ')
          ..write('ativo: $ativo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    nome,
    email,
    perfil,
    funcao,
    ativo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Usuario &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deleted == this.deleted &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.email == this.email &&
          other.perfil == this.perfil &&
          other.funcao == this.funcao &&
          other.ativo == this.ativo);
}

class UsuariosCompanion extends UpdateCompanion<Usuario> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<bool> deleted;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<String> id;
  final Value<String> nome;
  final Value<String> email;
  final Value<String> perfil;
  final Value<String?> funcao;
  final Value<bool> ativo;
  final Value<int> rowid;
  const UsuariosCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.email = const Value.absent(),
    this.perfil = const Value.absent(),
    this.funcao = const Value.absent(),
    this.ativo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsuariosCompanion.insert({
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    required String id,
    required String nome,
    required String email,
    required String perfil,
    this.funcao = const Value.absent(),
    this.ativo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       nome = Value(nome),
       email = Value(email),
       perfil = Value(perfil);
  static Insertable<Usuario> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<bool>? deleted,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? email,
    Expression<String>? perfil,
    Expression<String>? funcao,
    Expression<bool>? ativo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deleted != null) 'deleted': deleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (email != null) 'email': email,
      if (perfil != null) 'perfil': perfil,
      if (funcao != null) 'funcao': funcao,
      if (ativo != null) 'ativo': ativo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsuariosCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? serverUpdatedAt,
    Value<bool>? deleted,
    Value<String>? syncStatus,
    Value<int>? version,
    Value<String>? id,
    Value<String>? nome,
    Value<String>? email,
    Value<String>? perfil,
    Value<String?>? funcao,
    Value<bool>? ativo,
    Value<int>? rowid,
  }) {
    return UsuariosCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deleted: deleted ?? this.deleted,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      perfil: perfil ?? this.perfil,
      funcao: funcao ?? this.funcao,
      ativo: ativo ?? this.ativo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (perfil.present) {
      map['perfil'] = Variable<String>(perfil.value);
    }
    if (funcao.present) {
      map['funcao'] = Variable<String>(funcao.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('perfil: $perfil, ')
          ..write('funcao: $funcao, ')
          ..write('ativo: $ativo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EspeciesTable extends Especies with TableInfo<$EspeciesTable, Especie> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EspeciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendente'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prefixoMeta = const VerificationMeta(
    'prefixo',
  );
  @override
  late final GeneratedColumn<String> prefixo = GeneratedColumn<String>(
    'prefixo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeCientificoMeta = const VerificationMeta(
    'nomeCientifico',
  );
  @override
  late final GeneratedColumn<String> nomeCientifico = GeneratedColumn<String>(
    'nome_cientifico',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  nomesPopulares = GeneratedColumn<String>(
    'nomes_populares',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($EspeciesTable.$converternomesPopulares);
  static const VerificationMeta _familiaMeta = const VerificationMeta(
    'familia',
  );
  @override
  late final GeneratedColumn<String> familia = GeneratedColumn<String>(
    'familia',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formaVidaMeta = const VerificationMeta(
    'formaVida',
  );
  @override
  late final GeneratedColumn<String> formaVida = GeneratedColumn<String>(
    'forma_vida',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoIdentificacaoMeta =
      const VerificationMeta('descricaoIdentificacao');
  @override
  late final GeneratedColumn<String> descricaoIdentificacao =
      GeneratedColumn<String>(
        'descricao_identificacao',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _confusaoComMeta = const VerificationMeta(
    'confusaoCom',
  );
  @override
  late final GeneratedColumn<String> confusaoCom = GeneratedColumn<String>(
    'confusao_com',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _controleCitadoMeta = const VerificationMeta(
    'controleCitado',
  );
  @override
  late final GeneratedColumn<String> controleCitado = GeneratedColumn<String>(
    'controle_citado',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  metodosSugeridos = GeneratedColumn<String>(
    'metodos_sugeridos',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($EspeciesTable.$convertermetodosSugeridos);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  fotosReferencia = GeneratedColumn<String>(
    'fotos_referencia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($EspeciesTable.$converterfotosReferencia);
  static const VerificationMeta _prioridadeMeta = const VerificationMeta(
    'prioridade',
  );
  @override
  late final GeneratedColumn<int> prioridade = GeneratedColumn<int>(
    'prioridade',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _naListaOficialIcmbioMeta =
      const VerificationMeta('naListaOficialIcmbio');
  @override
  late final GeneratedColumn<bool> naListaOficialIcmbio = GeneratedColumn<bool>(
    'na_lista_oficial_icmbio',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("na_lista_oficial_icmbio" IN (0, 1))',
    ),
  );
  static const VerificationMeta _ativaMeta = const VerificationMeta('ativa');
  @override
  late final GeneratedColumn<bool> ativa = GeneratedColumn<bool>(
    'ativa',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativa" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    prefixo,
    nomeCientifico,
    nomesPopulares,
    familia,
    formaVida,
    descricaoIdentificacao,
    confusaoCom,
    controleCitado,
    metodosSugeridos,
    fotosReferencia,
    prioridade,
    naListaOficialIcmbio,
    ativa,
    ordem,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'especies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Especie> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('prefixo')) {
      context.handle(
        _prefixoMeta,
        prefixo.isAcceptableOrUnknown(data['prefixo']!, _prefixoMeta),
      );
    } else if (isInserting) {
      context.missing(_prefixoMeta);
    }
    if (data.containsKey('nome_cientifico')) {
      context.handle(
        _nomeCientificoMeta,
        nomeCientifico.isAcceptableOrUnknown(
          data['nome_cientifico']!,
          _nomeCientificoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nomeCientificoMeta);
    }
    if (data.containsKey('familia')) {
      context.handle(
        _familiaMeta,
        familia.isAcceptableOrUnknown(data['familia']!, _familiaMeta),
      );
    }
    if (data.containsKey('forma_vida')) {
      context.handle(
        _formaVidaMeta,
        formaVida.isAcceptableOrUnknown(data['forma_vida']!, _formaVidaMeta),
      );
    } else if (isInserting) {
      context.missing(_formaVidaMeta);
    }
    if (data.containsKey('descricao_identificacao')) {
      context.handle(
        _descricaoIdentificacaoMeta,
        descricaoIdentificacao.isAcceptableOrUnknown(
          data['descricao_identificacao']!,
          _descricaoIdentificacaoMeta,
        ),
      );
    }
    if (data.containsKey('confusao_com')) {
      context.handle(
        _confusaoComMeta,
        confusaoCom.isAcceptableOrUnknown(
          data['confusao_com']!,
          _confusaoComMeta,
        ),
      );
    }
    if (data.containsKey('controle_citado')) {
      context.handle(
        _controleCitadoMeta,
        controleCitado.isAcceptableOrUnknown(
          data['controle_citado']!,
          _controleCitadoMeta,
        ),
      );
    }
    if (data.containsKey('prioridade')) {
      context.handle(
        _prioridadeMeta,
        prioridade.isAcceptableOrUnknown(data['prioridade']!, _prioridadeMeta),
      );
    }
    if (data.containsKey('na_lista_oficial_icmbio')) {
      context.handle(
        _naListaOficialIcmbioMeta,
        naListaOficialIcmbio.isAcceptableOrUnknown(
          data['na_lista_oficial_icmbio']!,
          _naListaOficialIcmbioMeta,
        ),
      );
    }
    if (data.containsKey('ativa')) {
      context.handle(
        _ativaMeta,
        ativa.isAcceptableOrUnknown(data['ativa']!, _ativaMeta),
      );
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Especie map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Especie(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      prefixo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prefixo'],
      )!,
      nomeCientifico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_cientifico'],
      )!,
      nomesPopulares: $EspeciesTable.$converternomesPopulares.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}nomes_populares'],
        )!,
      ),
      familia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}familia'],
      ),
      formaVida: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}forma_vida'],
      )!,
      descricaoIdentificacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao_identificacao'],
      ),
      confusaoCom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confusao_com'],
      ),
      controleCitado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}controle_citado'],
      ),
      metodosSugeridos: $EspeciesTable.$convertermetodosSugeridos.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}metodos_sugeridos'],
        )!,
      ),
      fotosReferencia: $EspeciesTable.$converterfotosReferencia.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fotos_referencia'],
        )!,
      ),
      prioridade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prioridade'],
      ),
      naListaOficialIcmbio: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}na_lista_oficial_icmbio'],
      ),
      ativa: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativa'],
      )!,
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
    );
  }

  @override
  $EspeciesTable createAlias(String alias) {
    return $EspeciesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converternomesPopulares =
      const ListaTextoConverter();
  static TypeConverter<List<String>, String> $convertermetodosSugeridos =
      const ListaTextoConverter();
  static TypeConverter<List<String>, String> $converterfotosReferencia =
      const ListaTextoConverter();
}

class Especie extends DataClass implements Insertable<Especie> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? serverUpdatedAt;
  final bool deleted;
  final String syncStatus;
  final int version;
  final String id;
  final String prefixo;
  final String nomeCientifico;
  final List<String> nomesPopulares;
  final String? familia;
  final String formaVida;
  final String? descricaoIdentificacao;
  final String? confusaoCom;
  final String? controleCitado;
  final List<String> metodosSugeridos;
  final List<String> fotosReferencia;
  final int? prioridade;
  final bool? naListaOficialIcmbio;
  final bool ativa;
  final int ordem;
  const Especie({
    required this.createdAt,
    required this.updatedAt,
    this.serverUpdatedAt,
    required this.deleted,
    required this.syncStatus,
    required this.version,
    required this.id,
    required this.prefixo,
    required this.nomeCientifico,
    required this.nomesPopulares,
    this.familia,
    required this.formaVida,
    this.descricaoIdentificacao,
    this.confusaoCom,
    this.controleCitado,
    required this.metodosSugeridos,
    required this.fotosReferencia,
    this.prioridade,
    this.naListaOficialIcmbio,
    required this.ativa,
    required this.ordem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    map['id'] = Variable<String>(id);
    map['prefixo'] = Variable<String>(prefixo);
    map['nome_cientifico'] = Variable<String>(nomeCientifico);
    {
      map['nomes_populares'] = Variable<String>(
        $EspeciesTable.$converternomesPopulares.toSql(nomesPopulares),
      );
    }
    if (!nullToAbsent || familia != null) {
      map['familia'] = Variable<String>(familia);
    }
    map['forma_vida'] = Variable<String>(formaVida);
    if (!nullToAbsent || descricaoIdentificacao != null) {
      map['descricao_identificacao'] = Variable<String>(descricaoIdentificacao);
    }
    if (!nullToAbsent || confusaoCom != null) {
      map['confusao_com'] = Variable<String>(confusaoCom);
    }
    if (!nullToAbsent || controleCitado != null) {
      map['controle_citado'] = Variable<String>(controleCitado);
    }
    {
      map['metodos_sugeridos'] = Variable<String>(
        $EspeciesTable.$convertermetodosSugeridos.toSql(metodosSugeridos),
      );
    }
    {
      map['fotos_referencia'] = Variable<String>(
        $EspeciesTable.$converterfotosReferencia.toSql(fotosReferencia),
      );
    }
    if (!nullToAbsent || prioridade != null) {
      map['prioridade'] = Variable<int>(prioridade);
    }
    if (!nullToAbsent || naListaOficialIcmbio != null) {
      map['na_lista_oficial_icmbio'] = Variable<bool>(naListaOficialIcmbio);
    }
    map['ativa'] = Variable<bool>(ativa);
    map['ordem'] = Variable<int>(ordem);
    return map;
  }

  EspeciesCompanion toCompanion(bool nullToAbsent) {
    return EspeciesCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      deleted: Value(deleted),
      syncStatus: Value(syncStatus),
      version: Value(version),
      id: Value(id),
      prefixo: Value(prefixo),
      nomeCientifico: Value(nomeCientifico),
      nomesPopulares: Value(nomesPopulares),
      familia: familia == null && nullToAbsent
          ? const Value.absent()
          : Value(familia),
      formaVida: Value(formaVida),
      descricaoIdentificacao: descricaoIdentificacao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricaoIdentificacao),
      confusaoCom: confusaoCom == null && nullToAbsent
          ? const Value.absent()
          : Value(confusaoCom),
      controleCitado: controleCitado == null && nullToAbsent
          ? const Value.absent()
          : Value(controleCitado),
      metodosSugeridos: Value(metodosSugeridos),
      fotosReferencia: Value(fotosReferencia),
      prioridade: prioridade == null && nullToAbsent
          ? const Value.absent()
          : Value(prioridade),
      naListaOficialIcmbio: naListaOficialIcmbio == null && nullToAbsent
          ? const Value.absent()
          : Value(naListaOficialIcmbio),
      ativa: Value(ativa),
      ordem: Value(ordem),
    );
  }

  factory Especie.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Especie(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
      id: serializer.fromJson<String>(json['id']),
      prefixo: serializer.fromJson<String>(json['prefixo']),
      nomeCientifico: serializer.fromJson<String>(json['nomeCientifico']),
      nomesPopulares: serializer.fromJson<List<String>>(json['nomesPopulares']),
      familia: serializer.fromJson<String?>(json['familia']),
      formaVida: serializer.fromJson<String>(json['formaVida']),
      descricaoIdentificacao: serializer.fromJson<String?>(
        json['descricaoIdentificacao'],
      ),
      confusaoCom: serializer.fromJson<String?>(json['confusaoCom']),
      controleCitado: serializer.fromJson<String?>(json['controleCitado']),
      metodosSugeridos: serializer.fromJson<List<String>>(
        json['metodosSugeridos'],
      ),
      fotosReferencia: serializer.fromJson<List<String>>(
        json['fotosReferencia'],
      ),
      prioridade: serializer.fromJson<int?>(json['prioridade']),
      naListaOficialIcmbio: serializer.fromJson<bool?>(
        json['naListaOficialIcmbio'],
      ),
      ativa: serializer.fromJson<bool>(json['ativa']),
      ordem: serializer.fromJson<int>(json['ordem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
      'id': serializer.toJson<String>(id),
      'prefixo': serializer.toJson<String>(prefixo),
      'nomeCientifico': serializer.toJson<String>(nomeCientifico),
      'nomesPopulares': serializer.toJson<List<String>>(nomesPopulares),
      'familia': serializer.toJson<String?>(familia),
      'formaVida': serializer.toJson<String>(formaVida),
      'descricaoIdentificacao': serializer.toJson<String?>(
        descricaoIdentificacao,
      ),
      'confusaoCom': serializer.toJson<String?>(confusaoCom),
      'controleCitado': serializer.toJson<String?>(controleCitado),
      'metodosSugeridos': serializer.toJson<List<String>>(metodosSugeridos),
      'fotosReferencia': serializer.toJson<List<String>>(fotosReferencia),
      'prioridade': serializer.toJson<int?>(prioridade),
      'naListaOficialIcmbio': serializer.toJson<bool?>(naListaOficialIcmbio),
      'ativa': serializer.toJson<bool>(ativa),
      'ordem': serializer.toJson<int>(ordem),
    };
  }

  Especie copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    bool? deleted,
    String? syncStatus,
    int? version,
    String? id,
    String? prefixo,
    String? nomeCientifico,
    List<String>? nomesPopulares,
    Value<String?> familia = const Value.absent(),
    String? formaVida,
    Value<String?> descricaoIdentificacao = const Value.absent(),
    Value<String?> confusaoCom = const Value.absent(),
    Value<String?> controleCitado = const Value.absent(),
    List<String>? metodosSugeridos,
    List<String>? fotosReferencia,
    Value<int?> prioridade = const Value.absent(),
    Value<bool?> naListaOficialIcmbio = const Value.absent(),
    bool? ativa,
    int? ordem,
  }) => Especie(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    deleted: deleted ?? this.deleted,
    syncStatus: syncStatus ?? this.syncStatus,
    version: version ?? this.version,
    id: id ?? this.id,
    prefixo: prefixo ?? this.prefixo,
    nomeCientifico: nomeCientifico ?? this.nomeCientifico,
    nomesPopulares: nomesPopulares ?? this.nomesPopulares,
    familia: familia.present ? familia.value : this.familia,
    formaVida: formaVida ?? this.formaVida,
    descricaoIdentificacao: descricaoIdentificacao.present
        ? descricaoIdentificacao.value
        : this.descricaoIdentificacao,
    confusaoCom: confusaoCom.present ? confusaoCom.value : this.confusaoCom,
    controleCitado: controleCitado.present
        ? controleCitado.value
        : this.controleCitado,
    metodosSugeridos: metodosSugeridos ?? this.metodosSugeridos,
    fotosReferencia: fotosReferencia ?? this.fotosReferencia,
    prioridade: prioridade.present ? prioridade.value : this.prioridade,
    naListaOficialIcmbio: naListaOficialIcmbio.present
        ? naListaOficialIcmbio.value
        : this.naListaOficialIcmbio,
    ativa: ativa ?? this.ativa,
    ordem: ordem ?? this.ordem,
  );
  Especie copyWithCompanion(EspeciesCompanion data) {
    return Especie(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
      id: data.id.present ? data.id.value : this.id,
      prefixo: data.prefixo.present ? data.prefixo.value : this.prefixo,
      nomeCientifico: data.nomeCientifico.present
          ? data.nomeCientifico.value
          : this.nomeCientifico,
      nomesPopulares: data.nomesPopulares.present
          ? data.nomesPopulares.value
          : this.nomesPopulares,
      familia: data.familia.present ? data.familia.value : this.familia,
      formaVida: data.formaVida.present ? data.formaVida.value : this.formaVida,
      descricaoIdentificacao: data.descricaoIdentificacao.present
          ? data.descricaoIdentificacao.value
          : this.descricaoIdentificacao,
      confusaoCom: data.confusaoCom.present
          ? data.confusaoCom.value
          : this.confusaoCom,
      controleCitado: data.controleCitado.present
          ? data.controleCitado.value
          : this.controleCitado,
      metodosSugeridos: data.metodosSugeridos.present
          ? data.metodosSugeridos.value
          : this.metodosSugeridos,
      fotosReferencia: data.fotosReferencia.present
          ? data.fotosReferencia.value
          : this.fotosReferencia,
      prioridade: data.prioridade.present
          ? data.prioridade.value
          : this.prioridade,
      naListaOficialIcmbio: data.naListaOficialIcmbio.present
          ? data.naListaOficialIcmbio.value
          : this.naListaOficialIcmbio,
      ativa: data.ativa.present ? data.ativa.value : this.ativa,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Especie(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('prefixo: $prefixo, ')
          ..write('nomeCientifico: $nomeCientifico, ')
          ..write('nomesPopulares: $nomesPopulares, ')
          ..write('familia: $familia, ')
          ..write('formaVida: $formaVida, ')
          ..write('descricaoIdentificacao: $descricaoIdentificacao, ')
          ..write('confusaoCom: $confusaoCom, ')
          ..write('controleCitado: $controleCitado, ')
          ..write('metodosSugeridos: $metodosSugeridos, ')
          ..write('fotosReferencia: $fotosReferencia, ')
          ..write('prioridade: $prioridade, ')
          ..write('naListaOficialIcmbio: $naListaOficialIcmbio, ')
          ..write('ativa: $ativa, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    prefixo,
    nomeCientifico,
    nomesPopulares,
    familia,
    formaVida,
    descricaoIdentificacao,
    confusaoCom,
    controleCitado,
    metodosSugeridos,
    fotosReferencia,
    prioridade,
    naListaOficialIcmbio,
    ativa,
    ordem,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Especie &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deleted == this.deleted &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version &&
          other.id == this.id &&
          other.prefixo == this.prefixo &&
          other.nomeCientifico == this.nomeCientifico &&
          other.nomesPopulares == this.nomesPopulares &&
          other.familia == this.familia &&
          other.formaVida == this.formaVida &&
          other.descricaoIdentificacao == this.descricaoIdentificacao &&
          other.confusaoCom == this.confusaoCom &&
          other.controleCitado == this.controleCitado &&
          other.metodosSugeridos == this.metodosSugeridos &&
          other.fotosReferencia == this.fotosReferencia &&
          other.prioridade == this.prioridade &&
          other.naListaOficialIcmbio == this.naListaOficialIcmbio &&
          other.ativa == this.ativa &&
          other.ordem == this.ordem);
}

class EspeciesCompanion extends UpdateCompanion<Especie> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<bool> deleted;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<String> id;
  final Value<String> prefixo;
  final Value<String> nomeCientifico;
  final Value<List<String>> nomesPopulares;
  final Value<String?> familia;
  final Value<String> formaVida;
  final Value<String?> descricaoIdentificacao;
  final Value<String?> confusaoCom;
  final Value<String?> controleCitado;
  final Value<List<String>> metodosSugeridos;
  final Value<List<String>> fotosReferencia;
  final Value<int?> prioridade;
  final Value<bool?> naListaOficialIcmbio;
  final Value<bool> ativa;
  final Value<int> ordem;
  final Value<int> rowid;
  const EspeciesCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.id = const Value.absent(),
    this.prefixo = const Value.absent(),
    this.nomeCientifico = const Value.absent(),
    this.nomesPopulares = const Value.absent(),
    this.familia = const Value.absent(),
    this.formaVida = const Value.absent(),
    this.descricaoIdentificacao = const Value.absent(),
    this.confusaoCom = const Value.absent(),
    this.controleCitado = const Value.absent(),
    this.metodosSugeridos = const Value.absent(),
    this.fotosReferencia = const Value.absent(),
    this.prioridade = const Value.absent(),
    this.naListaOficialIcmbio = const Value.absent(),
    this.ativa = const Value.absent(),
    this.ordem = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EspeciesCompanion.insert({
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    required String id,
    required String prefixo,
    required String nomeCientifico,
    required List<String> nomesPopulares,
    this.familia = const Value.absent(),
    required String formaVida,
    this.descricaoIdentificacao = const Value.absent(),
    this.confusaoCom = const Value.absent(),
    this.controleCitado = const Value.absent(),
    required List<String> metodosSugeridos,
    required List<String> fotosReferencia,
    this.prioridade = const Value.absent(),
    this.naListaOficialIcmbio = const Value.absent(),
    this.ativa = const Value.absent(),
    this.ordem = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       prefixo = Value(prefixo),
       nomeCientifico = Value(nomeCientifico),
       nomesPopulares = Value(nomesPopulares),
       formaVida = Value(formaVida),
       metodosSugeridos = Value(metodosSugeridos),
       fotosReferencia = Value(fotosReferencia);
  static Insertable<Especie> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<bool>? deleted,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<String>? id,
    Expression<String>? prefixo,
    Expression<String>? nomeCientifico,
    Expression<String>? nomesPopulares,
    Expression<String>? familia,
    Expression<String>? formaVida,
    Expression<String>? descricaoIdentificacao,
    Expression<String>? confusaoCom,
    Expression<String>? controleCitado,
    Expression<String>? metodosSugeridos,
    Expression<String>? fotosReferencia,
    Expression<int>? prioridade,
    Expression<bool>? naListaOficialIcmbio,
    Expression<bool>? ativa,
    Expression<int>? ordem,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deleted != null) 'deleted': deleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (id != null) 'id': id,
      if (prefixo != null) 'prefixo': prefixo,
      if (nomeCientifico != null) 'nome_cientifico': nomeCientifico,
      if (nomesPopulares != null) 'nomes_populares': nomesPopulares,
      if (familia != null) 'familia': familia,
      if (formaVida != null) 'forma_vida': formaVida,
      if (descricaoIdentificacao != null)
        'descricao_identificacao': descricaoIdentificacao,
      if (confusaoCom != null) 'confusao_com': confusaoCom,
      if (controleCitado != null) 'controle_citado': controleCitado,
      if (metodosSugeridos != null) 'metodos_sugeridos': metodosSugeridos,
      if (fotosReferencia != null) 'fotos_referencia': fotosReferencia,
      if (prioridade != null) 'prioridade': prioridade,
      if (naListaOficialIcmbio != null)
        'na_lista_oficial_icmbio': naListaOficialIcmbio,
      if (ativa != null) 'ativa': ativa,
      if (ordem != null) 'ordem': ordem,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EspeciesCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? serverUpdatedAt,
    Value<bool>? deleted,
    Value<String>? syncStatus,
    Value<int>? version,
    Value<String>? id,
    Value<String>? prefixo,
    Value<String>? nomeCientifico,
    Value<List<String>>? nomesPopulares,
    Value<String?>? familia,
    Value<String>? formaVida,
    Value<String?>? descricaoIdentificacao,
    Value<String?>? confusaoCom,
    Value<String?>? controleCitado,
    Value<List<String>>? metodosSugeridos,
    Value<List<String>>? fotosReferencia,
    Value<int?>? prioridade,
    Value<bool?>? naListaOficialIcmbio,
    Value<bool>? ativa,
    Value<int>? ordem,
    Value<int>? rowid,
  }) {
    return EspeciesCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deleted: deleted ?? this.deleted,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      id: id ?? this.id,
      prefixo: prefixo ?? this.prefixo,
      nomeCientifico: nomeCientifico ?? this.nomeCientifico,
      nomesPopulares: nomesPopulares ?? this.nomesPopulares,
      familia: familia ?? this.familia,
      formaVida: formaVida ?? this.formaVida,
      descricaoIdentificacao:
          descricaoIdentificacao ?? this.descricaoIdentificacao,
      confusaoCom: confusaoCom ?? this.confusaoCom,
      controleCitado: controleCitado ?? this.controleCitado,
      metodosSugeridos: metodosSugeridos ?? this.metodosSugeridos,
      fotosReferencia: fotosReferencia ?? this.fotosReferencia,
      prioridade: prioridade ?? this.prioridade,
      naListaOficialIcmbio: naListaOficialIcmbio ?? this.naListaOficialIcmbio,
      ativa: ativa ?? this.ativa,
      ordem: ordem ?? this.ordem,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (prefixo.present) {
      map['prefixo'] = Variable<String>(prefixo.value);
    }
    if (nomeCientifico.present) {
      map['nome_cientifico'] = Variable<String>(nomeCientifico.value);
    }
    if (nomesPopulares.present) {
      map['nomes_populares'] = Variable<String>(
        $EspeciesTable.$converternomesPopulares.toSql(nomesPopulares.value),
      );
    }
    if (familia.present) {
      map['familia'] = Variable<String>(familia.value);
    }
    if (formaVida.present) {
      map['forma_vida'] = Variable<String>(formaVida.value);
    }
    if (descricaoIdentificacao.present) {
      map['descricao_identificacao'] = Variable<String>(
        descricaoIdentificacao.value,
      );
    }
    if (confusaoCom.present) {
      map['confusao_com'] = Variable<String>(confusaoCom.value);
    }
    if (controleCitado.present) {
      map['controle_citado'] = Variable<String>(controleCitado.value);
    }
    if (metodosSugeridos.present) {
      map['metodos_sugeridos'] = Variable<String>(
        $EspeciesTable.$convertermetodosSugeridos.toSql(metodosSugeridos.value),
      );
    }
    if (fotosReferencia.present) {
      map['fotos_referencia'] = Variable<String>(
        $EspeciesTable.$converterfotosReferencia.toSql(fotosReferencia.value),
      );
    }
    if (prioridade.present) {
      map['prioridade'] = Variable<int>(prioridade.value);
    }
    if (naListaOficialIcmbio.present) {
      map['na_lista_oficial_icmbio'] = Variable<bool>(
        naListaOficialIcmbio.value,
      );
    }
    if (ativa.present) {
      map['ativa'] = Variable<bool>(ativa.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EspeciesCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('prefixo: $prefixo, ')
          ..write('nomeCientifico: $nomeCientifico, ')
          ..write('nomesPopulares: $nomesPopulares, ')
          ..write('familia: $familia, ')
          ..write('formaVida: $formaVida, ')
          ..write('descricaoIdentificacao: $descricaoIdentificacao, ')
          ..write('confusaoCom: $confusaoCom, ')
          ..write('controleCitado: $controleCitado, ')
          ..write('metodosSugeridos: $metodosSugeridos, ')
          ..write('fotosReferencia: $fotosReferencia, ')
          ..write('prioridade: $prioridade, ')
          ..write('naListaOficialIcmbio: $naListaOficialIcmbio, ')
          ..write('ativa: $ativa, ')
          ..write('ordem: $ordem, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocosTable extends Focos with TableInfo<$FocosTable, Foco> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendente'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _especieIdMeta = const VerificationMeta(
    'especieId',
  );
  @override
  late final GeneratedColumn<String> especieId = GeneratedColumn<String>(
    'especie_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES especies (id)',
    ),
  );
  static const VerificationMeta _especieTextoMeta = const VerificationMeta(
    'especieTexto',
  );
  @override
  late final GeneratedColumn<String> especieTexto = GeneratedColumn<String>(
    'especie_texto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precisaoMMeta = const VerificationMeta(
    'precisaoM',
  );
  @override
  late final GeneratedColumn<double> precisaoM = GeneratedColumn<double>(
    'precisao_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _origemCoordenadaMeta = const VerificationMeta(
    'origemCoordenada',
  );
  @override
  late final GeneratedColumn<String> origemCoordenada = GeneratedColumn<String>(
    'origem_coordenada',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zonaMeta = const VerificationMeta('zona');
  @override
  late final GeneratedColumn<String> zona = GeneratedColumn<String>(
    'zona',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ambienteMeta = const VerificationMeta(
    'ambiente',
  );
  @override
  late final GeneratedColumn<String> ambiente = GeneratedColumn<String>(
    'ambiente',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusManualMeta = const VerificationMeta(
    'statusManual',
  );
  @override
  late final GeneratedColumn<bool> statusManual = GeneratedColumn<bool>(
    'status_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("status_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusAlteradoPorMeta = const VerificationMeta(
    'statusAlteradoPor',
  );
  @override
  late final GeneratedColumn<String> statusAlteradoPor =
      GeneratedColumn<String>(
        'status_alterado_por',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusAlteradoEmMeta = const VerificationMeta(
    'statusAlteradoEm',
  );
  @override
  late final GeneratedColumn<DateTime> statusAlteradoEm =
      GeneratedColumn<DateTime>(
        'status_alterado_em',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deteccaoPrecoceMeta = const VerificationMeta(
    'deteccaoPrecoce',
  );
  @override
  late final GeneratedColumn<bool> deteccaoPrecoce = GeneratedColumn<bool>(
    'deteccao_precoce',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deteccao_precoce" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  motivosPrecoce = GeneratedColumn<String>(
    'motivos_precoce',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($FocosTable.$convertermotivosPrecoce);
  static const VerificationMeta _foraDoLimiteMeta = const VerificationMeta(
    'foraDoLimite',
  );
  @override
  late final GeneratedColumn<bool> foraDoLimite = GeneratedColumn<bool>(
    'fora_do_limite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fora_do_limite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _criadoPorMeta = const VerificationMeta(
    'criadoPor',
  );
  @override
  late final GeneratedColumn<String> criadoPor = GeneratedColumn<String>(
    'criado_por',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primeiraDeteccaoEmMeta =
      const VerificationMeta('primeiraDeteccaoEm');
  @override
  late final GeneratedColumn<DateTime> primeiraDeteccaoEm =
      GeneratedColumn<DateTime>(
        'primeira_deteccao_em',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _ultimaVisitaEmMeta = const VerificationMeta(
    'ultimaVisitaEm',
  );
  @override
  late final GeneratedColumn<DateTime> ultimaVisitaEm =
      GeneratedColumn<DateTime>(
        'ultima_visita_em',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _ultimaAbundanciaMeta = const VerificationMeta(
    'ultimaAbundancia',
  );
  @override
  late final GeneratedColumn<String> ultimaAbundancia = GeneratedColumn<String>(
    'ultima_abundancia',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    especieId,
    especieTexto,
    codigo,
    lat,
    lon,
    precisaoM,
    origemCoordenada,
    zona,
    ambiente,
    status,
    statusManual,
    statusAlteradoPor,
    statusAlteradoEm,
    deteccaoPrecoce,
    motivosPrecoce,
    foraDoLimite,
    criadoPor,
    primeiraDeteccaoEm,
    ultimaVisitaEm,
    ultimaAbundancia,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Foco> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('especie_id')) {
      context.handle(
        _especieIdMeta,
        especieId.isAcceptableOrUnknown(data['especie_id']!, _especieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_especieIdMeta);
    }
    if (data.containsKey('especie_texto')) {
      context.handle(
        _especieTextoMeta,
        especieTexto.isAcceptableOrUnknown(
          data['especie_texto']!,
          _especieTextoMeta,
        ),
      );
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('precisao_m')) {
      context.handle(
        _precisaoMMeta,
        precisaoM.isAcceptableOrUnknown(data['precisao_m']!, _precisaoMMeta),
      );
    }
    if (data.containsKey('origem_coordenada')) {
      context.handle(
        _origemCoordenadaMeta,
        origemCoordenada.isAcceptableOrUnknown(
          data['origem_coordenada']!,
          _origemCoordenadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_origemCoordenadaMeta);
    }
    if (data.containsKey('zona')) {
      context.handle(
        _zonaMeta,
        zona.isAcceptableOrUnknown(data['zona']!, _zonaMeta),
      );
    }
    if (data.containsKey('ambiente')) {
      context.handle(
        _ambienteMeta,
        ambiente.isAcceptableOrUnknown(data['ambiente']!, _ambienteMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('status_manual')) {
      context.handle(
        _statusManualMeta,
        statusManual.isAcceptableOrUnknown(
          data['status_manual']!,
          _statusManualMeta,
        ),
      );
    }
    if (data.containsKey('status_alterado_por')) {
      context.handle(
        _statusAlteradoPorMeta,
        statusAlteradoPor.isAcceptableOrUnknown(
          data['status_alterado_por']!,
          _statusAlteradoPorMeta,
        ),
      );
    }
    if (data.containsKey('status_alterado_em')) {
      context.handle(
        _statusAlteradoEmMeta,
        statusAlteradoEm.isAcceptableOrUnknown(
          data['status_alterado_em']!,
          _statusAlteradoEmMeta,
        ),
      );
    }
    if (data.containsKey('deteccao_precoce')) {
      context.handle(
        _deteccaoPrecoceMeta,
        deteccaoPrecoce.isAcceptableOrUnknown(
          data['deteccao_precoce']!,
          _deteccaoPrecoceMeta,
        ),
      );
    }
    if (data.containsKey('fora_do_limite')) {
      context.handle(
        _foraDoLimiteMeta,
        foraDoLimite.isAcceptableOrUnknown(
          data['fora_do_limite']!,
          _foraDoLimiteMeta,
        ),
      );
    }
    if (data.containsKey('criado_por')) {
      context.handle(
        _criadoPorMeta,
        criadoPor.isAcceptableOrUnknown(data['criado_por']!, _criadoPorMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoPorMeta);
    }
    if (data.containsKey('primeira_deteccao_em')) {
      context.handle(
        _primeiraDeteccaoEmMeta,
        primeiraDeteccaoEm.isAcceptableOrUnknown(
          data['primeira_deteccao_em']!,
          _primeiraDeteccaoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primeiraDeteccaoEmMeta);
    }
    if (data.containsKey('ultima_visita_em')) {
      context.handle(
        _ultimaVisitaEmMeta,
        ultimaVisitaEm.isAcceptableOrUnknown(
          data['ultima_visita_em']!,
          _ultimaVisitaEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ultimaVisitaEmMeta);
    }
    if (data.containsKey('ultima_abundancia')) {
      context.handle(
        _ultimaAbundanciaMeta,
        ultimaAbundancia.isAcceptableOrUnknown(
          data['ultima_abundancia']!,
          _ultimaAbundanciaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Foco map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Foco(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      especieId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}especie_id'],
      )!,
      especieTexto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}especie_texto'],
      ),
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      precisaoM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precisao_m'],
      ),
      origemCoordenada: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origem_coordenada'],
      )!,
      zona: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zona'],
      ),
      ambiente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ambiente'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      statusManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}status_manual'],
      )!,
      statusAlteradoPor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_alterado_por'],
      ),
      statusAlteradoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}status_alterado_em'],
      ),
      deteccaoPrecoce: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deteccao_precoce'],
      )!,
      motivosPrecoce: $FocosTable.$convertermotivosPrecoce.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}motivos_precoce'],
        )!,
      ),
      foraDoLimite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}fora_do_limite'],
      )!,
      criadoPor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}criado_por'],
      )!,
      primeiraDeteccaoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}primeira_deteccao_em'],
      )!,
      ultimaVisitaEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ultima_visita_em'],
      )!,
      ultimaAbundancia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ultima_abundancia'],
      ),
    );
  }

  @override
  $FocosTable createAlias(String alias) {
    return $FocosTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertermotivosPrecoce =
      const ListaTextoConverter();
}

class Foco extends DataClass implements Insertable<Foco> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? serverUpdatedAt;
  final bool deleted;
  final String syncStatus;
  final int version;
  final String id;
  final String especieId;
  final String? especieTexto;
  final String codigo;
  final double lat;
  final double lon;
  final double? precisaoM;
  final String origemCoordenada;
  final String? zona;
  final String? ambiente;
  final String status;
  final bool statusManual;
  final String? statusAlteradoPor;
  final DateTime? statusAlteradoEm;
  final bool deteccaoPrecoce;
  final List<String> motivosPrecoce;
  final bool foraDoLimite;
  final String criadoPor;
  final DateTime primeiraDeteccaoEm;
  final DateTime ultimaVisitaEm;
  final String? ultimaAbundancia;
  const Foco({
    required this.createdAt,
    required this.updatedAt,
    this.serverUpdatedAt,
    required this.deleted,
    required this.syncStatus,
    required this.version,
    required this.id,
    required this.especieId,
    this.especieTexto,
    required this.codigo,
    required this.lat,
    required this.lon,
    this.precisaoM,
    required this.origemCoordenada,
    this.zona,
    this.ambiente,
    required this.status,
    required this.statusManual,
    this.statusAlteradoPor,
    this.statusAlteradoEm,
    required this.deteccaoPrecoce,
    required this.motivosPrecoce,
    required this.foraDoLimite,
    required this.criadoPor,
    required this.primeiraDeteccaoEm,
    required this.ultimaVisitaEm,
    this.ultimaAbundancia,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    map['id'] = Variable<String>(id);
    map['especie_id'] = Variable<String>(especieId);
    if (!nullToAbsent || especieTexto != null) {
      map['especie_texto'] = Variable<String>(especieTexto);
    }
    map['codigo'] = Variable<String>(codigo);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    if (!nullToAbsent || precisaoM != null) {
      map['precisao_m'] = Variable<double>(precisaoM);
    }
    map['origem_coordenada'] = Variable<String>(origemCoordenada);
    if (!nullToAbsent || zona != null) {
      map['zona'] = Variable<String>(zona);
    }
    if (!nullToAbsent || ambiente != null) {
      map['ambiente'] = Variable<String>(ambiente);
    }
    map['status'] = Variable<String>(status);
    map['status_manual'] = Variable<bool>(statusManual);
    if (!nullToAbsent || statusAlteradoPor != null) {
      map['status_alterado_por'] = Variable<String>(statusAlteradoPor);
    }
    if (!nullToAbsent || statusAlteradoEm != null) {
      map['status_alterado_em'] = Variable<DateTime>(statusAlteradoEm);
    }
    map['deteccao_precoce'] = Variable<bool>(deteccaoPrecoce);
    {
      map['motivos_precoce'] = Variable<String>(
        $FocosTable.$convertermotivosPrecoce.toSql(motivosPrecoce),
      );
    }
    map['fora_do_limite'] = Variable<bool>(foraDoLimite);
    map['criado_por'] = Variable<String>(criadoPor);
    map['primeira_deteccao_em'] = Variable<DateTime>(primeiraDeteccaoEm);
    map['ultima_visita_em'] = Variable<DateTime>(ultimaVisitaEm);
    if (!nullToAbsent || ultimaAbundancia != null) {
      map['ultima_abundancia'] = Variable<String>(ultimaAbundancia);
    }
    return map;
  }

  FocosCompanion toCompanion(bool nullToAbsent) {
    return FocosCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      deleted: Value(deleted),
      syncStatus: Value(syncStatus),
      version: Value(version),
      id: Value(id),
      especieId: Value(especieId),
      especieTexto: especieTexto == null && nullToAbsent
          ? const Value.absent()
          : Value(especieTexto),
      codigo: Value(codigo),
      lat: Value(lat),
      lon: Value(lon),
      precisaoM: precisaoM == null && nullToAbsent
          ? const Value.absent()
          : Value(precisaoM),
      origemCoordenada: Value(origemCoordenada),
      zona: zona == null && nullToAbsent ? const Value.absent() : Value(zona),
      ambiente: ambiente == null && nullToAbsent
          ? const Value.absent()
          : Value(ambiente),
      status: Value(status),
      statusManual: Value(statusManual),
      statusAlteradoPor: statusAlteradoPor == null && nullToAbsent
          ? const Value.absent()
          : Value(statusAlteradoPor),
      statusAlteradoEm: statusAlteradoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(statusAlteradoEm),
      deteccaoPrecoce: Value(deteccaoPrecoce),
      motivosPrecoce: Value(motivosPrecoce),
      foraDoLimite: Value(foraDoLimite),
      criadoPor: Value(criadoPor),
      primeiraDeteccaoEm: Value(primeiraDeteccaoEm),
      ultimaVisitaEm: Value(ultimaVisitaEm),
      ultimaAbundancia: ultimaAbundancia == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimaAbundancia),
    );
  }

  factory Foco.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Foco(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
      id: serializer.fromJson<String>(json['id']),
      especieId: serializer.fromJson<String>(json['especieId']),
      especieTexto: serializer.fromJson<String?>(json['especieTexto']),
      codigo: serializer.fromJson<String>(json['codigo']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      precisaoM: serializer.fromJson<double?>(json['precisaoM']),
      origemCoordenada: serializer.fromJson<String>(json['origemCoordenada']),
      zona: serializer.fromJson<String?>(json['zona']),
      ambiente: serializer.fromJson<String?>(json['ambiente']),
      status: serializer.fromJson<String>(json['status']),
      statusManual: serializer.fromJson<bool>(json['statusManual']),
      statusAlteradoPor: serializer.fromJson<String?>(
        json['statusAlteradoPor'],
      ),
      statusAlteradoEm: serializer.fromJson<DateTime?>(
        json['statusAlteradoEm'],
      ),
      deteccaoPrecoce: serializer.fromJson<bool>(json['deteccaoPrecoce']),
      motivosPrecoce: serializer.fromJson<List<String>>(json['motivosPrecoce']),
      foraDoLimite: serializer.fromJson<bool>(json['foraDoLimite']),
      criadoPor: serializer.fromJson<String>(json['criadoPor']),
      primeiraDeteccaoEm: serializer.fromJson<DateTime>(
        json['primeiraDeteccaoEm'],
      ),
      ultimaVisitaEm: serializer.fromJson<DateTime>(json['ultimaVisitaEm']),
      ultimaAbundancia: serializer.fromJson<String?>(json['ultimaAbundancia']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
      'id': serializer.toJson<String>(id),
      'especieId': serializer.toJson<String>(especieId),
      'especieTexto': serializer.toJson<String?>(especieTexto),
      'codigo': serializer.toJson<String>(codigo),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'precisaoM': serializer.toJson<double?>(precisaoM),
      'origemCoordenada': serializer.toJson<String>(origemCoordenada),
      'zona': serializer.toJson<String?>(zona),
      'ambiente': serializer.toJson<String?>(ambiente),
      'status': serializer.toJson<String>(status),
      'statusManual': serializer.toJson<bool>(statusManual),
      'statusAlteradoPor': serializer.toJson<String?>(statusAlteradoPor),
      'statusAlteradoEm': serializer.toJson<DateTime?>(statusAlteradoEm),
      'deteccaoPrecoce': serializer.toJson<bool>(deteccaoPrecoce),
      'motivosPrecoce': serializer.toJson<List<String>>(motivosPrecoce),
      'foraDoLimite': serializer.toJson<bool>(foraDoLimite),
      'criadoPor': serializer.toJson<String>(criadoPor),
      'primeiraDeteccaoEm': serializer.toJson<DateTime>(primeiraDeteccaoEm),
      'ultimaVisitaEm': serializer.toJson<DateTime>(ultimaVisitaEm),
      'ultimaAbundancia': serializer.toJson<String?>(ultimaAbundancia),
    };
  }

  Foco copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    bool? deleted,
    String? syncStatus,
    int? version,
    String? id,
    String? especieId,
    Value<String?> especieTexto = const Value.absent(),
    String? codigo,
    double? lat,
    double? lon,
    Value<double?> precisaoM = const Value.absent(),
    String? origemCoordenada,
    Value<String?> zona = const Value.absent(),
    Value<String?> ambiente = const Value.absent(),
    String? status,
    bool? statusManual,
    Value<String?> statusAlteradoPor = const Value.absent(),
    Value<DateTime?> statusAlteradoEm = const Value.absent(),
    bool? deteccaoPrecoce,
    List<String>? motivosPrecoce,
    bool? foraDoLimite,
    String? criadoPor,
    DateTime? primeiraDeteccaoEm,
    DateTime? ultimaVisitaEm,
    Value<String?> ultimaAbundancia = const Value.absent(),
  }) => Foco(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    deleted: deleted ?? this.deleted,
    syncStatus: syncStatus ?? this.syncStatus,
    version: version ?? this.version,
    id: id ?? this.id,
    especieId: especieId ?? this.especieId,
    especieTexto: especieTexto.present ? especieTexto.value : this.especieTexto,
    codigo: codigo ?? this.codigo,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    precisaoM: precisaoM.present ? precisaoM.value : this.precisaoM,
    origemCoordenada: origemCoordenada ?? this.origemCoordenada,
    zona: zona.present ? zona.value : this.zona,
    ambiente: ambiente.present ? ambiente.value : this.ambiente,
    status: status ?? this.status,
    statusManual: statusManual ?? this.statusManual,
    statusAlteradoPor: statusAlteradoPor.present
        ? statusAlteradoPor.value
        : this.statusAlteradoPor,
    statusAlteradoEm: statusAlteradoEm.present
        ? statusAlteradoEm.value
        : this.statusAlteradoEm,
    deteccaoPrecoce: deteccaoPrecoce ?? this.deteccaoPrecoce,
    motivosPrecoce: motivosPrecoce ?? this.motivosPrecoce,
    foraDoLimite: foraDoLimite ?? this.foraDoLimite,
    criadoPor: criadoPor ?? this.criadoPor,
    primeiraDeteccaoEm: primeiraDeteccaoEm ?? this.primeiraDeteccaoEm,
    ultimaVisitaEm: ultimaVisitaEm ?? this.ultimaVisitaEm,
    ultimaAbundancia: ultimaAbundancia.present
        ? ultimaAbundancia.value
        : this.ultimaAbundancia,
  );
  Foco copyWithCompanion(FocosCompanion data) {
    return Foco(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
      id: data.id.present ? data.id.value : this.id,
      especieId: data.especieId.present ? data.especieId.value : this.especieId,
      especieTexto: data.especieTexto.present
          ? data.especieTexto.value
          : this.especieTexto,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      precisaoM: data.precisaoM.present ? data.precisaoM.value : this.precisaoM,
      origemCoordenada: data.origemCoordenada.present
          ? data.origemCoordenada.value
          : this.origemCoordenada,
      zona: data.zona.present ? data.zona.value : this.zona,
      ambiente: data.ambiente.present ? data.ambiente.value : this.ambiente,
      status: data.status.present ? data.status.value : this.status,
      statusManual: data.statusManual.present
          ? data.statusManual.value
          : this.statusManual,
      statusAlteradoPor: data.statusAlteradoPor.present
          ? data.statusAlteradoPor.value
          : this.statusAlteradoPor,
      statusAlteradoEm: data.statusAlteradoEm.present
          ? data.statusAlteradoEm.value
          : this.statusAlteradoEm,
      deteccaoPrecoce: data.deteccaoPrecoce.present
          ? data.deteccaoPrecoce.value
          : this.deteccaoPrecoce,
      motivosPrecoce: data.motivosPrecoce.present
          ? data.motivosPrecoce.value
          : this.motivosPrecoce,
      foraDoLimite: data.foraDoLimite.present
          ? data.foraDoLimite.value
          : this.foraDoLimite,
      criadoPor: data.criadoPor.present ? data.criadoPor.value : this.criadoPor,
      primeiraDeteccaoEm: data.primeiraDeteccaoEm.present
          ? data.primeiraDeteccaoEm.value
          : this.primeiraDeteccaoEm,
      ultimaVisitaEm: data.ultimaVisitaEm.present
          ? data.ultimaVisitaEm.value
          : this.ultimaVisitaEm,
      ultimaAbundancia: data.ultimaAbundancia.present
          ? data.ultimaAbundancia.value
          : this.ultimaAbundancia,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Foco(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('especieId: $especieId, ')
          ..write('especieTexto: $especieTexto, ')
          ..write('codigo: $codigo, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('precisaoM: $precisaoM, ')
          ..write('origemCoordenada: $origemCoordenada, ')
          ..write('zona: $zona, ')
          ..write('ambiente: $ambiente, ')
          ..write('status: $status, ')
          ..write('statusManual: $statusManual, ')
          ..write('statusAlteradoPor: $statusAlteradoPor, ')
          ..write('statusAlteradoEm: $statusAlteradoEm, ')
          ..write('deteccaoPrecoce: $deteccaoPrecoce, ')
          ..write('motivosPrecoce: $motivosPrecoce, ')
          ..write('foraDoLimite: $foraDoLimite, ')
          ..write('criadoPor: $criadoPor, ')
          ..write('primeiraDeteccaoEm: $primeiraDeteccaoEm, ')
          ..write('ultimaVisitaEm: $ultimaVisitaEm, ')
          ..write('ultimaAbundancia: $ultimaAbundancia')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    especieId,
    especieTexto,
    codigo,
    lat,
    lon,
    precisaoM,
    origemCoordenada,
    zona,
    ambiente,
    status,
    statusManual,
    statusAlteradoPor,
    statusAlteradoEm,
    deteccaoPrecoce,
    motivosPrecoce,
    foraDoLimite,
    criadoPor,
    primeiraDeteccaoEm,
    ultimaVisitaEm,
    ultimaAbundancia,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Foco &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deleted == this.deleted &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version &&
          other.id == this.id &&
          other.especieId == this.especieId &&
          other.especieTexto == this.especieTexto &&
          other.codigo == this.codigo &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.precisaoM == this.precisaoM &&
          other.origemCoordenada == this.origemCoordenada &&
          other.zona == this.zona &&
          other.ambiente == this.ambiente &&
          other.status == this.status &&
          other.statusManual == this.statusManual &&
          other.statusAlteradoPor == this.statusAlteradoPor &&
          other.statusAlteradoEm == this.statusAlteradoEm &&
          other.deteccaoPrecoce == this.deteccaoPrecoce &&
          other.motivosPrecoce == this.motivosPrecoce &&
          other.foraDoLimite == this.foraDoLimite &&
          other.criadoPor == this.criadoPor &&
          other.primeiraDeteccaoEm == this.primeiraDeteccaoEm &&
          other.ultimaVisitaEm == this.ultimaVisitaEm &&
          other.ultimaAbundancia == this.ultimaAbundancia);
}

class FocosCompanion extends UpdateCompanion<Foco> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<bool> deleted;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<String> id;
  final Value<String> especieId;
  final Value<String?> especieTexto;
  final Value<String> codigo;
  final Value<double> lat;
  final Value<double> lon;
  final Value<double?> precisaoM;
  final Value<String> origemCoordenada;
  final Value<String?> zona;
  final Value<String?> ambiente;
  final Value<String> status;
  final Value<bool> statusManual;
  final Value<String?> statusAlteradoPor;
  final Value<DateTime?> statusAlteradoEm;
  final Value<bool> deteccaoPrecoce;
  final Value<List<String>> motivosPrecoce;
  final Value<bool> foraDoLimite;
  final Value<String> criadoPor;
  final Value<DateTime> primeiraDeteccaoEm;
  final Value<DateTime> ultimaVisitaEm;
  final Value<String?> ultimaAbundancia;
  final Value<int> rowid;
  const FocosCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.id = const Value.absent(),
    this.especieId = const Value.absent(),
    this.especieTexto = const Value.absent(),
    this.codigo = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.precisaoM = const Value.absent(),
    this.origemCoordenada = const Value.absent(),
    this.zona = const Value.absent(),
    this.ambiente = const Value.absent(),
    this.status = const Value.absent(),
    this.statusManual = const Value.absent(),
    this.statusAlteradoPor = const Value.absent(),
    this.statusAlteradoEm = const Value.absent(),
    this.deteccaoPrecoce = const Value.absent(),
    this.motivosPrecoce = const Value.absent(),
    this.foraDoLimite = const Value.absent(),
    this.criadoPor = const Value.absent(),
    this.primeiraDeteccaoEm = const Value.absent(),
    this.ultimaVisitaEm = const Value.absent(),
    this.ultimaAbundancia = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocosCompanion.insert({
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    required String id,
    required String especieId,
    this.especieTexto = const Value.absent(),
    required String codigo,
    required double lat,
    required double lon,
    this.precisaoM = const Value.absent(),
    required String origemCoordenada,
    this.zona = const Value.absent(),
    this.ambiente = const Value.absent(),
    required String status,
    this.statusManual = const Value.absent(),
    this.statusAlteradoPor = const Value.absent(),
    this.statusAlteradoEm = const Value.absent(),
    this.deteccaoPrecoce = const Value.absent(),
    this.motivosPrecoce = const Value.absent(),
    this.foraDoLimite = const Value.absent(),
    required String criadoPor,
    required DateTime primeiraDeteccaoEm,
    required DateTime ultimaVisitaEm,
    this.ultimaAbundancia = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       especieId = Value(especieId),
       codigo = Value(codigo),
       lat = Value(lat),
       lon = Value(lon),
       origemCoordenada = Value(origemCoordenada),
       status = Value(status),
       criadoPor = Value(criadoPor),
       primeiraDeteccaoEm = Value(primeiraDeteccaoEm),
       ultimaVisitaEm = Value(ultimaVisitaEm);
  static Insertable<Foco> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<bool>? deleted,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<String>? id,
    Expression<String>? especieId,
    Expression<String>? especieTexto,
    Expression<String>? codigo,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<double>? precisaoM,
    Expression<String>? origemCoordenada,
    Expression<String>? zona,
    Expression<String>? ambiente,
    Expression<String>? status,
    Expression<bool>? statusManual,
    Expression<String>? statusAlteradoPor,
    Expression<DateTime>? statusAlteradoEm,
    Expression<bool>? deteccaoPrecoce,
    Expression<String>? motivosPrecoce,
    Expression<bool>? foraDoLimite,
    Expression<String>? criadoPor,
    Expression<DateTime>? primeiraDeteccaoEm,
    Expression<DateTime>? ultimaVisitaEm,
    Expression<String>? ultimaAbundancia,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deleted != null) 'deleted': deleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (id != null) 'id': id,
      if (especieId != null) 'especie_id': especieId,
      if (especieTexto != null) 'especie_texto': especieTexto,
      if (codigo != null) 'codigo': codigo,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (precisaoM != null) 'precisao_m': precisaoM,
      if (origemCoordenada != null) 'origem_coordenada': origemCoordenada,
      if (zona != null) 'zona': zona,
      if (ambiente != null) 'ambiente': ambiente,
      if (status != null) 'status': status,
      if (statusManual != null) 'status_manual': statusManual,
      if (statusAlteradoPor != null) 'status_alterado_por': statusAlteradoPor,
      if (statusAlteradoEm != null) 'status_alterado_em': statusAlteradoEm,
      if (deteccaoPrecoce != null) 'deteccao_precoce': deteccaoPrecoce,
      if (motivosPrecoce != null) 'motivos_precoce': motivosPrecoce,
      if (foraDoLimite != null) 'fora_do_limite': foraDoLimite,
      if (criadoPor != null) 'criado_por': criadoPor,
      if (primeiraDeteccaoEm != null)
        'primeira_deteccao_em': primeiraDeteccaoEm,
      if (ultimaVisitaEm != null) 'ultima_visita_em': ultimaVisitaEm,
      if (ultimaAbundancia != null) 'ultima_abundancia': ultimaAbundancia,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocosCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? serverUpdatedAt,
    Value<bool>? deleted,
    Value<String>? syncStatus,
    Value<int>? version,
    Value<String>? id,
    Value<String>? especieId,
    Value<String?>? especieTexto,
    Value<String>? codigo,
    Value<double>? lat,
    Value<double>? lon,
    Value<double?>? precisaoM,
    Value<String>? origemCoordenada,
    Value<String?>? zona,
    Value<String?>? ambiente,
    Value<String>? status,
    Value<bool>? statusManual,
    Value<String?>? statusAlteradoPor,
    Value<DateTime?>? statusAlteradoEm,
    Value<bool>? deteccaoPrecoce,
    Value<List<String>>? motivosPrecoce,
    Value<bool>? foraDoLimite,
    Value<String>? criadoPor,
    Value<DateTime>? primeiraDeteccaoEm,
    Value<DateTime>? ultimaVisitaEm,
    Value<String?>? ultimaAbundancia,
    Value<int>? rowid,
  }) {
    return FocosCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deleted: deleted ?? this.deleted,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      id: id ?? this.id,
      especieId: especieId ?? this.especieId,
      especieTexto: especieTexto ?? this.especieTexto,
      codigo: codigo ?? this.codigo,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      precisaoM: precisaoM ?? this.precisaoM,
      origemCoordenada: origemCoordenada ?? this.origemCoordenada,
      zona: zona ?? this.zona,
      ambiente: ambiente ?? this.ambiente,
      status: status ?? this.status,
      statusManual: statusManual ?? this.statusManual,
      statusAlteradoPor: statusAlteradoPor ?? this.statusAlteradoPor,
      statusAlteradoEm: statusAlteradoEm ?? this.statusAlteradoEm,
      deteccaoPrecoce: deteccaoPrecoce ?? this.deteccaoPrecoce,
      motivosPrecoce: motivosPrecoce ?? this.motivosPrecoce,
      foraDoLimite: foraDoLimite ?? this.foraDoLimite,
      criadoPor: criadoPor ?? this.criadoPor,
      primeiraDeteccaoEm: primeiraDeteccaoEm ?? this.primeiraDeteccaoEm,
      ultimaVisitaEm: ultimaVisitaEm ?? this.ultimaVisitaEm,
      ultimaAbundancia: ultimaAbundancia ?? this.ultimaAbundancia,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (especieId.present) {
      map['especie_id'] = Variable<String>(especieId.value);
    }
    if (especieTexto.present) {
      map['especie_texto'] = Variable<String>(especieTexto.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (precisaoM.present) {
      map['precisao_m'] = Variable<double>(precisaoM.value);
    }
    if (origemCoordenada.present) {
      map['origem_coordenada'] = Variable<String>(origemCoordenada.value);
    }
    if (zona.present) {
      map['zona'] = Variable<String>(zona.value);
    }
    if (ambiente.present) {
      map['ambiente'] = Variable<String>(ambiente.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (statusManual.present) {
      map['status_manual'] = Variable<bool>(statusManual.value);
    }
    if (statusAlteradoPor.present) {
      map['status_alterado_por'] = Variable<String>(statusAlteradoPor.value);
    }
    if (statusAlteradoEm.present) {
      map['status_alterado_em'] = Variable<DateTime>(statusAlteradoEm.value);
    }
    if (deteccaoPrecoce.present) {
      map['deteccao_precoce'] = Variable<bool>(deteccaoPrecoce.value);
    }
    if (motivosPrecoce.present) {
      map['motivos_precoce'] = Variable<String>(
        $FocosTable.$convertermotivosPrecoce.toSql(motivosPrecoce.value),
      );
    }
    if (foraDoLimite.present) {
      map['fora_do_limite'] = Variable<bool>(foraDoLimite.value);
    }
    if (criadoPor.present) {
      map['criado_por'] = Variable<String>(criadoPor.value);
    }
    if (primeiraDeteccaoEm.present) {
      map['primeira_deteccao_em'] = Variable<DateTime>(
        primeiraDeteccaoEm.value,
      );
    }
    if (ultimaVisitaEm.present) {
      map['ultima_visita_em'] = Variable<DateTime>(ultimaVisitaEm.value);
    }
    if (ultimaAbundancia.present) {
      map['ultima_abundancia'] = Variable<String>(ultimaAbundancia.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocosCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('especieId: $especieId, ')
          ..write('especieTexto: $especieTexto, ')
          ..write('codigo: $codigo, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('precisaoM: $precisaoM, ')
          ..write('origemCoordenada: $origemCoordenada, ')
          ..write('zona: $zona, ')
          ..write('ambiente: $ambiente, ')
          ..write('status: $status, ')
          ..write('statusManual: $statusManual, ')
          ..write('statusAlteradoPor: $statusAlteradoPor, ')
          ..write('statusAlteradoEm: $statusAlteradoEm, ')
          ..write('deteccaoPrecoce: $deteccaoPrecoce, ')
          ..write('motivosPrecoce: $motivosPrecoce, ')
          ..write('foraDoLimite: $foraDoLimite, ')
          ..write('criadoPor: $criadoPor, ')
          ..write('primeiraDeteccaoEm: $primeiraDeteccaoEm, ')
          ..write('ultimaVisitaEm: $ultimaVisitaEm, ')
          ..write('ultimaAbundancia: $ultimaAbundancia, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ObservacoesTable extends Observacoes
    with TableInfo<$ObservacoesTable, Observacao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObservacoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendente'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focoIdMeta = const VerificationMeta('focoId');
  @override
  late final GeneratedColumn<String> focoId = GeneratedColumn<String>(
    'foco_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES focos (id)',
    ),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessaoIdMeta = const VerificationMeta(
    'sessaoId',
  );
  @override
  late final GeneratedColumn<String> sessaoId = GeneratedColumn<String>(
    'sessao_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dataHoraMeta = const VerificationMeta(
    'dataHora',
  );
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
    'data_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precisaoMMeta = const VerificationMeta(
    'precisaoM',
  );
  @override
  late final GeneratedColumn<double> precisaoM = GeneratedColumn<double>(
    'precisao_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altitudeMMeta = const VerificationMeta(
    'altitudeM',
  );
  @override
  late final GeneratedColumn<double> altitudeM = GeneratedColumn<double>(
    'altitude_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _presencaMeta = const VerificationMeta(
    'presenca',
  );
  @override
  late final GeneratedColumn<String> presenca = GeneratedColumn<String>(
    'presenca',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultadoMeta = const VerificationMeta(
    'resultado',
  );
  @override
  late final GeneratedColumn<String> resultado = GeneratedColumn<String>(
    'resultado',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantificacaoTipoMeta = const VerificationMeta(
    'quantificacaoTipo',
  );
  @override
  late final GeneratedColumn<String> quantificacaoTipo =
      GeneratedColumn<String>(
        'quantificacao_tipo',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nIndividuosMeta = const VerificationMeta(
    'nIndividuos',
  );
  @override
  late final GeneratedColumn<int> nIndividuos = GeneratedColumn<int>(
    'n_individuos',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classeAbundanciaMeta = const VerificationMeta(
    'classeAbundancia',
  );
  @override
  late final GeneratedColumn<String> classeAbundancia = GeneratedColumn<String>(
    'classe_abundancia',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaM2Meta = const VerificationMeta('areaM2');
  @override
  late final GeneratedColumn<double> areaM2 = GeneratedColumn<double>(
    'area_m2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coberturaPctMeta = const VerificationMeta(
    'coberturaPct',
  );
  @override
  late final GeneratedColumn<int> coberturaPct = GeneratedColumn<int>(
    'cobertura_pct',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estagioMeta = const VerificationMeta(
    'estagio',
  );
  @override
  late final GeneratedColumn<String> estagio = GeneratedColumn<String>(
    'estagio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ambienteMeta = const VerificationMeta(
    'ambiente',
  );
  @override
  late final GeneratedColumn<String> ambiente = GeneratedColumn<String>(
    'ambiente',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textoMeta = const VerificationMeta('texto');
  @override
  late final GeneratedColumn<String> texto = GeneratedColumn<String>(
    'texto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ditadoMeta = const VerificationMeta('ditado');
  @override
  late final GeneratedColumn<bool> ditado = GeneratedColumn<bool>(
    'ditado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ditado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dispositivoMeta = const VerificationMeta(
    'dispositivo',
  );
  @override
  late final GeneratedColumn<String> dispositivo = GeneratedColumn<String>(
    'dispositivo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versaoAppMeta = const VerificationMeta(
    'versaoApp',
  );
  @override
  late final GeneratedColumn<String> versaoApp = GeneratedColumn<String>(
    'versao_app',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    focoId,
    tipo,
    usuarioId,
    sessaoId,
    dataHora,
    lat,
    lon,
    precisaoM,
    altitudeM,
    presenca,
    resultado,
    quantificacaoTipo,
    nIndividuos,
    classeAbundancia,
    areaM2,
    coberturaPct,
    estagio,
    ambiente,
    texto,
    ditado,
    dispositivo,
    versaoApp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'observacoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Observacao> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('foco_id')) {
      context.handle(
        _focoIdMeta,
        focoId.isAcceptableOrUnknown(data['foco_id']!, _focoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_focoIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('sessao_id')) {
      context.handle(
        _sessaoIdMeta,
        sessaoId.isAcceptableOrUnknown(data['sessao_id']!, _sessaoIdMeta),
      );
    }
    if (data.containsKey('data_hora')) {
      context.handle(
        _dataHoraMeta,
        dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta),
      );
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('precisao_m')) {
      context.handle(
        _precisaoMMeta,
        precisaoM.isAcceptableOrUnknown(data['precisao_m']!, _precisaoMMeta),
      );
    }
    if (data.containsKey('altitude_m')) {
      context.handle(
        _altitudeMMeta,
        altitudeM.isAcceptableOrUnknown(data['altitude_m']!, _altitudeMMeta),
      );
    }
    if (data.containsKey('presenca')) {
      context.handle(
        _presencaMeta,
        presenca.isAcceptableOrUnknown(data['presenca']!, _presencaMeta),
      );
    } else if (isInserting) {
      context.missing(_presencaMeta);
    }
    if (data.containsKey('resultado')) {
      context.handle(
        _resultadoMeta,
        resultado.isAcceptableOrUnknown(data['resultado']!, _resultadoMeta),
      );
    }
    if (data.containsKey('quantificacao_tipo')) {
      context.handle(
        _quantificacaoTipoMeta,
        quantificacaoTipo.isAcceptableOrUnknown(
          data['quantificacao_tipo']!,
          _quantificacaoTipoMeta,
        ),
      );
    }
    if (data.containsKey('n_individuos')) {
      context.handle(
        _nIndividuosMeta,
        nIndividuos.isAcceptableOrUnknown(
          data['n_individuos']!,
          _nIndividuosMeta,
        ),
      );
    }
    if (data.containsKey('classe_abundancia')) {
      context.handle(
        _classeAbundanciaMeta,
        classeAbundancia.isAcceptableOrUnknown(
          data['classe_abundancia']!,
          _classeAbundanciaMeta,
        ),
      );
    }
    if (data.containsKey('area_m2')) {
      context.handle(
        _areaM2Meta,
        areaM2.isAcceptableOrUnknown(data['area_m2']!, _areaM2Meta),
      );
    }
    if (data.containsKey('cobertura_pct')) {
      context.handle(
        _coberturaPctMeta,
        coberturaPct.isAcceptableOrUnknown(
          data['cobertura_pct']!,
          _coberturaPctMeta,
        ),
      );
    }
    if (data.containsKey('estagio')) {
      context.handle(
        _estagioMeta,
        estagio.isAcceptableOrUnknown(data['estagio']!, _estagioMeta),
      );
    }
    if (data.containsKey('ambiente')) {
      context.handle(
        _ambienteMeta,
        ambiente.isAcceptableOrUnknown(data['ambiente']!, _ambienteMeta),
      );
    }
    if (data.containsKey('texto')) {
      context.handle(
        _textoMeta,
        texto.isAcceptableOrUnknown(data['texto']!, _textoMeta),
      );
    }
    if (data.containsKey('ditado')) {
      context.handle(
        _ditadoMeta,
        ditado.isAcceptableOrUnknown(data['ditado']!, _ditadoMeta),
      );
    }
    if (data.containsKey('dispositivo')) {
      context.handle(
        _dispositivoMeta,
        dispositivo.isAcceptableOrUnknown(
          data['dispositivo']!,
          _dispositivoMeta,
        ),
      );
    }
    if (data.containsKey('versao_app')) {
      context.handle(
        _versaoAppMeta,
        versaoApp.isAcceptableOrUnknown(data['versao_app']!, _versaoAppMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Observacao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Observacao(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      focoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foco_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      sessaoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sessao_id'],
      ),
      dataHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      precisaoM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precisao_m'],
      ),
      altitudeM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude_m'],
      ),
      presenca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}presenca'],
      )!,
      resultado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resultado'],
      ),
      quantificacaoTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantificacao_tipo'],
      ),
      nIndividuos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}n_individuos'],
      ),
      classeAbundancia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classe_abundancia'],
      ),
      areaM2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_m2'],
      ),
      coberturaPct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cobertura_pct'],
      ),
      estagio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estagio'],
      ),
      ambiente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ambiente'],
      ),
      texto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}texto'],
      ),
      ditado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ditado'],
      )!,
      dispositivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dispositivo'],
      ),
      versaoApp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}versao_app'],
      ),
    );
  }

  @override
  $ObservacoesTable createAlias(String alias) {
    return $ObservacoesTable(attachedDatabase, alias);
  }
}

class Observacao extends DataClass implements Insertable<Observacao> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? serverUpdatedAt;
  final bool deleted;
  final String syncStatus;
  final int version;
  final String id;
  final String focoId;
  final String tipo;
  final String usuarioId;
  final String? sessaoId;
  final DateTime dataHora;
  final double lat;
  final double lon;
  final double? precisaoM;
  final double? altitudeM;
  final String presenca;
  final String? resultado;
  final String? quantificacaoTipo;
  final int? nIndividuos;
  final String? classeAbundancia;
  final double? areaM2;
  final int? coberturaPct;
  final String? estagio;
  final String? ambiente;
  final String? texto;
  final bool ditado;
  final String? dispositivo;
  final String? versaoApp;
  const Observacao({
    required this.createdAt,
    required this.updatedAt,
    this.serverUpdatedAt,
    required this.deleted,
    required this.syncStatus,
    required this.version,
    required this.id,
    required this.focoId,
    required this.tipo,
    required this.usuarioId,
    this.sessaoId,
    required this.dataHora,
    required this.lat,
    required this.lon,
    this.precisaoM,
    this.altitudeM,
    required this.presenca,
    this.resultado,
    this.quantificacaoTipo,
    this.nIndividuos,
    this.classeAbundancia,
    this.areaM2,
    this.coberturaPct,
    this.estagio,
    this.ambiente,
    this.texto,
    required this.ditado,
    this.dispositivo,
    this.versaoApp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    map['id'] = Variable<String>(id);
    map['foco_id'] = Variable<String>(focoId);
    map['tipo'] = Variable<String>(tipo);
    map['usuario_id'] = Variable<String>(usuarioId);
    if (!nullToAbsent || sessaoId != null) {
      map['sessao_id'] = Variable<String>(sessaoId);
    }
    map['data_hora'] = Variable<DateTime>(dataHora);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    if (!nullToAbsent || precisaoM != null) {
      map['precisao_m'] = Variable<double>(precisaoM);
    }
    if (!nullToAbsent || altitudeM != null) {
      map['altitude_m'] = Variable<double>(altitudeM);
    }
    map['presenca'] = Variable<String>(presenca);
    if (!nullToAbsent || resultado != null) {
      map['resultado'] = Variable<String>(resultado);
    }
    if (!nullToAbsent || quantificacaoTipo != null) {
      map['quantificacao_tipo'] = Variable<String>(quantificacaoTipo);
    }
    if (!nullToAbsent || nIndividuos != null) {
      map['n_individuos'] = Variable<int>(nIndividuos);
    }
    if (!nullToAbsent || classeAbundancia != null) {
      map['classe_abundancia'] = Variable<String>(classeAbundancia);
    }
    if (!nullToAbsent || areaM2 != null) {
      map['area_m2'] = Variable<double>(areaM2);
    }
    if (!nullToAbsent || coberturaPct != null) {
      map['cobertura_pct'] = Variable<int>(coberturaPct);
    }
    if (!nullToAbsent || estagio != null) {
      map['estagio'] = Variable<String>(estagio);
    }
    if (!nullToAbsent || ambiente != null) {
      map['ambiente'] = Variable<String>(ambiente);
    }
    if (!nullToAbsent || texto != null) {
      map['texto'] = Variable<String>(texto);
    }
    map['ditado'] = Variable<bool>(ditado);
    if (!nullToAbsent || dispositivo != null) {
      map['dispositivo'] = Variable<String>(dispositivo);
    }
    if (!nullToAbsent || versaoApp != null) {
      map['versao_app'] = Variable<String>(versaoApp);
    }
    return map;
  }

  ObservacoesCompanion toCompanion(bool nullToAbsent) {
    return ObservacoesCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      deleted: Value(deleted),
      syncStatus: Value(syncStatus),
      version: Value(version),
      id: Value(id),
      focoId: Value(focoId),
      tipo: Value(tipo),
      usuarioId: Value(usuarioId),
      sessaoId: sessaoId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessaoId),
      dataHora: Value(dataHora),
      lat: Value(lat),
      lon: Value(lon),
      precisaoM: precisaoM == null && nullToAbsent
          ? const Value.absent()
          : Value(precisaoM),
      altitudeM: altitudeM == null && nullToAbsent
          ? const Value.absent()
          : Value(altitudeM),
      presenca: Value(presenca),
      resultado: resultado == null && nullToAbsent
          ? const Value.absent()
          : Value(resultado),
      quantificacaoTipo: quantificacaoTipo == null && nullToAbsent
          ? const Value.absent()
          : Value(quantificacaoTipo),
      nIndividuos: nIndividuos == null && nullToAbsent
          ? const Value.absent()
          : Value(nIndividuos),
      classeAbundancia: classeAbundancia == null && nullToAbsent
          ? const Value.absent()
          : Value(classeAbundancia),
      areaM2: areaM2 == null && nullToAbsent
          ? const Value.absent()
          : Value(areaM2),
      coberturaPct: coberturaPct == null && nullToAbsent
          ? const Value.absent()
          : Value(coberturaPct),
      estagio: estagio == null && nullToAbsent
          ? const Value.absent()
          : Value(estagio),
      ambiente: ambiente == null && nullToAbsent
          ? const Value.absent()
          : Value(ambiente),
      texto: texto == null && nullToAbsent
          ? const Value.absent()
          : Value(texto),
      ditado: Value(ditado),
      dispositivo: dispositivo == null && nullToAbsent
          ? const Value.absent()
          : Value(dispositivo),
      versaoApp: versaoApp == null && nullToAbsent
          ? const Value.absent()
          : Value(versaoApp),
    );
  }

  factory Observacao.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Observacao(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
      id: serializer.fromJson<String>(json['id']),
      focoId: serializer.fromJson<String>(json['focoId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      sessaoId: serializer.fromJson<String?>(json['sessaoId']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      precisaoM: serializer.fromJson<double?>(json['precisaoM']),
      altitudeM: serializer.fromJson<double?>(json['altitudeM']),
      presenca: serializer.fromJson<String>(json['presenca']),
      resultado: serializer.fromJson<String?>(json['resultado']),
      quantificacaoTipo: serializer.fromJson<String?>(
        json['quantificacaoTipo'],
      ),
      nIndividuos: serializer.fromJson<int?>(json['nIndividuos']),
      classeAbundancia: serializer.fromJson<String?>(json['classeAbundancia']),
      areaM2: serializer.fromJson<double?>(json['areaM2']),
      coberturaPct: serializer.fromJson<int?>(json['coberturaPct']),
      estagio: serializer.fromJson<String?>(json['estagio']),
      ambiente: serializer.fromJson<String?>(json['ambiente']),
      texto: serializer.fromJson<String?>(json['texto']),
      ditado: serializer.fromJson<bool>(json['ditado']),
      dispositivo: serializer.fromJson<String?>(json['dispositivo']),
      versaoApp: serializer.fromJson<String?>(json['versaoApp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
      'id': serializer.toJson<String>(id),
      'focoId': serializer.toJson<String>(focoId),
      'tipo': serializer.toJson<String>(tipo),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'sessaoId': serializer.toJson<String?>(sessaoId),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'precisaoM': serializer.toJson<double?>(precisaoM),
      'altitudeM': serializer.toJson<double?>(altitudeM),
      'presenca': serializer.toJson<String>(presenca),
      'resultado': serializer.toJson<String?>(resultado),
      'quantificacaoTipo': serializer.toJson<String?>(quantificacaoTipo),
      'nIndividuos': serializer.toJson<int?>(nIndividuos),
      'classeAbundancia': serializer.toJson<String?>(classeAbundancia),
      'areaM2': serializer.toJson<double?>(areaM2),
      'coberturaPct': serializer.toJson<int?>(coberturaPct),
      'estagio': serializer.toJson<String?>(estagio),
      'ambiente': serializer.toJson<String?>(ambiente),
      'texto': serializer.toJson<String?>(texto),
      'ditado': serializer.toJson<bool>(ditado),
      'dispositivo': serializer.toJson<String?>(dispositivo),
      'versaoApp': serializer.toJson<String?>(versaoApp),
    };
  }

  Observacao copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    bool? deleted,
    String? syncStatus,
    int? version,
    String? id,
    String? focoId,
    String? tipo,
    String? usuarioId,
    Value<String?> sessaoId = const Value.absent(),
    DateTime? dataHora,
    double? lat,
    double? lon,
    Value<double?> precisaoM = const Value.absent(),
    Value<double?> altitudeM = const Value.absent(),
    String? presenca,
    Value<String?> resultado = const Value.absent(),
    Value<String?> quantificacaoTipo = const Value.absent(),
    Value<int?> nIndividuos = const Value.absent(),
    Value<String?> classeAbundancia = const Value.absent(),
    Value<double?> areaM2 = const Value.absent(),
    Value<int?> coberturaPct = const Value.absent(),
    Value<String?> estagio = const Value.absent(),
    Value<String?> ambiente = const Value.absent(),
    Value<String?> texto = const Value.absent(),
    bool? ditado,
    Value<String?> dispositivo = const Value.absent(),
    Value<String?> versaoApp = const Value.absent(),
  }) => Observacao(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    deleted: deleted ?? this.deleted,
    syncStatus: syncStatus ?? this.syncStatus,
    version: version ?? this.version,
    id: id ?? this.id,
    focoId: focoId ?? this.focoId,
    tipo: tipo ?? this.tipo,
    usuarioId: usuarioId ?? this.usuarioId,
    sessaoId: sessaoId.present ? sessaoId.value : this.sessaoId,
    dataHora: dataHora ?? this.dataHora,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    precisaoM: precisaoM.present ? precisaoM.value : this.precisaoM,
    altitudeM: altitudeM.present ? altitudeM.value : this.altitudeM,
    presenca: presenca ?? this.presenca,
    resultado: resultado.present ? resultado.value : this.resultado,
    quantificacaoTipo: quantificacaoTipo.present
        ? quantificacaoTipo.value
        : this.quantificacaoTipo,
    nIndividuos: nIndividuos.present ? nIndividuos.value : this.nIndividuos,
    classeAbundancia: classeAbundancia.present
        ? classeAbundancia.value
        : this.classeAbundancia,
    areaM2: areaM2.present ? areaM2.value : this.areaM2,
    coberturaPct: coberturaPct.present ? coberturaPct.value : this.coberturaPct,
    estagio: estagio.present ? estagio.value : this.estagio,
    ambiente: ambiente.present ? ambiente.value : this.ambiente,
    texto: texto.present ? texto.value : this.texto,
    ditado: ditado ?? this.ditado,
    dispositivo: dispositivo.present ? dispositivo.value : this.dispositivo,
    versaoApp: versaoApp.present ? versaoApp.value : this.versaoApp,
  );
  Observacao copyWithCompanion(ObservacoesCompanion data) {
    return Observacao(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
      id: data.id.present ? data.id.value : this.id,
      focoId: data.focoId.present ? data.focoId.value : this.focoId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      sessaoId: data.sessaoId.present ? data.sessaoId.value : this.sessaoId,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      precisaoM: data.precisaoM.present ? data.precisaoM.value : this.precisaoM,
      altitudeM: data.altitudeM.present ? data.altitudeM.value : this.altitudeM,
      presenca: data.presenca.present ? data.presenca.value : this.presenca,
      resultado: data.resultado.present ? data.resultado.value : this.resultado,
      quantificacaoTipo: data.quantificacaoTipo.present
          ? data.quantificacaoTipo.value
          : this.quantificacaoTipo,
      nIndividuos: data.nIndividuos.present
          ? data.nIndividuos.value
          : this.nIndividuos,
      classeAbundancia: data.classeAbundancia.present
          ? data.classeAbundancia.value
          : this.classeAbundancia,
      areaM2: data.areaM2.present ? data.areaM2.value : this.areaM2,
      coberturaPct: data.coberturaPct.present
          ? data.coberturaPct.value
          : this.coberturaPct,
      estagio: data.estagio.present ? data.estagio.value : this.estagio,
      ambiente: data.ambiente.present ? data.ambiente.value : this.ambiente,
      texto: data.texto.present ? data.texto.value : this.texto,
      ditado: data.ditado.present ? data.ditado.value : this.ditado,
      dispositivo: data.dispositivo.present
          ? data.dispositivo.value
          : this.dispositivo,
      versaoApp: data.versaoApp.present ? data.versaoApp.value : this.versaoApp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Observacao(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('focoId: $focoId, ')
          ..write('tipo: $tipo, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('sessaoId: $sessaoId, ')
          ..write('dataHora: $dataHora, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('precisaoM: $precisaoM, ')
          ..write('altitudeM: $altitudeM, ')
          ..write('presenca: $presenca, ')
          ..write('resultado: $resultado, ')
          ..write('quantificacaoTipo: $quantificacaoTipo, ')
          ..write('nIndividuos: $nIndividuos, ')
          ..write('classeAbundancia: $classeAbundancia, ')
          ..write('areaM2: $areaM2, ')
          ..write('coberturaPct: $coberturaPct, ')
          ..write('estagio: $estagio, ')
          ..write('ambiente: $ambiente, ')
          ..write('texto: $texto, ')
          ..write('ditado: $ditado, ')
          ..write('dispositivo: $dispositivo, ')
          ..write('versaoApp: $versaoApp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    focoId,
    tipo,
    usuarioId,
    sessaoId,
    dataHora,
    lat,
    lon,
    precisaoM,
    altitudeM,
    presenca,
    resultado,
    quantificacaoTipo,
    nIndividuos,
    classeAbundancia,
    areaM2,
    coberturaPct,
    estagio,
    ambiente,
    texto,
    ditado,
    dispositivo,
    versaoApp,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Observacao &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deleted == this.deleted &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version &&
          other.id == this.id &&
          other.focoId == this.focoId &&
          other.tipo == this.tipo &&
          other.usuarioId == this.usuarioId &&
          other.sessaoId == this.sessaoId &&
          other.dataHora == this.dataHora &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.precisaoM == this.precisaoM &&
          other.altitudeM == this.altitudeM &&
          other.presenca == this.presenca &&
          other.resultado == this.resultado &&
          other.quantificacaoTipo == this.quantificacaoTipo &&
          other.nIndividuos == this.nIndividuos &&
          other.classeAbundancia == this.classeAbundancia &&
          other.areaM2 == this.areaM2 &&
          other.coberturaPct == this.coberturaPct &&
          other.estagio == this.estagio &&
          other.ambiente == this.ambiente &&
          other.texto == this.texto &&
          other.ditado == this.ditado &&
          other.dispositivo == this.dispositivo &&
          other.versaoApp == this.versaoApp);
}

class ObservacoesCompanion extends UpdateCompanion<Observacao> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<bool> deleted;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<String> id;
  final Value<String> focoId;
  final Value<String> tipo;
  final Value<String> usuarioId;
  final Value<String?> sessaoId;
  final Value<DateTime> dataHora;
  final Value<double> lat;
  final Value<double> lon;
  final Value<double?> precisaoM;
  final Value<double?> altitudeM;
  final Value<String> presenca;
  final Value<String?> resultado;
  final Value<String?> quantificacaoTipo;
  final Value<int?> nIndividuos;
  final Value<String?> classeAbundancia;
  final Value<double?> areaM2;
  final Value<int?> coberturaPct;
  final Value<String?> estagio;
  final Value<String?> ambiente;
  final Value<String?> texto;
  final Value<bool> ditado;
  final Value<String?> dispositivo;
  final Value<String?> versaoApp;
  final Value<int> rowid;
  const ObservacoesCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.id = const Value.absent(),
    this.focoId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.sessaoId = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.precisaoM = const Value.absent(),
    this.altitudeM = const Value.absent(),
    this.presenca = const Value.absent(),
    this.resultado = const Value.absent(),
    this.quantificacaoTipo = const Value.absent(),
    this.nIndividuos = const Value.absent(),
    this.classeAbundancia = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.coberturaPct = const Value.absent(),
    this.estagio = const Value.absent(),
    this.ambiente = const Value.absent(),
    this.texto = const Value.absent(),
    this.ditado = const Value.absent(),
    this.dispositivo = const Value.absent(),
    this.versaoApp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ObservacoesCompanion.insert({
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    required String id,
    required String focoId,
    required String tipo,
    required String usuarioId,
    this.sessaoId = const Value.absent(),
    required DateTime dataHora,
    required double lat,
    required double lon,
    this.precisaoM = const Value.absent(),
    this.altitudeM = const Value.absent(),
    required String presenca,
    this.resultado = const Value.absent(),
    this.quantificacaoTipo = const Value.absent(),
    this.nIndividuos = const Value.absent(),
    this.classeAbundancia = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.coberturaPct = const Value.absent(),
    this.estagio = const Value.absent(),
    this.ambiente = const Value.absent(),
    this.texto = const Value.absent(),
    this.ditado = const Value.absent(),
    this.dispositivo = const Value.absent(),
    this.versaoApp = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       focoId = Value(focoId),
       tipo = Value(tipo),
       usuarioId = Value(usuarioId),
       dataHora = Value(dataHora),
       lat = Value(lat),
       lon = Value(lon),
       presenca = Value(presenca);
  static Insertable<Observacao> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<bool>? deleted,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<String>? id,
    Expression<String>? focoId,
    Expression<String>? tipo,
    Expression<String>? usuarioId,
    Expression<String>? sessaoId,
    Expression<DateTime>? dataHora,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<double>? precisaoM,
    Expression<double>? altitudeM,
    Expression<String>? presenca,
    Expression<String>? resultado,
    Expression<String>? quantificacaoTipo,
    Expression<int>? nIndividuos,
    Expression<String>? classeAbundancia,
    Expression<double>? areaM2,
    Expression<int>? coberturaPct,
    Expression<String>? estagio,
    Expression<String>? ambiente,
    Expression<String>? texto,
    Expression<bool>? ditado,
    Expression<String>? dispositivo,
    Expression<String>? versaoApp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deleted != null) 'deleted': deleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (id != null) 'id': id,
      if (focoId != null) 'foco_id': focoId,
      if (tipo != null) 'tipo': tipo,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (sessaoId != null) 'sessao_id': sessaoId,
      if (dataHora != null) 'data_hora': dataHora,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (precisaoM != null) 'precisao_m': precisaoM,
      if (altitudeM != null) 'altitude_m': altitudeM,
      if (presenca != null) 'presenca': presenca,
      if (resultado != null) 'resultado': resultado,
      if (quantificacaoTipo != null) 'quantificacao_tipo': quantificacaoTipo,
      if (nIndividuos != null) 'n_individuos': nIndividuos,
      if (classeAbundancia != null) 'classe_abundancia': classeAbundancia,
      if (areaM2 != null) 'area_m2': areaM2,
      if (coberturaPct != null) 'cobertura_pct': coberturaPct,
      if (estagio != null) 'estagio': estagio,
      if (ambiente != null) 'ambiente': ambiente,
      if (texto != null) 'texto': texto,
      if (ditado != null) 'ditado': ditado,
      if (dispositivo != null) 'dispositivo': dispositivo,
      if (versaoApp != null) 'versao_app': versaoApp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ObservacoesCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? serverUpdatedAt,
    Value<bool>? deleted,
    Value<String>? syncStatus,
    Value<int>? version,
    Value<String>? id,
    Value<String>? focoId,
    Value<String>? tipo,
    Value<String>? usuarioId,
    Value<String?>? sessaoId,
    Value<DateTime>? dataHora,
    Value<double>? lat,
    Value<double>? lon,
    Value<double?>? precisaoM,
    Value<double?>? altitudeM,
    Value<String>? presenca,
    Value<String?>? resultado,
    Value<String?>? quantificacaoTipo,
    Value<int?>? nIndividuos,
    Value<String?>? classeAbundancia,
    Value<double?>? areaM2,
    Value<int?>? coberturaPct,
    Value<String?>? estagio,
    Value<String?>? ambiente,
    Value<String?>? texto,
    Value<bool>? ditado,
    Value<String?>? dispositivo,
    Value<String?>? versaoApp,
    Value<int>? rowid,
  }) {
    return ObservacoesCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deleted: deleted ?? this.deleted,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      id: id ?? this.id,
      focoId: focoId ?? this.focoId,
      tipo: tipo ?? this.tipo,
      usuarioId: usuarioId ?? this.usuarioId,
      sessaoId: sessaoId ?? this.sessaoId,
      dataHora: dataHora ?? this.dataHora,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      precisaoM: precisaoM ?? this.precisaoM,
      altitudeM: altitudeM ?? this.altitudeM,
      presenca: presenca ?? this.presenca,
      resultado: resultado ?? this.resultado,
      quantificacaoTipo: quantificacaoTipo ?? this.quantificacaoTipo,
      nIndividuos: nIndividuos ?? this.nIndividuos,
      classeAbundancia: classeAbundancia ?? this.classeAbundancia,
      areaM2: areaM2 ?? this.areaM2,
      coberturaPct: coberturaPct ?? this.coberturaPct,
      estagio: estagio ?? this.estagio,
      ambiente: ambiente ?? this.ambiente,
      texto: texto ?? this.texto,
      ditado: ditado ?? this.ditado,
      dispositivo: dispositivo ?? this.dispositivo,
      versaoApp: versaoApp ?? this.versaoApp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (focoId.present) {
      map['foco_id'] = Variable<String>(focoId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (sessaoId.present) {
      map['sessao_id'] = Variable<String>(sessaoId.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (precisaoM.present) {
      map['precisao_m'] = Variable<double>(precisaoM.value);
    }
    if (altitudeM.present) {
      map['altitude_m'] = Variable<double>(altitudeM.value);
    }
    if (presenca.present) {
      map['presenca'] = Variable<String>(presenca.value);
    }
    if (resultado.present) {
      map['resultado'] = Variable<String>(resultado.value);
    }
    if (quantificacaoTipo.present) {
      map['quantificacao_tipo'] = Variable<String>(quantificacaoTipo.value);
    }
    if (nIndividuos.present) {
      map['n_individuos'] = Variable<int>(nIndividuos.value);
    }
    if (classeAbundancia.present) {
      map['classe_abundancia'] = Variable<String>(classeAbundancia.value);
    }
    if (areaM2.present) {
      map['area_m2'] = Variable<double>(areaM2.value);
    }
    if (coberturaPct.present) {
      map['cobertura_pct'] = Variable<int>(coberturaPct.value);
    }
    if (estagio.present) {
      map['estagio'] = Variable<String>(estagio.value);
    }
    if (ambiente.present) {
      map['ambiente'] = Variable<String>(ambiente.value);
    }
    if (texto.present) {
      map['texto'] = Variable<String>(texto.value);
    }
    if (ditado.present) {
      map['ditado'] = Variable<bool>(ditado.value);
    }
    if (dispositivo.present) {
      map['dispositivo'] = Variable<String>(dispositivo.value);
    }
    if (versaoApp.present) {
      map['versao_app'] = Variable<String>(versaoApp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObservacoesCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('focoId: $focoId, ')
          ..write('tipo: $tipo, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('sessaoId: $sessaoId, ')
          ..write('dataHora: $dataHora, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('precisaoM: $precisaoM, ')
          ..write('altitudeM: $altitudeM, ')
          ..write('presenca: $presenca, ')
          ..write('resultado: $resultado, ')
          ..write('quantificacaoTipo: $quantificacaoTipo, ')
          ..write('nIndividuos: $nIndividuos, ')
          ..write('classeAbundancia: $classeAbundancia, ')
          ..write('areaM2: $areaM2, ')
          ..write('coberturaPct: $coberturaPct, ')
          ..write('estagio: $estagio, ')
          ..write('ambiente: $ambiente, ')
          ..write('texto: $texto, ')
          ..write('ditado: $ditado, ')
          ..write('dispositivo: $dispositivo, ')
          ..write('versaoApp: $versaoApp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AcoesManejoTable extends AcoesManejo
    with TableInfo<$AcoesManejoTable, AcaoManejo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AcoesManejoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendente'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focoIdMeta = const VerificationMeta('focoId');
  @override
  late final GeneratedColumn<String> focoId = GeneratedColumn<String>(
    'foco_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES focos (id)',
    ),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responsavelMeta = const VerificationMeta(
    'responsavel',
  );
  @override
  late final GeneratedColumn<String> responsavel = GeneratedColumn<String>(
    'responsavel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataHoraInicioMeta = const VerificationMeta(
    'dataHoraInicio',
  );
  @override
  late final GeneratedColumn<DateTime> dataHoraInicio =
      GeneratedColumn<DateTime>(
        'data_hora_inicio',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dataHoraFimMeta = const VerificationMeta(
    'dataHoraFim',
  );
  @override
  late final GeneratedColumn<DateTime> dataHoraFim = GeneratedColumn<DateTime>(
    'data_hora_fim',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metodoMeta = const VerificationMeta('metodo');
  @override
  late final GeneratedColumn<String> metodo = GeneratedColumn<String>(
    'metodo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metodoTextoMeta = const VerificationMeta(
    'metodoTexto',
  );
  @override
  late final GeneratedColumn<String> metodoTexto = GeneratedColumn<String>(
    'metodo_texto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _herbicidaProdutoMeta = const VerificationMeta(
    'herbicidaProduto',
  );
  @override
  late final GeneratedColumn<String> herbicidaProduto = GeneratedColumn<String>(
    'herbicida_produto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _herbicidaConcentracaoMeta =
      const VerificationMeta('herbicidaConcentracao');
  @override
  late final GeneratedColumn<String> herbicidaConcentracao =
      GeneratedColumn<String>(
        'herbicida_concentracao',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _herbicidaVolumeLMeta = const VerificationMeta(
    'herbicidaVolumeL',
  );
  @override
  late final GeneratedColumn<double> herbicidaVolumeL = GeneratedColumn<double>(
    'herbicida_volume_l',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nIndividuosTratadosMeta =
      const VerificationMeta('nIndividuosTratados');
  @override
  late final GeneratedColumn<int> nIndividuosTratados = GeneratedColumn<int>(
    'n_individuos_tratados',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaTratadaM2Meta = const VerificationMeta(
    'areaTratadaM2',
  );
  @override
  late final GeneratedColumn<double> areaTratadaM2 = GeneratedColumn<double>(
    'area_tratada_m2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nPessoasMeta = const VerificationMeta(
    'nPessoas',
  );
  @override
  late final GeneratedColumn<int> nPessoas = GeneratedColumn<int>(
    'n_pessoas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _horasMeta = const VerificationMeta('horas');
  @override
  late final GeneratedColumn<double> horas = GeneratedColumn<double>(
    'horas',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinacaoMeta = const VerificationMeta(
    'destinacao',
  );
  @override
  late final GeneratedColumn<String> destinacao = GeneratedColumn<String>(
    'destinacao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _epiUtilizadoMeta = const VerificationMeta(
    'epiUtilizado',
  );
  @override
  late final GeneratedColumn<bool> epiUtilizado = GeneratedColumn<bool>(
    'epi_utilizado',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("epi_utilizado" IN (0, 1))',
    ),
  );
  static const VerificationMeta _condicaoTempoMeta = const VerificationMeta(
    'condicaoTempo',
  );
  @override
  late final GeneratedColumn<String> condicaoTempo = GeneratedColumn<String>(
    'condicao_tempo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textoMeta = const VerificationMeta('texto');
  @override
  late final GeneratedColumn<String> texto = GeneratedColumn<String>(
    'texto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    focoId,
    usuarioId,
    responsavel,
    dataHoraInicio,
    dataHoraFim,
    metodo,
    metodoTexto,
    herbicidaProduto,
    herbicidaConcentracao,
    herbicidaVolumeL,
    nIndividuosTratados,
    areaTratadaM2,
    nPessoas,
    horas,
    destinacao,
    epiUtilizado,
    condicaoTempo,
    texto,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'acoes_manejo';
  @override
  VerificationContext validateIntegrity(
    Insertable<AcaoManejo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('foco_id')) {
      context.handle(
        _focoIdMeta,
        focoId.isAcceptableOrUnknown(data['foco_id']!, _focoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_focoIdMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('responsavel')) {
      context.handle(
        _responsavelMeta,
        responsavel.isAcceptableOrUnknown(
          data['responsavel']!,
          _responsavelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responsavelMeta);
    }
    if (data.containsKey('data_hora_inicio')) {
      context.handle(
        _dataHoraInicioMeta,
        dataHoraInicio.isAcceptableOrUnknown(
          data['data_hora_inicio']!,
          _dataHoraInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataHoraInicioMeta);
    }
    if (data.containsKey('data_hora_fim')) {
      context.handle(
        _dataHoraFimMeta,
        dataHoraFim.isAcceptableOrUnknown(
          data['data_hora_fim']!,
          _dataHoraFimMeta,
        ),
      );
    }
    if (data.containsKey('metodo')) {
      context.handle(
        _metodoMeta,
        metodo.isAcceptableOrUnknown(data['metodo']!, _metodoMeta),
      );
    } else if (isInserting) {
      context.missing(_metodoMeta);
    }
    if (data.containsKey('metodo_texto')) {
      context.handle(
        _metodoTextoMeta,
        metodoTexto.isAcceptableOrUnknown(
          data['metodo_texto']!,
          _metodoTextoMeta,
        ),
      );
    }
    if (data.containsKey('herbicida_produto')) {
      context.handle(
        _herbicidaProdutoMeta,
        herbicidaProduto.isAcceptableOrUnknown(
          data['herbicida_produto']!,
          _herbicidaProdutoMeta,
        ),
      );
    }
    if (data.containsKey('herbicida_concentracao')) {
      context.handle(
        _herbicidaConcentracaoMeta,
        herbicidaConcentracao.isAcceptableOrUnknown(
          data['herbicida_concentracao']!,
          _herbicidaConcentracaoMeta,
        ),
      );
    }
    if (data.containsKey('herbicida_volume_l')) {
      context.handle(
        _herbicidaVolumeLMeta,
        herbicidaVolumeL.isAcceptableOrUnknown(
          data['herbicida_volume_l']!,
          _herbicidaVolumeLMeta,
        ),
      );
    }
    if (data.containsKey('n_individuos_tratados')) {
      context.handle(
        _nIndividuosTratadosMeta,
        nIndividuosTratados.isAcceptableOrUnknown(
          data['n_individuos_tratados']!,
          _nIndividuosTratadosMeta,
        ),
      );
    }
    if (data.containsKey('area_tratada_m2')) {
      context.handle(
        _areaTratadaM2Meta,
        areaTratadaM2.isAcceptableOrUnknown(
          data['area_tratada_m2']!,
          _areaTratadaM2Meta,
        ),
      );
    }
    if (data.containsKey('n_pessoas')) {
      context.handle(
        _nPessoasMeta,
        nPessoas.isAcceptableOrUnknown(data['n_pessoas']!, _nPessoasMeta),
      );
    } else if (isInserting) {
      context.missing(_nPessoasMeta);
    }
    if (data.containsKey('horas')) {
      context.handle(
        _horasMeta,
        horas.isAcceptableOrUnknown(data['horas']!, _horasMeta),
      );
    } else if (isInserting) {
      context.missing(_horasMeta);
    }
    if (data.containsKey('destinacao')) {
      context.handle(
        _destinacaoMeta,
        destinacao.isAcceptableOrUnknown(data['destinacao']!, _destinacaoMeta),
      );
    }
    if (data.containsKey('epi_utilizado')) {
      context.handle(
        _epiUtilizadoMeta,
        epiUtilizado.isAcceptableOrUnknown(
          data['epi_utilizado']!,
          _epiUtilizadoMeta,
        ),
      );
    }
    if (data.containsKey('condicao_tempo')) {
      context.handle(
        _condicaoTempoMeta,
        condicaoTempo.isAcceptableOrUnknown(
          data['condicao_tempo']!,
          _condicaoTempoMeta,
        ),
      );
    }
    if (data.containsKey('texto')) {
      context.handle(
        _textoMeta,
        texto.isAcceptableOrUnknown(data['texto']!, _textoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AcaoManejo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AcaoManejo(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      focoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foco_id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      responsavel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}responsavel'],
      )!,
      dataHoraInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora_inicio'],
      )!,
      dataHoraFim: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora_fim'],
      ),
      metodo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metodo'],
      )!,
      metodoTexto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metodo_texto'],
      ),
      herbicidaProduto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}herbicida_produto'],
      ),
      herbicidaConcentracao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}herbicida_concentracao'],
      ),
      herbicidaVolumeL: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}herbicida_volume_l'],
      ),
      nIndividuosTratados: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}n_individuos_tratados'],
      ),
      areaTratadaM2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_tratada_m2'],
      ),
      nPessoas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}n_pessoas'],
      )!,
      horas: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}horas'],
      )!,
      destinacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destinacao'],
      ),
      epiUtilizado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}epi_utilizado'],
      ),
      condicaoTempo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condicao_tempo'],
      ),
      texto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}texto'],
      ),
    );
  }

  @override
  $AcoesManejoTable createAlias(String alias) {
    return $AcoesManejoTable(attachedDatabase, alias);
  }
}

class AcaoManejo extends DataClass implements Insertable<AcaoManejo> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? serverUpdatedAt;
  final bool deleted;
  final String syncStatus;
  final int version;
  final String id;
  final String focoId;
  final String usuarioId;
  final String responsavel;
  final DateTime dataHoraInicio;
  final DateTime? dataHoraFim;
  final String metodo;
  final String? metodoTexto;
  final String? herbicidaProduto;
  final String? herbicidaConcentracao;
  final double? herbicidaVolumeL;
  final int? nIndividuosTratados;
  final double? areaTratadaM2;
  final int nPessoas;
  final double horas;
  final String? destinacao;
  final bool? epiUtilizado;
  final String? condicaoTempo;
  final String? texto;
  const AcaoManejo({
    required this.createdAt,
    required this.updatedAt,
    this.serverUpdatedAt,
    required this.deleted,
    required this.syncStatus,
    required this.version,
    required this.id,
    required this.focoId,
    required this.usuarioId,
    required this.responsavel,
    required this.dataHoraInicio,
    this.dataHoraFim,
    required this.metodo,
    this.metodoTexto,
    this.herbicidaProduto,
    this.herbicidaConcentracao,
    this.herbicidaVolumeL,
    this.nIndividuosTratados,
    this.areaTratadaM2,
    required this.nPessoas,
    required this.horas,
    this.destinacao,
    this.epiUtilizado,
    this.condicaoTempo,
    this.texto,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    map['id'] = Variable<String>(id);
    map['foco_id'] = Variable<String>(focoId);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['responsavel'] = Variable<String>(responsavel);
    map['data_hora_inicio'] = Variable<DateTime>(dataHoraInicio);
    if (!nullToAbsent || dataHoraFim != null) {
      map['data_hora_fim'] = Variable<DateTime>(dataHoraFim);
    }
    map['metodo'] = Variable<String>(metodo);
    if (!nullToAbsent || metodoTexto != null) {
      map['metodo_texto'] = Variable<String>(metodoTexto);
    }
    if (!nullToAbsent || herbicidaProduto != null) {
      map['herbicida_produto'] = Variable<String>(herbicidaProduto);
    }
    if (!nullToAbsent || herbicidaConcentracao != null) {
      map['herbicida_concentracao'] = Variable<String>(herbicidaConcentracao);
    }
    if (!nullToAbsent || herbicidaVolumeL != null) {
      map['herbicida_volume_l'] = Variable<double>(herbicidaVolumeL);
    }
    if (!nullToAbsent || nIndividuosTratados != null) {
      map['n_individuos_tratados'] = Variable<int>(nIndividuosTratados);
    }
    if (!nullToAbsent || areaTratadaM2 != null) {
      map['area_tratada_m2'] = Variable<double>(areaTratadaM2);
    }
    map['n_pessoas'] = Variable<int>(nPessoas);
    map['horas'] = Variable<double>(horas);
    if (!nullToAbsent || destinacao != null) {
      map['destinacao'] = Variable<String>(destinacao);
    }
    if (!nullToAbsent || epiUtilizado != null) {
      map['epi_utilizado'] = Variable<bool>(epiUtilizado);
    }
    if (!nullToAbsent || condicaoTempo != null) {
      map['condicao_tempo'] = Variable<String>(condicaoTempo);
    }
    if (!nullToAbsent || texto != null) {
      map['texto'] = Variable<String>(texto);
    }
    return map;
  }

  AcoesManejoCompanion toCompanion(bool nullToAbsent) {
    return AcoesManejoCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      deleted: Value(deleted),
      syncStatus: Value(syncStatus),
      version: Value(version),
      id: Value(id),
      focoId: Value(focoId),
      usuarioId: Value(usuarioId),
      responsavel: Value(responsavel),
      dataHoraInicio: Value(dataHoraInicio),
      dataHoraFim: dataHoraFim == null && nullToAbsent
          ? const Value.absent()
          : Value(dataHoraFim),
      metodo: Value(metodo),
      metodoTexto: metodoTexto == null && nullToAbsent
          ? const Value.absent()
          : Value(metodoTexto),
      herbicidaProduto: herbicidaProduto == null && nullToAbsent
          ? const Value.absent()
          : Value(herbicidaProduto),
      herbicidaConcentracao: herbicidaConcentracao == null && nullToAbsent
          ? const Value.absent()
          : Value(herbicidaConcentracao),
      herbicidaVolumeL: herbicidaVolumeL == null && nullToAbsent
          ? const Value.absent()
          : Value(herbicidaVolumeL),
      nIndividuosTratados: nIndividuosTratados == null && nullToAbsent
          ? const Value.absent()
          : Value(nIndividuosTratados),
      areaTratadaM2: areaTratadaM2 == null && nullToAbsent
          ? const Value.absent()
          : Value(areaTratadaM2),
      nPessoas: Value(nPessoas),
      horas: Value(horas),
      destinacao: destinacao == null && nullToAbsent
          ? const Value.absent()
          : Value(destinacao),
      epiUtilizado: epiUtilizado == null && nullToAbsent
          ? const Value.absent()
          : Value(epiUtilizado),
      condicaoTempo: condicaoTempo == null && nullToAbsent
          ? const Value.absent()
          : Value(condicaoTempo),
      texto: texto == null && nullToAbsent
          ? const Value.absent()
          : Value(texto),
    );
  }

  factory AcaoManejo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AcaoManejo(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
      id: serializer.fromJson<String>(json['id']),
      focoId: serializer.fromJson<String>(json['focoId']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      responsavel: serializer.fromJson<String>(json['responsavel']),
      dataHoraInicio: serializer.fromJson<DateTime>(json['dataHoraInicio']),
      dataHoraFim: serializer.fromJson<DateTime?>(json['dataHoraFim']),
      metodo: serializer.fromJson<String>(json['metodo']),
      metodoTexto: serializer.fromJson<String?>(json['metodoTexto']),
      herbicidaProduto: serializer.fromJson<String?>(json['herbicidaProduto']),
      herbicidaConcentracao: serializer.fromJson<String?>(
        json['herbicidaConcentracao'],
      ),
      herbicidaVolumeL: serializer.fromJson<double?>(json['herbicidaVolumeL']),
      nIndividuosTratados: serializer.fromJson<int?>(
        json['nIndividuosTratados'],
      ),
      areaTratadaM2: serializer.fromJson<double?>(json['areaTratadaM2']),
      nPessoas: serializer.fromJson<int>(json['nPessoas']),
      horas: serializer.fromJson<double>(json['horas']),
      destinacao: serializer.fromJson<String?>(json['destinacao']),
      epiUtilizado: serializer.fromJson<bool?>(json['epiUtilizado']),
      condicaoTempo: serializer.fromJson<String?>(json['condicaoTempo']),
      texto: serializer.fromJson<String?>(json['texto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
      'id': serializer.toJson<String>(id),
      'focoId': serializer.toJson<String>(focoId),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'responsavel': serializer.toJson<String>(responsavel),
      'dataHoraInicio': serializer.toJson<DateTime>(dataHoraInicio),
      'dataHoraFim': serializer.toJson<DateTime?>(dataHoraFim),
      'metodo': serializer.toJson<String>(metodo),
      'metodoTexto': serializer.toJson<String?>(metodoTexto),
      'herbicidaProduto': serializer.toJson<String?>(herbicidaProduto),
      'herbicidaConcentracao': serializer.toJson<String?>(
        herbicidaConcentracao,
      ),
      'herbicidaVolumeL': serializer.toJson<double?>(herbicidaVolumeL),
      'nIndividuosTratados': serializer.toJson<int?>(nIndividuosTratados),
      'areaTratadaM2': serializer.toJson<double?>(areaTratadaM2),
      'nPessoas': serializer.toJson<int>(nPessoas),
      'horas': serializer.toJson<double>(horas),
      'destinacao': serializer.toJson<String?>(destinacao),
      'epiUtilizado': serializer.toJson<bool?>(epiUtilizado),
      'condicaoTempo': serializer.toJson<String?>(condicaoTempo),
      'texto': serializer.toJson<String?>(texto),
    };
  }

  AcaoManejo copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    bool? deleted,
    String? syncStatus,
    int? version,
    String? id,
    String? focoId,
    String? usuarioId,
    String? responsavel,
    DateTime? dataHoraInicio,
    Value<DateTime?> dataHoraFim = const Value.absent(),
    String? metodo,
    Value<String?> metodoTexto = const Value.absent(),
    Value<String?> herbicidaProduto = const Value.absent(),
    Value<String?> herbicidaConcentracao = const Value.absent(),
    Value<double?> herbicidaVolumeL = const Value.absent(),
    Value<int?> nIndividuosTratados = const Value.absent(),
    Value<double?> areaTratadaM2 = const Value.absent(),
    int? nPessoas,
    double? horas,
    Value<String?> destinacao = const Value.absent(),
    Value<bool?> epiUtilizado = const Value.absent(),
    Value<String?> condicaoTempo = const Value.absent(),
    Value<String?> texto = const Value.absent(),
  }) => AcaoManejo(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    deleted: deleted ?? this.deleted,
    syncStatus: syncStatus ?? this.syncStatus,
    version: version ?? this.version,
    id: id ?? this.id,
    focoId: focoId ?? this.focoId,
    usuarioId: usuarioId ?? this.usuarioId,
    responsavel: responsavel ?? this.responsavel,
    dataHoraInicio: dataHoraInicio ?? this.dataHoraInicio,
    dataHoraFim: dataHoraFim.present ? dataHoraFim.value : this.dataHoraFim,
    metodo: metodo ?? this.metodo,
    metodoTexto: metodoTexto.present ? metodoTexto.value : this.metodoTexto,
    herbicidaProduto: herbicidaProduto.present
        ? herbicidaProduto.value
        : this.herbicidaProduto,
    herbicidaConcentracao: herbicidaConcentracao.present
        ? herbicidaConcentracao.value
        : this.herbicidaConcentracao,
    herbicidaVolumeL: herbicidaVolumeL.present
        ? herbicidaVolumeL.value
        : this.herbicidaVolumeL,
    nIndividuosTratados: nIndividuosTratados.present
        ? nIndividuosTratados.value
        : this.nIndividuosTratados,
    areaTratadaM2: areaTratadaM2.present
        ? areaTratadaM2.value
        : this.areaTratadaM2,
    nPessoas: nPessoas ?? this.nPessoas,
    horas: horas ?? this.horas,
    destinacao: destinacao.present ? destinacao.value : this.destinacao,
    epiUtilizado: epiUtilizado.present ? epiUtilizado.value : this.epiUtilizado,
    condicaoTempo: condicaoTempo.present
        ? condicaoTempo.value
        : this.condicaoTempo,
    texto: texto.present ? texto.value : this.texto,
  );
  AcaoManejo copyWithCompanion(AcoesManejoCompanion data) {
    return AcaoManejo(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
      id: data.id.present ? data.id.value : this.id,
      focoId: data.focoId.present ? data.focoId.value : this.focoId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      responsavel: data.responsavel.present
          ? data.responsavel.value
          : this.responsavel,
      dataHoraInicio: data.dataHoraInicio.present
          ? data.dataHoraInicio.value
          : this.dataHoraInicio,
      dataHoraFim: data.dataHoraFim.present
          ? data.dataHoraFim.value
          : this.dataHoraFim,
      metodo: data.metodo.present ? data.metodo.value : this.metodo,
      metodoTexto: data.metodoTexto.present
          ? data.metodoTexto.value
          : this.metodoTexto,
      herbicidaProduto: data.herbicidaProduto.present
          ? data.herbicidaProduto.value
          : this.herbicidaProduto,
      herbicidaConcentracao: data.herbicidaConcentracao.present
          ? data.herbicidaConcentracao.value
          : this.herbicidaConcentracao,
      herbicidaVolumeL: data.herbicidaVolumeL.present
          ? data.herbicidaVolumeL.value
          : this.herbicidaVolumeL,
      nIndividuosTratados: data.nIndividuosTratados.present
          ? data.nIndividuosTratados.value
          : this.nIndividuosTratados,
      areaTratadaM2: data.areaTratadaM2.present
          ? data.areaTratadaM2.value
          : this.areaTratadaM2,
      nPessoas: data.nPessoas.present ? data.nPessoas.value : this.nPessoas,
      horas: data.horas.present ? data.horas.value : this.horas,
      destinacao: data.destinacao.present
          ? data.destinacao.value
          : this.destinacao,
      epiUtilizado: data.epiUtilizado.present
          ? data.epiUtilizado.value
          : this.epiUtilizado,
      condicaoTempo: data.condicaoTempo.present
          ? data.condicaoTempo.value
          : this.condicaoTempo,
      texto: data.texto.present ? data.texto.value : this.texto,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AcaoManejo(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('focoId: $focoId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('responsavel: $responsavel, ')
          ..write('dataHoraInicio: $dataHoraInicio, ')
          ..write('dataHoraFim: $dataHoraFim, ')
          ..write('metodo: $metodo, ')
          ..write('metodoTexto: $metodoTexto, ')
          ..write('herbicidaProduto: $herbicidaProduto, ')
          ..write('herbicidaConcentracao: $herbicidaConcentracao, ')
          ..write('herbicidaVolumeL: $herbicidaVolumeL, ')
          ..write('nIndividuosTratados: $nIndividuosTratados, ')
          ..write('areaTratadaM2: $areaTratadaM2, ')
          ..write('nPessoas: $nPessoas, ')
          ..write('horas: $horas, ')
          ..write('destinacao: $destinacao, ')
          ..write('epiUtilizado: $epiUtilizado, ')
          ..write('condicaoTempo: $condicaoTempo, ')
          ..write('texto: $texto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    focoId,
    usuarioId,
    responsavel,
    dataHoraInicio,
    dataHoraFim,
    metodo,
    metodoTexto,
    herbicidaProduto,
    herbicidaConcentracao,
    herbicidaVolumeL,
    nIndividuosTratados,
    areaTratadaM2,
    nPessoas,
    horas,
    destinacao,
    epiUtilizado,
    condicaoTempo,
    texto,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AcaoManejo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deleted == this.deleted &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version &&
          other.id == this.id &&
          other.focoId == this.focoId &&
          other.usuarioId == this.usuarioId &&
          other.responsavel == this.responsavel &&
          other.dataHoraInicio == this.dataHoraInicio &&
          other.dataHoraFim == this.dataHoraFim &&
          other.metodo == this.metodo &&
          other.metodoTexto == this.metodoTexto &&
          other.herbicidaProduto == this.herbicidaProduto &&
          other.herbicidaConcentracao == this.herbicidaConcentracao &&
          other.herbicidaVolumeL == this.herbicidaVolumeL &&
          other.nIndividuosTratados == this.nIndividuosTratados &&
          other.areaTratadaM2 == this.areaTratadaM2 &&
          other.nPessoas == this.nPessoas &&
          other.horas == this.horas &&
          other.destinacao == this.destinacao &&
          other.epiUtilizado == this.epiUtilizado &&
          other.condicaoTempo == this.condicaoTempo &&
          other.texto == this.texto);
}

class AcoesManejoCompanion extends UpdateCompanion<AcaoManejo> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<bool> deleted;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<String> id;
  final Value<String> focoId;
  final Value<String> usuarioId;
  final Value<String> responsavel;
  final Value<DateTime> dataHoraInicio;
  final Value<DateTime?> dataHoraFim;
  final Value<String> metodo;
  final Value<String?> metodoTexto;
  final Value<String?> herbicidaProduto;
  final Value<String?> herbicidaConcentracao;
  final Value<double?> herbicidaVolumeL;
  final Value<int?> nIndividuosTratados;
  final Value<double?> areaTratadaM2;
  final Value<int> nPessoas;
  final Value<double> horas;
  final Value<String?> destinacao;
  final Value<bool?> epiUtilizado;
  final Value<String?> condicaoTempo;
  final Value<String?> texto;
  final Value<int> rowid;
  const AcoesManejoCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.id = const Value.absent(),
    this.focoId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.responsavel = const Value.absent(),
    this.dataHoraInicio = const Value.absent(),
    this.dataHoraFim = const Value.absent(),
    this.metodo = const Value.absent(),
    this.metodoTexto = const Value.absent(),
    this.herbicidaProduto = const Value.absent(),
    this.herbicidaConcentracao = const Value.absent(),
    this.herbicidaVolumeL = const Value.absent(),
    this.nIndividuosTratados = const Value.absent(),
    this.areaTratadaM2 = const Value.absent(),
    this.nPessoas = const Value.absent(),
    this.horas = const Value.absent(),
    this.destinacao = const Value.absent(),
    this.epiUtilizado = const Value.absent(),
    this.condicaoTempo = const Value.absent(),
    this.texto = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AcoesManejoCompanion.insert({
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    required String id,
    required String focoId,
    required String usuarioId,
    required String responsavel,
    required DateTime dataHoraInicio,
    this.dataHoraFim = const Value.absent(),
    required String metodo,
    this.metodoTexto = const Value.absent(),
    this.herbicidaProduto = const Value.absent(),
    this.herbicidaConcentracao = const Value.absent(),
    this.herbicidaVolumeL = const Value.absent(),
    this.nIndividuosTratados = const Value.absent(),
    this.areaTratadaM2 = const Value.absent(),
    required int nPessoas,
    required double horas,
    this.destinacao = const Value.absent(),
    this.epiUtilizado = const Value.absent(),
    this.condicaoTempo = const Value.absent(),
    this.texto = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       focoId = Value(focoId),
       usuarioId = Value(usuarioId),
       responsavel = Value(responsavel),
       dataHoraInicio = Value(dataHoraInicio),
       metodo = Value(metodo),
       nPessoas = Value(nPessoas),
       horas = Value(horas);
  static Insertable<AcaoManejo> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<bool>? deleted,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<String>? id,
    Expression<String>? focoId,
    Expression<String>? usuarioId,
    Expression<String>? responsavel,
    Expression<DateTime>? dataHoraInicio,
    Expression<DateTime>? dataHoraFim,
    Expression<String>? metodo,
    Expression<String>? metodoTexto,
    Expression<String>? herbicidaProduto,
    Expression<String>? herbicidaConcentracao,
    Expression<double>? herbicidaVolumeL,
    Expression<int>? nIndividuosTratados,
    Expression<double>? areaTratadaM2,
    Expression<int>? nPessoas,
    Expression<double>? horas,
    Expression<String>? destinacao,
    Expression<bool>? epiUtilizado,
    Expression<String>? condicaoTempo,
    Expression<String>? texto,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deleted != null) 'deleted': deleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (id != null) 'id': id,
      if (focoId != null) 'foco_id': focoId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (responsavel != null) 'responsavel': responsavel,
      if (dataHoraInicio != null) 'data_hora_inicio': dataHoraInicio,
      if (dataHoraFim != null) 'data_hora_fim': dataHoraFim,
      if (metodo != null) 'metodo': metodo,
      if (metodoTexto != null) 'metodo_texto': metodoTexto,
      if (herbicidaProduto != null) 'herbicida_produto': herbicidaProduto,
      if (herbicidaConcentracao != null)
        'herbicida_concentracao': herbicidaConcentracao,
      if (herbicidaVolumeL != null) 'herbicida_volume_l': herbicidaVolumeL,
      if (nIndividuosTratados != null)
        'n_individuos_tratados': nIndividuosTratados,
      if (areaTratadaM2 != null) 'area_tratada_m2': areaTratadaM2,
      if (nPessoas != null) 'n_pessoas': nPessoas,
      if (horas != null) 'horas': horas,
      if (destinacao != null) 'destinacao': destinacao,
      if (epiUtilizado != null) 'epi_utilizado': epiUtilizado,
      if (condicaoTempo != null) 'condicao_tempo': condicaoTempo,
      if (texto != null) 'texto': texto,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AcoesManejoCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? serverUpdatedAt,
    Value<bool>? deleted,
    Value<String>? syncStatus,
    Value<int>? version,
    Value<String>? id,
    Value<String>? focoId,
    Value<String>? usuarioId,
    Value<String>? responsavel,
    Value<DateTime>? dataHoraInicio,
    Value<DateTime?>? dataHoraFim,
    Value<String>? metodo,
    Value<String?>? metodoTexto,
    Value<String?>? herbicidaProduto,
    Value<String?>? herbicidaConcentracao,
    Value<double?>? herbicidaVolumeL,
    Value<int?>? nIndividuosTratados,
    Value<double?>? areaTratadaM2,
    Value<int>? nPessoas,
    Value<double>? horas,
    Value<String?>? destinacao,
    Value<bool?>? epiUtilizado,
    Value<String?>? condicaoTempo,
    Value<String?>? texto,
    Value<int>? rowid,
  }) {
    return AcoesManejoCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deleted: deleted ?? this.deleted,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      id: id ?? this.id,
      focoId: focoId ?? this.focoId,
      usuarioId: usuarioId ?? this.usuarioId,
      responsavel: responsavel ?? this.responsavel,
      dataHoraInicio: dataHoraInicio ?? this.dataHoraInicio,
      dataHoraFim: dataHoraFim ?? this.dataHoraFim,
      metodo: metodo ?? this.metodo,
      metodoTexto: metodoTexto ?? this.metodoTexto,
      herbicidaProduto: herbicidaProduto ?? this.herbicidaProduto,
      herbicidaConcentracao:
          herbicidaConcentracao ?? this.herbicidaConcentracao,
      herbicidaVolumeL: herbicidaVolumeL ?? this.herbicidaVolumeL,
      nIndividuosTratados: nIndividuosTratados ?? this.nIndividuosTratados,
      areaTratadaM2: areaTratadaM2 ?? this.areaTratadaM2,
      nPessoas: nPessoas ?? this.nPessoas,
      horas: horas ?? this.horas,
      destinacao: destinacao ?? this.destinacao,
      epiUtilizado: epiUtilizado ?? this.epiUtilizado,
      condicaoTempo: condicaoTempo ?? this.condicaoTempo,
      texto: texto ?? this.texto,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (focoId.present) {
      map['foco_id'] = Variable<String>(focoId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (responsavel.present) {
      map['responsavel'] = Variable<String>(responsavel.value);
    }
    if (dataHoraInicio.present) {
      map['data_hora_inicio'] = Variable<DateTime>(dataHoraInicio.value);
    }
    if (dataHoraFim.present) {
      map['data_hora_fim'] = Variable<DateTime>(dataHoraFim.value);
    }
    if (metodo.present) {
      map['metodo'] = Variable<String>(metodo.value);
    }
    if (metodoTexto.present) {
      map['metodo_texto'] = Variable<String>(metodoTexto.value);
    }
    if (herbicidaProduto.present) {
      map['herbicida_produto'] = Variable<String>(herbicidaProduto.value);
    }
    if (herbicidaConcentracao.present) {
      map['herbicida_concentracao'] = Variable<String>(
        herbicidaConcentracao.value,
      );
    }
    if (herbicidaVolumeL.present) {
      map['herbicida_volume_l'] = Variable<double>(herbicidaVolumeL.value);
    }
    if (nIndividuosTratados.present) {
      map['n_individuos_tratados'] = Variable<int>(nIndividuosTratados.value);
    }
    if (areaTratadaM2.present) {
      map['area_tratada_m2'] = Variable<double>(areaTratadaM2.value);
    }
    if (nPessoas.present) {
      map['n_pessoas'] = Variable<int>(nPessoas.value);
    }
    if (horas.present) {
      map['horas'] = Variable<double>(horas.value);
    }
    if (destinacao.present) {
      map['destinacao'] = Variable<String>(destinacao.value);
    }
    if (epiUtilizado.present) {
      map['epi_utilizado'] = Variable<bool>(epiUtilizado.value);
    }
    if (condicaoTempo.present) {
      map['condicao_tempo'] = Variable<String>(condicaoTempo.value);
    }
    if (texto.present) {
      map['texto'] = Variable<String>(texto.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AcoesManejoCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('focoId: $focoId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('responsavel: $responsavel, ')
          ..write('dataHoraInicio: $dataHoraInicio, ')
          ..write('dataHoraFim: $dataHoraFim, ')
          ..write('metodo: $metodo, ')
          ..write('metodoTexto: $metodoTexto, ')
          ..write('herbicidaProduto: $herbicidaProduto, ')
          ..write('herbicidaConcentracao: $herbicidaConcentracao, ')
          ..write('herbicidaVolumeL: $herbicidaVolumeL, ')
          ..write('nIndividuosTratados: $nIndividuosTratados, ')
          ..write('areaTratadaM2: $areaTratadaM2, ')
          ..write('nPessoas: $nPessoas, ')
          ..write('horas: $horas, ')
          ..write('destinacao: $destinacao, ')
          ..write('epiUtilizado: $epiUtilizado, ')
          ..write('condicaoTempo: $condicaoTempo, ')
          ..write('texto: $texto, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MidiasTable extends Midias with TableInfo<$MidiasTable, Midia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MidiasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendente'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _donoTipoMeta = const VerificationMeta(
    'donoTipo',
  );
  @override
  late final GeneratedColumn<String> donoTipo = GeneratedColumn<String>(
    'dono_tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _donoIdMeta = const VerificationMeta('donoId');
  @override
  late final GeneratedColumn<String> donoId = GeneratedColumn<String>(
    'dono_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('foto'),
  );
  static const VerificationMeta _momentoMeta = const VerificationMeta(
    'momento',
  );
  @override
  late final GeneratedColumn<String> momento = GeneratedColumn<String>(
    'momento',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caminhoLocalMeta = const VerificationMeta(
    'caminhoLocal',
  );
  @override
  late final GeneratedColumn<String> caminhoLocal = GeneratedColumn<String>(
    'caminho_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caminhoRemotoMeta = const VerificationMeta(
    'caminhoRemoto',
  );
  @override
  late final GeneratedColumn<String> caminhoRemoto = GeneratedColumn<String>(
    'caminho_remoto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tiradaEmMeta = const VerificationMeta(
    'tiradaEm',
  );
  @override
  late final GeneratedColumn<DateTime> tiradaEm = GeneratedColumn<DateTime>(
    'tirada_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tamanhoBytesMeta = const VerificationMeta(
    'tamanhoBytes',
  );
  @override
  late final GeneratedColumn<int> tamanhoBytes = GeneratedColumn<int>(
    'tamanho_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uploadStatusMeta = const VerificationMeta(
    'uploadStatus',
  );
  @override
  late final GeneratedColumn<String> uploadStatus = GeneratedColumn<String>(
    'upload_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendente'),
  );
  static const VerificationMeta _uploadErroMeta = const VerificationMeta(
    'uploadErro',
  );
  @override
  late final GeneratedColumn<String> uploadErro = GeneratedColumn<String>(
    'upload_erro',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    donoTipo,
    donoId,
    tipo,
    momento,
    caminhoLocal,
    caminhoRemoto,
    lat,
    lon,
    tiradaEm,
    tamanhoBytes,
    uploadStatus,
    uploadErro,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'midias';
  @override
  VerificationContext validateIntegrity(
    Insertable<Midia> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('dono_tipo')) {
      context.handle(
        _donoTipoMeta,
        donoTipo.isAcceptableOrUnknown(data['dono_tipo']!, _donoTipoMeta),
      );
    } else if (isInserting) {
      context.missing(_donoTipoMeta);
    }
    if (data.containsKey('dono_id')) {
      context.handle(
        _donoIdMeta,
        donoId.isAcceptableOrUnknown(data['dono_id']!, _donoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_donoIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('momento')) {
      context.handle(
        _momentoMeta,
        momento.isAcceptableOrUnknown(data['momento']!, _momentoMeta),
      );
    }
    if (data.containsKey('caminho_local')) {
      context.handle(
        _caminhoLocalMeta,
        caminhoLocal.isAcceptableOrUnknown(
          data['caminho_local']!,
          _caminhoLocalMeta,
        ),
      );
    }
    if (data.containsKey('caminho_remoto')) {
      context.handle(
        _caminhoRemotoMeta,
        caminhoRemoto.isAcceptableOrUnknown(
          data['caminho_remoto']!,
          _caminhoRemotoMeta,
        ),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    }
    if (data.containsKey('tirada_em')) {
      context.handle(
        _tiradaEmMeta,
        tiradaEm.isAcceptableOrUnknown(data['tirada_em']!, _tiradaEmMeta),
      );
    } else if (isInserting) {
      context.missing(_tiradaEmMeta);
    }
    if (data.containsKey('tamanho_bytes')) {
      context.handle(
        _tamanhoBytesMeta,
        tamanhoBytes.isAcceptableOrUnknown(
          data['tamanho_bytes']!,
          _tamanhoBytesMeta,
        ),
      );
    }
    if (data.containsKey('upload_status')) {
      context.handle(
        _uploadStatusMeta,
        uploadStatus.isAcceptableOrUnknown(
          data['upload_status']!,
          _uploadStatusMeta,
        ),
      );
    }
    if (data.containsKey('upload_erro')) {
      context.handle(
        _uploadErroMeta,
        uploadErro.isAcceptableOrUnknown(data['upload_erro']!, _uploadErroMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Midia map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Midia(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      donoTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dono_tipo'],
      )!,
      donoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dono_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      momento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}momento'],
      ),
      caminhoLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caminho_local'],
      ),
      caminhoRemoto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caminho_remoto'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      ),
      tiradaEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tirada_em'],
      )!,
      tamanhoBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tamanho_bytes'],
      ),
      uploadStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upload_status'],
      )!,
      uploadErro: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upload_erro'],
      ),
    );
  }

  @override
  $MidiasTable createAlias(String alias) {
    return $MidiasTable(attachedDatabase, alias);
  }
}

class Midia extends DataClass implements Insertable<Midia> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? serverUpdatedAt;
  final bool deleted;
  final String syncStatus;
  final int version;
  final String id;
  final String donoTipo;
  final String donoId;
  final String tipo;
  final String? momento;
  final String? caminhoLocal;
  final String? caminhoRemoto;
  final double? lat;
  final double? lon;
  final DateTime tiradaEm;
  final int? tamanhoBytes;
  final String uploadStatus;
  final String? uploadErro;
  const Midia({
    required this.createdAt,
    required this.updatedAt,
    this.serverUpdatedAt,
    required this.deleted,
    required this.syncStatus,
    required this.version,
    required this.id,
    required this.donoTipo,
    required this.donoId,
    required this.tipo,
    this.momento,
    this.caminhoLocal,
    this.caminhoRemoto,
    this.lat,
    this.lon,
    required this.tiradaEm,
    this.tamanhoBytes,
    required this.uploadStatus,
    this.uploadErro,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    map['id'] = Variable<String>(id);
    map['dono_tipo'] = Variable<String>(donoTipo);
    map['dono_id'] = Variable<String>(donoId);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || momento != null) {
      map['momento'] = Variable<String>(momento);
    }
    if (!nullToAbsent || caminhoLocal != null) {
      map['caminho_local'] = Variable<String>(caminhoLocal);
    }
    if (!nullToAbsent || caminhoRemoto != null) {
      map['caminho_remoto'] = Variable<String>(caminhoRemoto);
    }
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lon != null) {
      map['lon'] = Variable<double>(lon);
    }
    map['tirada_em'] = Variable<DateTime>(tiradaEm);
    if (!nullToAbsent || tamanhoBytes != null) {
      map['tamanho_bytes'] = Variable<int>(tamanhoBytes);
    }
    map['upload_status'] = Variable<String>(uploadStatus);
    if (!nullToAbsent || uploadErro != null) {
      map['upload_erro'] = Variable<String>(uploadErro);
    }
    return map;
  }

  MidiasCompanion toCompanion(bool nullToAbsent) {
    return MidiasCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      deleted: Value(deleted),
      syncStatus: Value(syncStatus),
      version: Value(version),
      id: Value(id),
      donoTipo: Value(donoTipo),
      donoId: Value(donoId),
      tipo: Value(tipo),
      momento: momento == null && nullToAbsent
          ? const Value.absent()
          : Value(momento),
      caminhoLocal: caminhoLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(caminhoLocal),
      caminhoRemoto: caminhoRemoto == null && nullToAbsent
          ? const Value.absent()
          : Value(caminhoRemoto),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lon: lon == null && nullToAbsent ? const Value.absent() : Value(lon),
      tiradaEm: Value(tiradaEm),
      tamanhoBytes: tamanhoBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(tamanhoBytes),
      uploadStatus: Value(uploadStatus),
      uploadErro: uploadErro == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadErro),
    );
  }

  factory Midia.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Midia(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
      id: serializer.fromJson<String>(json['id']),
      donoTipo: serializer.fromJson<String>(json['donoTipo']),
      donoId: serializer.fromJson<String>(json['donoId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      momento: serializer.fromJson<String?>(json['momento']),
      caminhoLocal: serializer.fromJson<String?>(json['caminhoLocal']),
      caminhoRemoto: serializer.fromJson<String?>(json['caminhoRemoto']),
      lat: serializer.fromJson<double?>(json['lat']),
      lon: serializer.fromJson<double?>(json['lon']),
      tiradaEm: serializer.fromJson<DateTime>(json['tiradaEm']),
      tamanhoBytes: serializer.fromJson<int?>(json['tamanhoBytes']),
      uploadStatus: serializer.fromJson<String>(json['uploadStatus']),
      uploadErro: serializer.fromJson<String?>(json['uploadErro']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
      'id': serializer.toJson<String>(id),
      'donoTipo': serializer.toJson<String>(donoTipo),
      'donoId': serializer.toJson<String>(donoId),
      'tipo': serializer.toJson<String>(tipo),
      'momento': serializer.toJson<String?>(momento),
      'caminhoLocal': serializer.toJson<String?>(caminhoLocal),
      'caminhoRemoto': serializer.toJson<String?>(caminhoRemoto),
      'lat': serializer.toJson<double?>(lat),
      'lon': serializer.toJson<double?>(lon),
      'tiradaEm': serializer.toJson<DateTime>(tiradaEm),
      'tamanhoBytes': serializer.toJson<int?>(tamanhoBytes),
      'uploadStatus': serializer.toJson<String>(uploadStatus),
      'uploadErro': serializer.toJson<String?>(uploadErro),
    };
  }

  Midia copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    bool? deleted,
    String? syncStatus,
    int? version,
    String? id,
    String? donoTipo,
    String? donoId,
    String? tipo,
    Value<String?> momento = const Value.absent(),
    Value<String?> caminhoLocal = const Value.absent(),
    Value<String?> caminhoRemoto = const Value.absent(),
    Value<double?> lat = const Value.absent(),
    Value<double?> lon = const Value.absent(),
    DateTime? tiradaEm,
    Value<int?> tamanhoBytes = const Value.absent(),
    String? uploadStatus,
    Value<String?> uploadErro = const Value.absent(),
  }) => Midia(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    deleted: deleted ?? this.deleted,
    syncStatus: syncStatus ?? this.syncStatus,
    version: version ?? this.version,
    id: id ?? this.id,
    donoTipo: donoTipo ?? this.donoTipo,
    donoId: donoId ?? this.donoId,
    tipo: tipo ?? this.tipo,
    momento: momento.present ? momento.value : this.momento,
    caminhoLocal: caminhoLocal.present ? caminhoLocal.value : this.caminhoLocal,
    caminhoRemoto: caminhoRemoto.present
        ? caminhoRemoto.value
        : this.caminhoRemoto,
    lat: lat.present ? lat.value : this.lat,
    lon: lon.present ? lon.value : this.lon,
    tiradaEm: tiradaEm ?? this.tiradaEm,
    tamanhoBytes: tamanhoBytes.present ? tamanhoBytes.value : this.tamanhoBytes,
    uploadStatus: uploadStatus ?? this.uploadStatus,
    uploadErro: uploadErro.present ? uploadErro.value : this.uploadErro,
  );
  Midia copyWithCompanion(MidiasCompanion data) {
    return Midia(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
      id: data.id.present ? data.id.value : this.id,
      donoTipo: data.donoTipo.present ? data.donoTipo.value : this.donoTipo,
      donoId: data.donoId.present ? data.donoId.value : this.donoId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      momento: data.momento.present ? data.momento.value : this.momento,
      caminhoLocal: data.caminhoLocal.present
          ? data.caminhoLocal.value
          : this.caminhoLocal,
      caminhoRemoto: data.caminhoRemoto.present
          ? data.caminhoRemoto.value
          : this.caminhoRemoto,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      tiradaEm: data.tiradaEm.present ? data.tiradaEm.value : this.tiradaEm,
      tamanhoBytes: data.tamanhoBytes.present
          ? data.tamanhoBytes.value
          : this.tamanhoBytes,
      uploadStatus: data.uploadStatus.present
          ? data.uploadStatus.value
          : this.uploadStatus,
      uploadErro: data.uploadErro.present
          ? data.uploadErro.value
          : this.uploadErro,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Midia(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('donoTipo: $donoTipo, ')
          ..write('donoId: $donoId, ')
          ..write('tipo: $tipo, ')
          ..write('momento: $momento, ')
          ..write('caminhoLocal: $caminhoLocal, ')
          ..write('caminhoRemoto: $caminhoRemoto, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('tiradaEm: $tiradaEm, ')
          ..write('tamanhoBytes: $tamanhoBytes, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('uploadErro: $uploadErro')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    serverUpdatedAt,
    deleted,
    syncStatus,
    version,
    id,
    donoTipo,
    donoId,
    tipo,
    momento,
    caminhoLocal,
    caminhoRemoto,
    lat,
    lon,
    tiradaEm,
    tamanhoBytes,
    uploadStatus,
    uploadErro,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Midia &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deleted == this.deleted &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version &&
          other.id == this.id &&
          other.donoTipo == this.donoTipo &&
          other.donoId == this.donoId &&
          other.tipo == this.tipo &&
          other.momento == this.momento &&
          other.caminhoLocal == this.caminhoLocal &&
          other.caminhoRemoto == this.caminhoRemoto &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.tiradaEm == this.tiradaEm &&
          other.tamanhoBytes == this.tamanhoBytes &&
          other.uploadStatus == this.uploadStatus &&
          other.uploadErro == this.uploadErro);
}

class MidiasCompanion extends UpdateCompanion<Midia> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<bool> deleted;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<String> id;
  final Value<String> donoTipo;
  final Value<String> donoId;
  final Value<String> tipo;
  final Value<String?> momento;
  final Value<String?> caminhoLocal;
  final Value<String?> caminhoRemoto;
  final Value<double?> lat;
  final Value<double?> lon;
  final Value<DateTime> tiradaEm;
  final Value<int?> tamanhoBytes;
  final Value<String> uploadStatus;
  final Value<String?> uploadErro;
  final Value<int> rowid;
  const MidiasCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.id = const Value.absent(),
    this.donoTipo = const Value.absent(),
    this.donoId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.momento = const Value.absent(),
    this.caminhoLocal = const Value.absent(),
    this.caminhoRemoto = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.tiradaEm = const Value.absent(),
    this.tamanhoBytes = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.uploadErro = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MidiasCompanion.insert({
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverUpdatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    required String id,
    required String donoTipo,
    required String donoId,
    this.tipo = const Value.absent(),
    this.momento = const Value.absent(),
    this.caminhoLocal = const Value.absent(),
    this.caminhoRemoto = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    required DateTime tiradaEm,
    this.tamanhoBytes = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.uploadErro = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       id = Value(id),
       donoTipo = Value(donoTipo),
       donoId = Value(donoId),
       tiradaEm = Value(tiradaEm);
  static Insertable<Midia> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<bool>? deleted,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<String>? id,
    Expression<String>? donoTipo,
    Expression<String>? donoId,
    Expression<String>? tipo,
    Expression<String>? momento,
    Expression<String>? caminhoLocal,
    Expression<String>? caminhoRemoto,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<DateTime>? tiradaEm,
    Expression<int>? tamanhoBytes,
    Expression<String>? uploadStatus,
    Expression<String>? uploadErro,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deleted != null) 'deleted': deleted,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (id != null) 'id': id,
      if (donoTipo != null) 'dono_tipo': donoTipo,
      if (donoId != null) 'dono_id': donoId,
      if (tipo != null) 'tipo': tipo,
      if (momento != null) 'momento': momento,
      if (caminhoLocal != null) 'caminho_local': caminhoLocal,
      if (caminhoRemoto != null) 'caminho_remoto': caminhoRemoto,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (tiradaEm != null) 'tirada_em': tiradaEm,
      if (tamanhoBytes != null) 'tamanho_bytes': tamanhoBytes,
      if (uploadStatus != null) 'upload_status': uploadStatus,
      if (uploadErro != null) 'upload_erro': uploadErro,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MidiasCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? serverUpdatedAt,
    Value<bool>? deleted,
    Value<String>? syncStatus,
    Value<int>? version,
    Value<String>? id,
    Value<String>? donoTipo,
    Value<String>? donoId,
    Value<String>? tipo,
    Value<String?>? momento,
    Value<String?>? caminhoLocal,
    Value<String?>? caminhoRemoto,
    Value<double?>? lat,
    Value<double?>? lon,
    Value<DateTime>? tiradaEm,
    Value<int?>? tamanhoBytes,
    Value<String>? uploadStatus,
    Value<String?>? uploadErro,
    Value<int>? rowid,
  }) {
    return MidiasCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deleted: deleted ?? this.deleted,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      id: id ?? this.id,
      donoTipo: donoTipo ?? this.donoTipo,
      donoId: donoId ?? this.donoId,
      tipo: tipo ?? this.tipo,
      momento: momento ?? this.momento,
      caminhoLocal: caminhoLocal ?? this.caminhoLocal,
      caminhoRemoto: caminhoRemoto ?? this.caminhoRemoto,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      tiradaEm: tiradaEm ?? this.tiradaEm,
      tamanhoBytes: tamanhoBytes ?? this.tamanhoBytes,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      uploadErro: uploadErro ?? this.uploadErro,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (donoTipo.present) {
      map['dono_tipo'] = Variable<String>(donoTipo.value);
    }
    if (donoId.present) {
      map['dono_id'] = Variable<String>(donoId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (momento.present) {
      map['momento'] = Variable<String>(momento.value);
    }
    if (caminhoLocal.present) {
      map['caminho_local'] = Variable<String>(caminhoLocal.value);
    }
    if (caminhoRemoto.present) {
      map['caminho_remoto'] = Variable<String>(caminhoRemoto.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (tiradaEm.present) {
      map['tirada_em'] = Variable<DateTime>(tiradaEm.value);
    }
    if (tamanhoBytes.present) {
      map['tamanho_bytes'] = Variable<int>(tamanhoBytes.value);
    }
    if (uploadStatus.present) {
      map['upload_status'] = Variable<String>(uploadStatus.value);
    }
    if (uploadErro.present) {
      map['upload_erro'] = Variable<String>(uploadErro.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MidiasCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('id: $id, ')
          ..write('donoTipo: $donoTipo, ')
          ..write('donoId: $donoId, ')
          ..write('tipo: $tipo, ')
          ..write('momento: $momento, ')
          ..write('caminhoLocal: $caminhoLocal, ')
          ..write('caminhoRemoto: $caminhoRemoto, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('tiradaEm: $tiradaEm, ')
          ..write('tamanhoBytes: $tamanhoBytes, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('uploadErro: $uploadErro, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ListaValoresTable extends ListaValores
    with TableInfo<$ListaValoresTable, ListaValor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListaValoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _listaMeta = const VerificationMeta('lista');
  @override
  late final GeneratedColumn<String> lista = GeneratedColumn<String>(
    'lista',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotuloMeta = const VerificationMeta('rotulo');
  @override
  late final GeneratedColumn<String> rotulo = GeneratedColumn<String>(
    'rotulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [lista, codigo, rotulo, ordem, ativo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lista_valores';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListaValor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lista')) {
      context.handle(
        _listaMeta,
        lista.isAcceptableOrUnknown(data['lista']!, _listaMeta),
      );
    } else if (isInserting) {
      context.missing(_listaMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('rotulo')) {
      context.handle(
        _rotuloMeta,
        rotulo.isAcceptableOrUnknown(data['rotulo']!, _rotuloMeta),
      );
    } else if (isInserting) {
      context.missing(_rotuloMeta);
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    } else if (isInserting) {
      context.missing(_ordemMeta);
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lista, codigo};
  @override
  ListaValor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListaValor(
      lista: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lista'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      rotulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rotulo'],
      )!,
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
    );
  }

  @override
  $ListaValoresTable createAlias(String alias) {
    return $ListaValoresTable(attachedDatabase, alias);
  }
}

class ListaValor extends DataClass implements Insertable<ListaValor> {
  final String lista;
  final String codigo;
  final String rotulo;
  final int ordem;
  final bool ativo;
  const ListaValor({
    required this.lista,
    required this.codigo,
    required this.rotulo,
    required this.ordem,
    required this.ativo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lista'] = Variable<String>(lista);
    map['codigo'] = Variable<String>(codigo);
    map['rotulo'] = Variable<String>(rotulo);
    map['ordem'] = Variable<int>(ordem);
    map['ativo'] = Variable<bool>(ativo);
    return map;
  }

  ListaValoresCompanion toCompanion(bool nullToAbsent) {
    return ListaValoresCompanion(
      lista: Value(lista),
      codigo: Value(codigo),
      rotulo: Value(rotulo),
      ordem: Value(ordem),
      ativo: Value(ativo),
    );
  }

  factory ListaValor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListaValor(
      lista: serializer.fromJson<String>(json['lista']),
      codigo: serializer.fromJson<String>(json['codigo']),
      rotulo: serializer.fromJson<String>(json['rotulo']),
      ordem: serializer.fromJson<int>(json['ordem']),
      ativo: serializer.fromJson<bool>(json['ativo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lista': serializer.toJson<String>(lista),
      'codigo': serializer.toJson<String>(codigo),
      'rotulo': serializer.toJson<String>(rotulo),
      'ordem': serializer.toJson<int>(ordem),
      'ativo': serializer.toJson<bool>(ativo),
    };
  }

  ListaValor copyWith({
    String? lista,
    String? codigo,
    String? rotulo,
    int? ordem,
    bool? ativo,
  }) => ListaValor(
    lista: lista ?? this.lista,
    codigo: codigo ?? this.codigo,
    rotulo: rotulo ?? this.rotulo,
    ordem: ordem ?? this.ordem,
    ativo: ativo ?? this.ativo,
  );
  ListaValor copyWithCompanion(ListaValoresCompanion data) {
    return ListaValor(
      lista: data.lista.present ? data.lista.value : this.lista,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      rotulo: data.rotulo.present ? data.rotulo.value : this.rotulo,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListaValor(')
          ..write('lista: $lista, ')
          ..write('codigo: $codigo, ')
          ..write('rotulo: $rotulo, ')
          ..write('ordem: $ordem, ')
          ..write('ativo: $ativo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lista, codigo, rotulo, ordem, ativo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListaValor &&
          other.lista == this.lista &&
          other.codigo == this.codigo &&
          other.rotulo == this.rotulo &&
          other.ordem == this.ordem &&
          other.ativo == this.ativo);
}

class ListaValoresCompanion extends UpdateCompanion<ListaValor> {
  final Value<String> lista;
  final Value<String> codigo;
  final Value<String> rotulo;
  final Value<int> ordem;
  final Value<bool> ativo;
  final Value<int> rowid;
  const ListaValoresCompanion({
    this.lista = const Value.absent(),
    this.codigo = const Value.absent(),
    this.rotulo = const Value.absent(),
    this.ordem = const Value.absent(),
    this.ativo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListaValoresCompanion.insert({
    required String lista,
    required String codigo,
    required String rotulo,
    required int ordem,
    this.ativo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : lista = Value(lista),
       codigo = Value(codigo),
       rotulo = Value(rotulo),
       ordem = Value(ordem);
  static Insertable<ListaValor> custom({
    Expression<String>? lista,
    Expression<String>? codigo,
    Expression<String>? rotulo,
    Expression<int>? ordem,
    Expression<bool>? ativo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lista != null) 'lista': lista,
      if (codigo != null) 'codigo': codigo,
      if (rotulo != null) 'rotulo': rotulo,
      if (ordem != null) 'ordem': ordem,
      if (ativo != null) 'ativo': ativo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListaValoresCompanion copyWith({
    Value<String>? lista,
    Value<String>? codigo,
    Value<String>? rotulo,
    Value<int>? ordem,
    Value<bool>? ativo,
    Value<int>? rowid,
  }) {
    return ListaValoresCompanion(
      lista: lista ?? this.lista,
      codigo: codigo ?? this.codigo,
      rotulo: rotulo ?? this.rotulo,
      ordem: ordem ?? this.ordem,
      ativo: ativo ?? this.ativo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lista.present) {
      map['lista'] = Variable<String>(lista.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (rotulo.present) {
      map['rotulo'] = Variable<String>(rotulo.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListaValoresCompanion(')
          ..write('lista: $lista, ')
          ..write('codigo: $codigo, ')
          ..write('rotulo: $rotulo, ')
          ..write('ordem: $ordem, ')
          ..write('ativo: $ativo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConfigsTable extends Configs with TableInfo<$ConfigsTable, Config> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chaveMeta = const VerificationMeta('chave');
  @override
  late final GeneratedColumn<String> chave = GeneratedColumn<String>(
    'chave',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [chave, valor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Config> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chave')) {
      context.handle(
        _chaveMeta,
        chave.isAcceptableOrUnknown(data['chave']!, _chaveMeta),
      );
    } else if (isInserting) {
      context.missing(_chaveMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chave};
  @override
  Config map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Config(
      chave: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chave'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valor'],
      )!,
    );
  }

  @override
  $ConfigsTable createAlias(String alias) {
    return $ConfigsTable(attachedDatabase, alias);
  }
}

class Config extends DataClass implements Insertable<Config> {
  final String chave;
  final String valor;
  const Config({required this.chave, required this.valor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chave'] = Variable<String>(chave);
    map['valor'] = Variable<String>(valor);
    return map;
  }

  ConfigsCompanion toCompanion(bool nullToAbsent) {
    return ConfigsCompanion(chave: Value(chave), valor: Value(valor));
  }

  factory Config.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Config(
      chave: serializer.fromJson<String>(json['chave']),
      valor: serializer.fromJson<String>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chave': serializer.toJson<String>(chave),
      'valor': serializer.toJson<String>(valor),
    };
  }

  Config copyWith({String? chave, String? valor}) =>
      Config(chave: chave ?? this.chave, valor: valor ?? this.valor);
  Config copyWithCompanion(ConfigsCompanion data) {
    return Config(
      chave: data.chave.present ? data.chave.value : this.chave,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Config(')
          ..write('chave: $chave, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(chave, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Config &&
          other.chave == this.chave &&
          other.valor == this.valor);
}

class ConfigsCompanion extends UpdateCompanion<Config> {
  final Value<String> chave;
  final Value<String> valor;
  final Value<int> rowid;
  const ConfigsCompanion({
    this.chave = const Value.absent(),
    this.valor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConfigsCompanion.insert({
    required String chave,
    required String valor,
    this.rowid = const Value.absent(),
  }) : chave = Value(chave),
       valor = Value(valor);
  static Insertable<Config> custom({
    Expression<String>? chave,
    Expression<String>? valor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chave != null) 'chave': chave,
      if (valor != null) 'valor': valor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConfigsCompanion copyWith({
    Value<String>? chave,
    Value<String>? valor,
    Value<int>? rowid,
  }) {
    return ConfigsCompanion(
      chave: chave ?? this.chave,
      valor: valor ?? this.valor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chave.present) {
      map['chave'] = Variable<String>(chave.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfigsCompanion(')
          ..write('chave: $chave, ')
          ..write('valor: $valor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ErrosSyncTable extends ErrosSync
    with TableInfo<$ErrosSyncTable, ErroSync> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ErrosSyncTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tabelaMeta = const VerificationMeta('tabela');
  @override
  late final GeneratedColumn<String> tabela = GeneratedColumn<String>(
    'tabela',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registroIdMeta = const VerificationMeta(
    'registroId',
  );
  @override
  late final GeneratedColumn<String> registroId = GeneratedColumn<String>(
    'registro_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mensagemMeta = const VerificationMeta(
    'mensagem',
  );
  @override
  late final GeneratedColumn<String> mensagem = GeneratedColumn<String>(
    'mensagem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tentativasMeta = const VerificationMeta(
    'tentativas',
  );
  @override
  late final GeneratedColumn<int> tentativas = GeneratedColumn<int>(
    'tentativas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _ultimaTentativaMeta = const VerificationMeta(
    'ultimaTentativa',
  );
  @override
  late final GeneratedColumn<DateTime> ultimaTentativa =
      GeneratedColumn<DateTime>(
        'ultima_tentativa',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    tabela,
    registroId,
    mensagem,
    tentativas,
    ultimaTentativa,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'erros_sync';
  @override
  VerificationContext validateIntegrity(
    Insertable<ErroSync> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tabela')) {
      context.handle(
        _tabelaMeta,
        tabela.isAcceptableOrUnknown(data['tabela']!, _tabelaMeta),
      );
    } else if (isInserting) {
      context.missing(_tabelaMeta);
    }
    if (data.containsKey('registro_id')) {
      context.handle(
        _registroIdMeta,
        registroId.isAcceptableOrUnknown(data['registro_id']!, _registroIdMeta),
      );
    } else if (isInserting) {
      context.missing(_registroIdMeta);
    }
    if (data.containsKey('mensagem')) {
      context.handle(
        _mensagemMeta,
        mensagem.isAcceptableOrUnknown(data['mensagem']!, _mensagemMeta),
      );
    } else if (isInserting) {
      context.missing(_mensagemMeta);
    }
    if (data.containsKey('tentativas')) {
      context.handle(
        _tentativasMeta,
        tentativas.isAcceptableOrUnknown(data['tentativas']!, _tentativasMeta),
      );
    }
    if (data.containsKey('ultima_tentativa')) {
      context.handle(
        _ultimaTentativaMeta,
        ultimaTentativa.isAcceptableOrUnknown(
          data['ultima_tentativa']!,
          _ultimaTentativaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ultimaTentativaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tabela, registroId};
  @override
  ErroSync map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ErroSync(
      tabela: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tabela'],
      )!,
      registroId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registro_id'],
      )!,
      mensagem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mensagem'],
      )!,
      tentativas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tentativas'],
      )!,
      ultimaTentativa: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ultima_tentativa'],
      )!,
    );
  }

  @override
  $ErrosSyncTable createAlias(String alias) {
    return $ErrosSyncTable(attachedDatabase, alias);
  }
}

class ErroSync extends DataClass implements Insertable<ErroSync> {
  final String tabela;
  final String registroId;
  final String mensagem;
  final int tentativas;
  final DateTime ultimaTentativa;
  const ErroSync({
    required this.tabela,
    required this.registroId,
    required this.mensagem,
    required this.tentativas,
    required this.ultimaTentativa,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tabela'] = Variable<String>(tabela);
    map['registro_id'] = Variable<String>(registroId);
    map['mensagem'] = Variable<String>(mensagem);
    map['tentativas'] = Variable<int>(tentativas);
    map['ultima_tentativa'] = Variable<DateTime>(ultimaTentativa);
    return map;
  }

  ErrosSyncCompanion toCompanion(bool nullToAbsent) {
    return ErrosSyncCompanion(
      tabela: Value(tabela),
      registroId: Value(registroId),
      mensagem: Value(mensagem),
      tentativas: Value(tentativas),
      ultimaTentativa: Value(ultimaTentativa),
    );
  }

  factory ErroSync.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ErroSync(
      tabela: serializer.fromJson<String>(json['tabela']),
      registroId: serializer.fromJson<String>(json['registroId']),
      mensagem: serializer.fromJson<String>(json['mensagem']),
      tentativas: serializer.fromJson<int>(json['tentativas']),
      ultimaTentativa: serializer.fromJson<DateTime>(json['ultimaTentativa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tabela': serializer.toJson<String>(tabela),
      'registroId': serializer.toJson<String>(registroId),
      'mensagem': serializer.toJson<String>(mensagem),
      'tentativas': serializer.toJson<int>(tentativas),
      'ultimaTentativa': serializer.toJson<DateTime>(ultimaTentativa),
    };
  }

  ErroSync copyWith({
    String? tabela,
    String? registroId,
    String? mensagem,
    int? tentativas,
    DateTime? ultimaTentativa,
  }) => ErroSync(
    tabela: tabela ?? this.tabela,
    registroId: registroId ?? this.registroId,
    mensagem: mensagem ?? this.mensagem,
    tentativas: tentativas ?? this.tentativas,
    ultimaTentativa: ultimaTentativa ?? this.ultimaTentativa,
  );
  ErroSync copyWithCompanion(ErrosSyncCompanion data) {
    return ErroSync(
      tabela: data.tabela.present ? data.tabela.value : this.tabela,
      registroId: data.registroId.present
          ? data.registroId.value
          : this.registroId,
      mensagem: data.mensagem.present ? data.mensagem.value : this.mensagem,
      tentativas: data.tentativas.present
          ? data.tentativas.value
          : this.tentativas,
      ultimaTentativa: data.ultimaTentativa.present
          ? data.ultimaTentativa.value
          : this.ultimaTentativa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ErroSync(')
          ..write('tabela: $tabela, ')
          ..write('registroId: $registroId, ')
          ..write('mensagem: $mensagem, ')
          ..write('tentativas: $tentativas, ')
          ..write('ultimaTentativa: $ultimaTentativa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tabela, registroId, mensagem, tentativas, ultimaTentativa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ErroSync &&
          other.tabela == this.tabela &&
          other.registroId == this.registroId &&
          other.mensagem == this.mensagem &&
          other.tentativas == this.tentativas &&
          other.ultimaTentativa == this.ultimaTentativa);
}

class ErrosSyncCompanion extends UpdateCompanion<ErroSync> {
  final Value<String> tabela;
  final Value<String> registroId;
  final Value<String> mensagem;
  final Value<int> tentativas;
  final Value<DateTime> ultimaTentativa;
  final Value<int> rowid;
  const ErrosSyncCompanion({
    this.tabela = const Value.absent(),
    this.registroId = const Value.absent(),
    this.mensagem = const Value.absent(),
    this.tentativas = const Value.absent(),
    this.ultimaTentativa = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ErrosSyncCompanion.insert({
    required String tabela,
    required String registroId,
    required String mensagem,
    this.tentativas = const Value.absent(),
    required DateTime ultimaTentativa,
    this.rowid = const Value.absent(),
  }) : tabela = Value(tabela),
       registroId = Value(registroId),
       mensagem = Value(mensagem),
       ultimaTentativa = Value(ultimaTentativa);
  static Insertable<ErroSync> custom({
    Expression<String>? tabela,
    Expression<String>? registroId,
    Expression<String>? mensagem,
    Expression<int>? tentativas,
    Expression<DateTime>? ultimaTentativa,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tabela != null) 'tabela': tabela,
      if (registroId != null) 'registro_id': registroId,
      if (mensagem != null) 'mensagem': mensagem,
      if (tentativas != null) 'tentativas': tentativas,
      if (ultimaTentativa != null) 'ultima_tentativa': ultimaTentativa,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ErrosSyncCompanion copyWith({
    Value<String>? tabela,
    Value<String>? registroId,
    Value<String>? mensagem,
    Value<int>? tentativas,
    Value<DateTime>? ultimaTentativa,
    Value<int>? rowid,
  }) {
    return ErrosSyncCompanion(
      tabela: tabela ?? this.tabela,
      registroId: registroId ?? this.registroId,
      mensagem: mensagem ?? this.mensagem,
      tentativas: tentativas ?? this.tentativas,
      ultimaTentativa: ultimaTentativa ?? this.ultimaTentativa,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tabela.present) {
      map['tabela'] = Variable<String>(tabela.value);
    }
    if (registroId.present) {
      map['registro_id'] = Variable<String>(registroId.value);
    }
    if (mensagem.present) {
      map['mensagem'] = Variable<String>(mensagem.value);
    }
    if (tentativas.present) {
      map['tentativas'] = Variable<int>(tentativas.value);
    }
    if (ultimaTentativa.present) {
      map['ultima_tentativa'] = Variable<DateTime>(ultimaTentativa.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ErrosSyncCompanion(')
          ..write('tabela: $tabela, ')
          ..write('registroId: $registroId, ')
          ..write('mensagem: $mensagem, ')
          ..write('tentativas: $tentativas, ')
          ..write('ultimaTentativa: $ultimaTentativa, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $EspeciesTable especies = $EspeciesTable(this);
  late final $FocosTable focos = $FocosTable(this);
  late final $ObservacoesTable observacoes = $ObservacoesTable(this);
  late final $AcoesManejoTable acoesManejo = $AcoesManejoTable(this);
  late final $MidiasTable midias = $MidiasTable(this);
  late final $ListaValoresTable listaValores = $ListaValoresTable(this);
  late final $ConfigsTable configs = $ConfigsTable(this);
  late final $ErrosSyncTable errosSync = $ErrosSyncTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    usuarios,
    especies,
    focos,
    observacoes,
    acoesManejo,
    midias,
    listaValores,
    configs,
    errosSync,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$UsuariosTableCreateCompanionBuilder = UsuariosCompanion Function({
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> deleted,
  Value<String> syncStatus,
  Value<int> version,
  required String id,
  required String nome,
  required String email,
  required String perfil,
  Value<String?> funcao,
  Value<bool> ativo,
  Value<int> rowid,
});
typedef $$UsuariosTableUpdateCompanionBuilder = UsuariosCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> deleted,
  Value<String> syncStatus,
  Value<int> version,
  Value<String> id,
  Value<String> nome,
  Value<String> email,
  Value<String> perfil,
  Value<String?> funcao,
  Value<bool> ativo,
  Value<int> rowid,
});

class $$UsuariosTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get perfil => $composableBuilder(
    column: $table.perfil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get funcao => $composableBuilder(
    column: $table.funcao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get perfil => $composableBuilder(
    column: $table.perfil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get funcao => $composableBuilder(
    column: $table.funcao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get perfil =>
      $composableBuilder(column: $table.perfil, builder: (column) => column);

  GeneratedColumn<String> get funcao =>
      $composableBuilder(column: $table.funcao, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);
}

class $$UsuariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsuariosTable,
          Usuario,
          $$UsuariosTableFilterComposer,
          $$UsuariosTableOrderingComposer,
          $$UsuariosTableAnnotationComposer,
          $$UsuariosTableCreateCompanionBuilder,
          $$UsuariosTableUpdateCompanionBuilder,
          (Usuario, BaseReferences<_$AppDatabase, $UsuariosTable, Usuario>),
          Usuario,
          PrefetchHooks Function()
        > {
  $$UsuariosTableTableManager(_$AppDatabase db, $UsuariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> perfil = const Value.absent(),
                Value<String?> funcao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsuariosCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                nome: nome,
                email: email,
                perfil: perfil,
                funcao: funcao,
                ativo: ativo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String id,
                required String nome,
                required String email,
                required String perfil,
                Value<String?> funcao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsuariosCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                nome: nome,
                email: email,
                perfil: perfil,
                funcao: funcao,
                ativo: ativo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsuariosTable, Usuario>(table),
                  BaseReferences<_$AppDatabase, $UsuariosTable, Usuario>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsuariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsuariosTable,
      Usuario,
      $$UsuariosTableFilterComposer,
      $$UsuariosTableOrderingComposer,
      $$UsuariosTableAnnotationComposer,
      $$UsuariosTableCreateCompanionBuilder,
      $$UsuariosTableUpdateCompanionBuilder,
      (Usuario, BaseReferences<_$AppDatabase, $UsuariosTable, Usuario>),
      Usuario,
      PrefetchHooks Function()
    >;
typedef $$EspeciesTableCreateCompanionBuilder = EspeciesCompanion Function({
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> deleted,
  Value<String> syncStatus,
  Value<int> version,
  required String id,
  required String prefixo,
  required String nomeCientifico,
  required List<String> nomesPopulares,
  Value<String?> familia,
  required String formaVida,
  Value<String?> descricaoIdentificacao,
  Value<String?> confusaoCom,
  Value<String?> controleCitado,
  required List<String> metodosSugeridos,
  required List<String> fotosReferencia,
  Value<int?> prioridade,
  Value<bool?> naListaOficialIcmbio,
  Value<bool> ativa,
  Value<int> ordem,
  Value<int> rowid,
});
typedef $$EspeciesTableUpdateCompanionBuilder = EspeciesCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> deleted,
  Value<String> syncStatus,
  Value<int> version,
  Value<String> id,
  Value<String> prefixo,
  Value<String> nomeCientifico,
  Value<List<String>> nomesPopulares,
  Value<String?> familia,
  Value<String> formaVida,
  Value<String?> descricaoIdentificacao,
  Value<String?> confusaoCom,
  Value<String?> controleCitado,
  Value<List<String>> metodosSugeridos,
  Value<List<String>> fotosReferencia,
  Value<int?> prioridade,
  Value<bool?> naListaOficialIcmbio,
  Value<bool> ativa,
  Value<int> ordem,
  Value<int> rowid,
});

final class $$EspeciesTableReferences
    extends BaseReferences<_$AppDatabase, $EspeciesTable, Especie> {
  $$EspeciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FocosTable, List<Foco>> _focosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.focos,
    aliasName: 'especies__id__focos__especie_id',
  );

  $$FocosTableProcessedTableManager get focosRefs {
    final manager = $$FocosTableTableManager(
      $_db,
      $_db.focos,
    ).filter((f) => f.especieId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_focosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EspeciesTableFilterComposer
    extends Composer<_$AppDatabase, $EspeciesTable> {
  $$EspeciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prefixo => $composableBuilder(
    column: $table.prefixo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomeCientifico => $composableBuilder(
    column: $table.nomeCientifico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get nomesPopulares => $composableBuilder(
    column: $table.nomesPopulares,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get familia => $composableBuilder(
    column: $table.familia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formaVida => $composableBuilder(
    column: $table.formaVida,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricaoIdentificacao => $composableBuilder(
    column: $table.descricaoIdentificacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confusaoCom => $composableBuilder(
    column: $table.confusaoCom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get controleCitado => $composableBuilder(
    column: $table.controleCitado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get metodosSugeridos => $composableBuilder(
    column: $table.metodosSugeridos,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get fotosReferencia => $composableBuilder(
    column: $table.fotosReferencia,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get prioridade => $composableBuilder(
    column: $table.prioridade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get naListaOficialIcmbio => $composableBuilder(
    column: $table.naListaOficialIcmbio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativa => $composableBuilder(
    column: $table.ativa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> focosRefs(
    Expression<bool> Function($$FocosTableFilterComposer f) f,
  ) {
    final $$FocosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focos,
      getReferencedColumn: (t) => t.especieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocosTableFilterComposer(
            $db: $db,
            $table: $db.focos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EspeciesTableOrderingComposer
    extends Composer<_$AppDatabase, $EspeciesTable> {
  $$EspeciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prefixo => $composableBuilder(
    column: $table.prefixo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomeCientifico => $composableBuilder(
    column: $table.nomeCientifico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomesPopulares => $composableBuilder(
    column: $table.nomesPopulares,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familia => $composableBuilder(
    column: $table.familia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formaVida => $composableBuilder(
    column: $table.formaVida,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricaoIdentificacao => $composableBuilder(
    column: $table.descricaoIdentificacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confusaoCom => $composableBuilder(
    column: $table.confusaoCom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get controleCitado => $composableBuilder(
    column: $table.controleCitado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodosSugeridos => $composableBuilder(
    column: $table.metodosSugeridos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotosReferencia => $composableBuilder(
    column: $table.fotosReferencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prioridade => $composableBuilder(
    column: $table.prioridade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get naListaOficialIcmbio => $composableBuilder(
    column: $table.naListaOficialIcmbio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativa => $composableBuilder(
    column: $table.ativa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EspeciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EspeciesTable> {
  $$EspeciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get prefixo =>
      $composableBuilder(column: $table.prefixo, builder: (column) => column);

  GeneratedColumn<String> get nomeCientifico => $composableBuilder(
    column: $table.nomeCientifico,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get nomesPopulares =>
      $composableBuilder(
        column: $table.nomesPopulares,
        builder: (column) => column,
      );

  GeneratedColumn<String> get familia =>
      $composableBuilder(column: $table.familia, builder: (column) => column);

  GeneratedColumn<String> get formaVida =>
      $composableBuilder(column: $table.formaVida, builder: (column) => column);

  GeneratedColumn<String> get descricaoIdentificacao => $composableBuilder(
    column: $table.descricaoIdentificacao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confusaoCom => $composableBuilder(
    column: $table.confusaoCom,
    builder: (column) => column,
  );

  GeneratedColumn<String> get controleCitado => $composableBuilder(
    column: $table.controleCitado,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get metodosSugeridos =>
      $composableBuilder(
        column: $table.metodosSugeridos,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get fotosReferencia =>
      $composableBuilder(
        column: $table.fotosReferencia,
        builder: (column) => column,
      );

  GeneratedColumn<int> get prioridade => $composableBuilder(
    column: $table.prioridade,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get naListaOficialIcmbio => $composableBuilder(
    column: $table.naListaOficialIcmbio,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ativa =>
      $composableBuilder(column: $table.ativa, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  Expression<T> focosRefs<T extends Object>(
    Expression<T> Function($$FocosTableAnnotationComposer a) f,
  ) {
    final $$FocosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focos,
      getReferencedColumn: (t) => t.especieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocosTableAnnotationComposer(
            $db: $db,
            $table: $db.focos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EspeciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EspeciesTable,
          Especie,
          $$EspeciesTableFilterComposer,
          $$EspeciesTableOrderingComposer,
          $$EspeciesTableAnnotationComposer,
          $$EspeciesTableCreateCompanionBuilder,
          $$EspeciesTableUpdateCompanionBuilder,
          (Especie, $$EspeciesTableReferences),
          Especie,
          PrefetchHooks Function({bool focosRefs})
        > {
  $$EspeciesTableTableManager(_$AppDatabase db, $EspeciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EspeciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EspeciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EspeciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> prefixo = const Value.absent(),
                Value<String> nomeCientifico = const Value.absent(),
                Value<List<String>> nomesPopulares = const Value.absent(),
                Value<String?> familia = const Value.absent(),
                Value<String> formaVida = const Value.absent(),
                Value<String?> descricaoIdentificacao = const Value.absent(),
                Value<String?> confusaoCom = const Value.absent(),
                Value<String?> controleCitado = const Value.absent(),
                Value<List<String>> metodosSugeridos = const Value.absent(),
                Value<List<String>> fotosReferencia = const Value.absent(),
                Value<int?> prioridade = const Value.absent(),
                Value<bool?> naListaOficialIcmbio = const Value.absent(),
                Value<bool> ativa = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EspeciesCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                prefixo: prefixo,
                nomeCientifico: nomeCientifico,
                nomesPopulares: nomesPopulares,
                familia: familia,
                formaVida: formaVida,
                descricaoIdentificacao: descricaoIdentificacao,
                confusaoCom: confusaoCom,
                controleCitado: controleCitado,
                metodosSugeridos: metodosSugeridos,
                fotosReferencia: fotosReferencia,
                prioridade: prioridade,
                naListaOficialIcmbio: naListaOficialIcmbio,
                ativa: ativa,
                ordem: ordem,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String id,
                required String prefixo,
                required String nomeCientifico,
                required List<String> nomesPopulares,
                Value<String?> familia = const Value.absent(),
                required String formaVida,
                Value<String?> descricaoIdentificacao = const Value.absent(),
                Value<String?> confusaoCom = const Value.absent(),
                Value<String?> controleCitado = const Value.absent(),
                required List<String> metodosSugeridos,
                required List<String> fotosReferencia,
                Value<int?> prioridade = const Value.absent(),
                Value<bool?> naListaOficialIcmbio = const Value.absent(),
                Value<bool> ativa = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EspeciesCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                prefixo: prefixo,
                nomeCientifico: nomeCientifico,
                nomesPopulares: nomesPopulares,
                familia: familia,
                formaVida: formaVida,
                descricaoIdentificacao: descricaoIdentificacao,
                confusaoCom: confusaoCom,
                controleCitado: controleCitado,
                metodosSugeridos: metodosSugeridos,
                fotosReferencia: fotosReferencia,
                prioridade: prioridade,
                naListaOficialIcmbio: naListaOficialIcmbio,
                ativa: ativa,
                ordem: ordem,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EspeciesTable, Especie>(table),
                  $$EspeciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({focosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (focosRefs) db.focos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (focosRefs)
                    await $_getPrefetchedData<Especie, $EspeciesTable, Foco>(
                      currentTable: table,
                      referencedTable: $$EspeciesTableReferences
                          ._focosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EspeciesTableReferences(db, table, p0).focosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.especieId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EspeciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EspeciesTable,
      Especie,
      $$EspeciesTableFilterComposer,
      $$EspeciesTableOrderingComposer,
      $$EspeciesTableAnnotationComposer,
      $$EspeciesTableCreateCompanionBuilder,
      $$EspeciesTableUpdateCompanionBuilder,
      (Especie, $$EspeciesTableReferences),
      Especie,
      PrefetchHooks Function({bool focosRefs})
    >;
typedef $$FocosTableCreateCompanionBuilder = FocosCompanion Function({
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> deleted,
  Value<String> syncStatus,
  Value<int> version,
  required String id,
  required String especieId,
  Value<String?> especieTexto,
  required String codigo,
  required double lat,
  required double lon,
  Value<double?> precisaoM,
  required String origemCoordenada,
  Value<String?> zona,
  Value<String?> ambiente,
  required String status,
  Value<bool> statusManual,
  Value<String?> statusAlteradoPor,
  Value<DateTime?> statusAlteradoEm,
  Value<bool> deteccaoPrecoce,
  Value<List<String>> motivosPrecoce,
  Value<bool> foraDoLimite,
  required String criadoPor,
  required DateTime primeiraDeteccaoEm,
  required DateTime ultimaVisitaEm,
  Value<String?> ultimaAbundancia,
  Value<int> rowid,
});
typedef $$FocosTableUpdateCompanionBuilder = FocosCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> deleted,
  Value<String> syncStatus,
  Value<int> version,
  Value<String> id,
  Value<String> especieId,
  Value<String?> especieTexto,
  Value<String> codigo,
  Value<double> lat,
  Value<double> lon,
  Value<double?> precisaoM,
  Value<String> origemCoordenada,
  Value<String?> zona,
  Value<String?> ambiente,
  Value<String> status,
  Value<bool> statusManual,
  Value<String?> statusAlteradoPor,
  Value<DateTime?> statusAlteradoEm,
  Value<bool> deteccaoPrecoce,
  Value<List<String>> motivosPrecoce,
  Value<bool> foraDoLimite,
  Value<String> criadoPor,
  Value<DateTime> primeiraDeteccaoEm,
  Value<DateTime> ultimaVisitaEm,
  Value<String?> ultimaAbundancia,
  Value<int> rowid,
});

final class $$FocosTableReferences
    extends BaseReferences<_$AppDatabase, $FocosTable, Foco> {
  $$FocosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EspeciesTable _especieIdTable(_$AppDatabase db) =>
      db.especies.createAlias('focos__especie_id__especies__id');

  $$EspeciesTableProcessedTableManager get especieId {
    final $_column = $_itemColumn<String>('especie_id')!;

    final manager = $$EspeciesTableTableManager(
      $_db,
      $_db.especies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_especieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ObservacoesTable, List<Observacao>>
  _observacoesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.observacoes,
    aliasName: 'focos__id__observacoes__foco_id',
  );

  $$ObservacoesTableProcessedTableManager get observacoesRefs {
    final manager = $$ObservacoesTableTableManager(
      $_db,
      $_db.observacoes,
    ).filter((f) => f.focoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_observacoesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AcoesManejoTable, List<AcaoManejo>>
  _acoesManejoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.acoesManejo,
    aliasName: 'focos__id__acoes_manejo__foco_id',
  );

  $$AcoesManejoTableProcessedTableManager get acoesManejoRefs {
    final manager = $$AcoesManejoTableTableManager(
      $_db,
      $_db.acoesManejo,
    ).filter((f) => f.focoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_acoesManejoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FocosTableFilterComposer extends Composer<_$AppDatabase, $FocosTable> {
  $$FocosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get especieTexto => $composableBuilder(
    column: $table.especieTexto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precisaoM => $composableBuilder(
    column: $table.precisaoM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origemCoordenada => $composableBuilder(
    column: $table.origemCoordenada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zona => $composableBuilder(
    column: $table.zona,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ambiente => $composableBuilder(
    column: $table.ambiente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get statusManual => $composableBuilder(
    column: $table.statusManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusAlteradoPor => $composableBuilder(
    column: $table.statusAlteradoPor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get statusAlteradoEm => $composableBuilder(
    column: $table.statusAlteradoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deteccaoPrecoce => $composableBuilder(
    column: $table.deteccaoPrecoce,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get motivosPrecoce => $composableBuilder(
    column: $table.motivosPrecoce,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get foraDoLimite => $composableBuilder(
    column: $table.foraDoLimite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get criadoPor => $composableBuilder(
    column: $table.criadoPor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get primeiraDeteccaoEm => $composableBuilder(
    column: $table.primeiraDeteccaoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ultimaVisitaEm => $composableBuilder(
    column: $table.ultimaVisitaEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ultimaAbundancia => $composableBuilder(
    column: $table.ultimaAbundancia,
    builder: (column) => ColumnFilters(column),
  );

  $$EspeciesTableFilterComposer get especieId {
    final $$EspeciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableFilterComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> observacoesRefs(
    Expression<bool> Function($$ObservacoesTableFilterComposer f) f,
  ) {
    final $$ObservacoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.observacoes,
      getReferencedColumn: (t) => t.focoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObservacoesTableFilterComposer(
            $db: $db,
            $table: $db.observacoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> acoesManejoRefs(
    Expression<bool> Function($$AcoesManejoTableFilterComposer f) f,
  ) {
    final $$AcoesManejoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.acoesManejo,
      getReferencedColumn: (t) => t.focoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AcoesManejoTableFilterComposer(
            $db: $db,
            $table: $db.acoesManejo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FocosTableOrderingComposer
    extends Composer<_$AppDatabase, $FocosTable> {
  $$FocosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get especieTexto => $composableBuilder(
    column: $table.especieTexto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precisaoM => $composableBuilder(
    column: $table.precisaoM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origemCoordenada => $composableBuilder(
    column: $table.origemCoordenada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zona => $composableBuilder(
    column: $table.zona,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ambiente => $composableBuilder(
    column: $table.ambiente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get statusManual => $composableBuilder(
    column: $table.statusManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusAlteradoPor => $composableBuilder(
    column: $table.statusAlteradoPor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get statusAlteradoEm => $composableBuilder(
    column: $table.statusAlteradoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deteccaoPrecoce => $composableBuilder(
    column: $table.deteccaoPrecoce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivosPrecoce => $composableBuilder(
    column: $table.motivosPrecoce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get foraDoLimite => $composableBuilder(
    column: $table.foraDoLimite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get criadoPor => $composableBuilder(
    column: $table.criadoPor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get primeiraDeteccaoEm => $composableBuilder(
    column: $table.primeiraDeteccaoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ultimaVisitaEm => $composableBuilder(
    column: $table.ultimaVisitaEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ultimaAbundancia => $composableBuilder(
    column: $table.ultimaAbundancia,
    builder: (column) => ColumnOrderings(column),
  );

  $$EspeciesTableOrderingComposer get especieId {
    final $$EspeciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableOrderingComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocosTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocosTable> {
  $$FocosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get especieTexto => $composableBuilder(
    column: $table.especieTexto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<double> get precisaoM =>
      $composableBuilder(column: $table.precisaoM, builder: (column) => column);

  GeneratedColumn<String> get origemCoordenada => $composableBuilder(
    column: $table.origemCoordenada,
    builder: (column) => column,
  );

  GeneratedColumn<String> get zona =>
      $composableBuilder(column: $table.zona, builder: (column) => column);

  GeneratedColumn<String> get ambiente =>
      $composableBuilder(column: $table.ambiente, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get statusManual => $composableBuilder(
    column: $table.statusManual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statusAlteradoPor => $composableBuilder(
    column: $table.statusAlteradoPor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get statusAlteradoEm => $composableBuilder(
    column: $table.statusAlteradoEm,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deteccaoPrecoce => $composableBuilder(
    column: $table.deteccaoPrecoce,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get motivosPrecoce =>
      $composableBuilder(
        column: $table.motivosPrecoce,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get foraDoLimite => $composableBuilder(
    column: $table.foraDoLimite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get criadoPor =>
      $composableBuilder(column: $table.criadoPor, builder: (column) => column);

  GeneratedColumn<DateTime> get primeiraDeteccaoEm => $composableBuilder(
    column: $table.primeiraDeteccaoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get ultimaVisitaEm => $composableBuilder(
    column: $table.ultimaVisitaEm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ultimaAbundancia => $composableBuilder(
    column: $table.ultimaAbundancia,
    builder: (column) => column,
  );

  $$EspeciesTableAnnotationComposer get especieId {
    final $$EspeciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableAnnotationComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> observacoesRefs<T extends Object>(
    Expression<T> Function($$ObservacoesTableAnnotationComposer a) f,
  ) {
    final $$ObservacoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.observacoes,
      getReferencedColumn: (t) => t.focoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObservacoesTableAnnotationComposer(
            $db: $db,
            $table: $db.observacoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> acoesManejoRefs<T extends Object>(
    Expression<T> Function($$AcoesManejoTableAnnotationComposer a) f,
  ) {
    final $$AcoesManejoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.acoesManejo,
      getReferencedColumn: (t) => t.focoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AcoesManejoTableAnnotationComposer(
            $db: $db,
            $table: $db.acoesManejo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FocosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocosTable,
          Foco,
          $$FocosTableFilterComposer,
          $$FocosTableOrderingComposer,
          $$FocosTableAnnotationComposer,
          $$FocosTableCreateCompanionBuilder,
          $$FocosTableUpdateCompanionBuilder,
          (Foco, $$FocosTableReferences),
          Foco,
          PrefetchHooks Function({
            bool especieId,
            bool observacoesRefs,
            bool acoesManejoRefs,
          })
        > {
  $$FocosTableTableManager(_$AppDatabase db, $FocosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> especieId = const Value.absent(),
                Value<String?> especieTexto = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<double?> precisaoM = const Value.absent(),
                Value<String> origemCoordenada = const Value.absent(),
                Value<String?> zona = const Value.absent(),
                Value<String?> ambiente = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> statusManual = const Value.absent(),
                Value<String?> statusAlteradoPor = const Value.absent(),
                Value<DateTime?> statusAlteradoEm = const Value.absent(),
                Value<bool> deteccaoPrecoce = const Value.absent(),
                Value<List<String>> motivosPrecoce = const Value.absent(),
                Value<bool> foraDoLimite = const Value.absent(),
                Value<String> criadoPor = const Value.absent(),
                Value<DateTime> primeiraDeteccaoEm = const Value.absent(),
                Value<DateTime> ultimaVisitaEm = const Value.absent(),
                Value<String?> ultimaAbundancia = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocosCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                especieId: especieId,
                especieTexto: especieTexto,
                codigo: codigo,
                lat: lat,
                lon: lon,
                precisaoM: precisaoM,
                origemCoordenada: origemCoordenada,
                zona: zona,
                ambiente: ambiente,
                status: status,
                statusManual: statusManual,
                statusAlteradoPor: statusAlteradoPor,
                statusAlteradoEm: statusAlteradoEm,
                deteccaoPrecoce: deteccaoPrecoce,
                motivosPrecoce: motivosPrecoce,
                foraDoLimite: foraDoLimite,
                criadoPor: criadoPor,
                primeiraDeteccaoEm: primeiraDeteccaoEm,
                ultimaVisitaEm: ultimaVisitaEm,
                ultimaAbundancia: ultimaAbundancia,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String id,
                required String especieId,
                Value<String?> especieTexto = const Value.absent(),
                required String codigo,
                required double lat,
                required double lon,
                Value<double?> precisaoM = const Value.absent(),
                required String origemCoordenada,
                Value<String?> zona = const Value.absent(),
                Value<String?> ambiente = const Value.absent(),
                required String status,
                Value<bool> statusManual = const Value.absent(),
                Value<String?> statusAlteradoPor = const Value.absent(),
                Value<DateTime?> statusAlteradoEm = const Value.absent(),
                Value<bool> deteccaoPrecoce = const Value.absent(),
                Value<List<String>> motivosPrecoce = const Value.absent(),
                Value<bool> foraDoLimite = const Value.absent(),
                required String criadoPor,
                required DateTime primeiraDeteccaoEm,
                required DateTime ultimaVisitaEm,
                Value<String?> ultimaAbundancia = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocosCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                especieId: especieId,
                especieTexto: especieTexto,
                codigo: codigo,
                lat: lat,
                lon: lon,
                precisaoM: precisaoM,
                origemCoordenada: origemCoordenada,
                zona: zona,
                ambiente: ambiente,
                status: status,
                statusManual: statusManual,
                statusAlteradoPor: statusAlteradoPor,
                statusAlteradoEm: statusAlteradoEm,
                deteccaoPrecoce: deteccaoPrecoce,
                motivosPrecoce: motivosPrecoce,
                foraDoLimite: foraDoLimite,
                criadoPor: criadoPor,
                primeiraDeteccaoEm: primeiraDeteccaoEm,
                ultimaVisitaEm: ultimaVisitaEm,
                ultimaAbundancia: ultimaAbundancia,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FocosTable, Foco>(table),
                  $$FocosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                especieId = false,
                observacoesRefs = false,
                acoesManejoRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (observacoesRefs) db.observacoes,
                    if (acoesManejoRefs) db.acoesManejo,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (especieId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.especieId,
                            referencedTable: $$FocosTableReferences
                                ._especieIdTable(db),
                            referencedColumn: $$FocosTableReferences
                                ._especieIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (observacoesRefs)
                        await $_getPrefetchedData<
                          Foco,
                          $FocosTable,
                          Observacao
                        >(
                          currentTable: table,
                          referencedTable: $$FocosTableReferences
                              ._observacoesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FocosTableReferences(
                                db,
                                table,
                                p0,
                              ).observacoesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.focoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (acoesManejoRefs)
                        await $_getPrefetchedData<
                          Foco,
                          $FocosTable,
                          AcaoManejo
                        >(
                          currentTable: table,
                          referencedTable: $$FocosTableReferences
                              ._acoesManejoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FocosTableReferences(
                                db,
                                table,
                                p0,
                              ).acoesManejoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.focoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FocosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocosTable,
      Foco,
      $$FocosTableFilterComposer,
      $$FocosTableOrderingComposer,
      $$FocosTableAnnotationComposer,
      $$FocosTableCreateCompanionBuilder,
      $$FocosTableUpdateCompanionBuilder,
      (Foco, $$FocosTableReferences),
      Foco,
      PrefetchHooks Function({
        bool especieId,
        bool observacoesRefs,
        bool acoesManejoRefs,
      })
    >;
typedef $$ObservacoesTableCreateCompanionBuilder =
    ObservacoesCompanion Function({
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> serverUpdatedAt,
      Value<bool> deleted,
      Value<String> syncStatus,
      Value<int> version,
      required String id,
      required String focoId,
      required String tipo,
      required String usuarioId,
      Value<String?> sessaoId,
      required DateTime dataHora,
      required double lat,
      required double lon,
      Value<double?> precisaoM,
      Value<double?> altitudeM,
      required String presenca,
      Value<String?> resultado,
      Value<String?> quantificacaoTipo,
      Value<int?> nIndividuos,
      Value<String?> classeAbundancia,
      Value<double?> areaM2,
      Value<int?> coberturaPct,
      Value<String?> estagio,
      Value<String?> ambiente,
      Value<String?> texto,
      Value<bool> ditado,
      Value<String?> dispositivo,
      Value<String?> versaoApp,
      Value<int> rowid,
    });
typedef $$ObservacoesTableUpdateCompanionBuilder =
    ObservacoesCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> serverUpdatedAt,
      Value<bool> deleted,
      Value<String> syncStatus,
      Value<int> version,
      Value<String> id,
      Value<String> focoId,
      Value<String> tipo,
      Value<String> usuarioId,
      Value<String?> sessaoId,
      Value<DateTime> dataHora,
      Value<double> lat,
      Value<double> lon,
      Value<double?> precisaoM,
      Value<double?> altitudeM,
      Value<String> presenca,
      Value<String?> resultado,
      Value<String?> quantificacaoTipo,
      Value<int?> nIndividuos,
      Value<String?> classeAbundancia,
      Value<double?> areaM2,
      Value<int?> coberturaPct,
      Value<String?> estagio,
      Value<String?> ambiente,
      Value<String?> texto,
      Value<bool> ditado,
      Value<String?> dispositivo,
      Value<String?> versaoApp,
      Value<int> rowid,
    });

final class $$ObservacoesTableReferences
    extends BaseReferences<_$AppDatabase, $ObservacoesTable, Observacao> {
  $$ObservacoesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FocosTable _focoIdTable(_$AppDatabase db) =>
      db.focos.createAlias('observacoes__foco_id__focos__id');

  $$FocosTableProcessedTableManager get focoId {
    final $_column = $_itemColumn<String>('foco_id')!;

    final manager = $$FocosTableTableManager(
      $_db,
      $_db.focos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_focoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ObservacoesTableFilterComposer
    extends Composer<_$AppDatabase, $ObservacoesTable> {
  $$ObservacoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessaoId => $composableBuilder(
    column: $table.sessaoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precisaoM => $composableBuilder(
    column: $table.precisaoM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitudeM => $composableBuilder(
    column: $table.altitudeM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get presenca => $composableBuilder(
    column: $table.presenca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultado => $composableBuilder(
    column: $table.resultado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quantificacaoTipo => $composableBuilder(
    column: $table.quantificacaoTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nIndividuos => $composableBuilder(
    column: $table.nIndividuos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classeAbundancia => $composableBuilder(
    column: $table.classeAbundancia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaM2 => $composableBuilder(
    column: $table.areaM2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coberturaPct => $composableBuilder(
    column: $table.coberturaPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estagio => $composableBuilder(
    column: $table.estagio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ambiente => $composableBuilder(
    column: $table.ambiente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get texto => $composableBuilder(
    column: $table.texto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ditado => $composableBuilder(
    column: $table.ditado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dispositivo => $composableBuilder(
    column: $table.dispositivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get versaoApp => $composableBuilder(
    column: $table.versaoApp,
    builder: (column) => ColumnFilters(column),
  );

  $$FocosTableFilterComposer get focoId {
    final $$FocosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.focoId,
      referencedTable: $db.focos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocosTableFilterComposer(
            $db: $db,
            $table: $db.focos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObservacoesTableOrderingComposer
    extends Composer<_$AppDatabase, $ObservacoesTable> {
  $$ObservacoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessaoId => $composableBuilder(
    column: $table.sessaoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precisaoM => $composableBuilder(
    column: $table.precisaoM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitudeM => $composableBuilder(
    column: $table.altitudeM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get presenca => $composableBuilder(
    column: $table.presenca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultado => $composableBuilder(
    column: $table.resultado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantificacaoTipo => $composableBuilder(
    column: $table.quantificacaoTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nIndividuos => $composableBuilder(
    column: $table.nIndividuos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classeAbundancia => $composableBuilder(
    column: $table.classeAbundancia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaM2 => $composableBuilder(
    column: $table.areaM2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coberturaPct => $composableBuilder(
    column: $table.coberturaPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estagio => $composableBuilder(
    column: $table.estagio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ambiente => $composableBuilder(
    column: $table.ambiente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get texto => $composableBuilder(
    column: $table.texto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ditado => $composableBuilder(
    column: $table.ditado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dispositivo => $composableBuilder(
    column: $table.dispositivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get versaoApp => $composableBuilder(
    column: $table.versaoApp,
    builder: (column) => ColumnOrderings(column),
  );

  $$FocosTableOrderingComposer get focoId {
    final $$FocosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.focoId,
      referencedTable: $db.focos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocosTableOrderingComposer(
            $db: $db,
            $table: $db.focos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObservacoesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ObservacoesTable> {
  $$ObservacoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get sessaoId =>
      $composableBuilder(column: $table.sessaoId, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<double> get precisaoM =>
      $composableBuilder(column: $table.precisaoM, builder: (column) => column);

  GeneratedColumn<double> get altitudeM =>
      $composableBuilder(column: $table.altitudeM, builder: (column) => column);

  GeneratedColumn<String> get presenca =>
      $composableBuilder(column: $table.presenca, builder: (column) => column);

  GeneratedColumn<String> get resultado =>
      $composableBuilder(column: $table.resultado, builder: (column) => column);

  GeneratedColumn<String> get quantificacaoTipo => $composableBuilder(
    column: $table.quantificacaoTipo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nIndividuos => $composableBuilder(
    column: $table.nIndividuos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get classeAbundancia => $composableBuilder(
    column: $table.classeAbundancia,
    builder: (column) => column,
  );

  GeneratedColumn<double> get areaM2 =>
      $composableBuilder(column: $table.areaM2, builder: (column) => column);

  GeneratedColumn<int> get coberturaPct => $composableBuilder(
    column: $table.coberturaPct,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estagio =>
      $composableBuilder(column: $table.estagio, builder: (column) => column);

  GeneratedColumn<String> get ambiente =>
      $composableBuilder(column: $table.ambiente, builder: (column) => column);

  GeneratedColumn<String> get texto =>
      $composableBuilder(column: $table.texto, builder: (column) => column);

  GeneratedColumn<bool> get ditado =>
      $composableBuilder(column: $table.ditado, builder: (column) => column);

  GeneratedColumn<String> get dispositivo => $composableBuilder(
    column: $table.dispositivo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get versaoApp =>
      $composableBuilder(column: $table.versaoApp, builder: (column) => column);

  $$FocosTableAnnotationComposer get focoId {
    final $$FocosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.focoId,
      referencedTable: $db.focos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocosTableAnnotationComposer(
            $db: $db,
            $table: $db.focos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObservacoesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ObservacoesTable,
          Observacao,
          $$ObservacoesTableFilterComposer,
          $$ObservacoesTableOrderingComposer,
          $$ObservacoesTableAnnotationComposer,
          $$ObservacoesTableCreateCompanionBuilder,
          $$ObservacoesTableUpdateCompanionBuilder,
          (Observacao, $$ObservacoesTableReferences),
          Observacao,
          PrefetchHooks Function({bool focoId})
        > {
  $$ObservacoesTableTableManager(_$AppDatabase db, $ObservacoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObservacoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObservacoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObservacoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> focoId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<String?> sessaoId = const Value.absent(),
                Value<DateTime> dataHora = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<double?> precisaoM = const Value.absent(),
                Value<double?> altitudeM = const Value.absent(),
                Value<String> presenca = const Value.absent(),
                Value<String?> resultado = const Value.absent(),
                Value<String?> quantificacaoTipo = const Value.absent(),
                Value<int?> nIndividuos = const Value.absent(),
                Value<String?> classeAbundancia = const Value.absent(),
                Value<double?> areaM2 = const Value.absent(),
                Value<int?> coberturaPct = const Value.absent(),
                Value<String?> estagio = const Value.absent(),
                Value<String?> ambiente = const Value.absent(),
                Value<String?> texto = const Value.absent(),
                Value<bool> ditado = const Value.absent(),
                Value<String?> dispositivo = const Value.absent(),
                Value<String?> versaoApp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObservacoesCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                focoId: focoId,
                tipo: tipo,
                usuarioId: usuarioId,
                sessaoId: sessaoId,
                dataHora: dataHora,
                lat: lat,
                lon: lon,
                precisaoM: precisaoM,
                altitudeM: altitudeM,
                presenca: presenca,
                resultado: resultado,
                quantificacaoTipo: quantificacaoTipo,
                nIndividuos: nIndividuos,
                classeAbundancia: classeAbundancia,
                areaM2: areaM2,
                coberturaPct: coberturaPct,
                estagio: estagio,
                ambiente: ambiente,
                texto: texto,
                ditado: ditado,
                dispositivo: dispositivo,
                versaoApp: versaoApp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String id,
                required String focoId,
                required String tipo,
                required String usuarioId,
                Value<String?> sessaoId = const Value.absent(),
                required DateTime dataHora,
                required double lat,
                required double lon,
                Value<double?> precisaoM = const Value.absent(),
                Value<double?> altitudeM = const Value.absent(),
                required String presenca,
                Value<String?> resultado = const Value.absent(),
                Value<String?> quantificacaoTipo = const Value.absent(),
                Value<int?> nIndividuos = const Value.absent(),
                Value<String?> classeAbundancia = const Value.absent(),
                Value<double?> areaM2 = const Value.absent(),
                Value<int?> coberturaPct = const Value.absent(),
                Value<String?> estagio = const Value.absent(),
                Value<String?> ambiente = const Value.absent(),
                Value<String?> texto = const Value.absent(),
                Value<bool> ditado = const Value.absent(),
                Value<String?> dispositivo = const Value.absent(),
                Value<String?> versaoApp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObservacoesCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                focoId: focoId,
                tipo: tipo,
                usuarioId: usuarioId,
                sessaoId: sessaoId,
                dataHora: dataHora,
                lat: lat,
                lon: lon,
                precisaoM: precisaoM,
                altitudeM: altitudeM,
                presenca: presenca,
                resultado: resultado,
                quantificacaoTipo: quantificacaoTipo,
                nIndividuos: nIndividuos,
                classeAbundancia: classeAbundancia,
                areaM2: areaM2,
                coberturaPct: coberturaPct,
                estagio: estagio,
                ambiente: ambiente,
                texto: texto,
                ditado: ditado,
                dispositivo: dispositivo,
                versaoApp: versaoApp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ObservacoesTable, Observacao>(table),
                  $$ObservacoesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({focoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (focoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.focoId,
                        referencedTable: $$ObservacoesTableReferences
                            ._focoIdTable(db),
                        referencedColumn: $$ObservacoesTableReferences
                            ._focoIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ObservacoesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ObservacoesTable,
      Observacao,
      $$ObservacoesTableFilterComposer,
      $$ObservacoesTableOrderingComposer,
      $$ObservacoesTableAnnotationComposer,
      $$ObservacoesTableCreateCompanionBuilder,
      $$ObservacoesTableUpdateCompanionBuilder,
      (Observacao, $$ObservacoesTableReferences),
      Observacao,
      PrefetchHooks Function({bool focoId})
    >;
typedef $$AcoesManejoTableCreateCompanionBuilder =
    AcoesManejoCompanion Function({
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> serverUpdatedAt,
      Value<bool> deleted,
      Value<String> syncStatus,
      Value<int> version,
      required String id,
      required String focoId,
      required String usuarioId,
      required String responsavel,
      required DateTime dataHoraInicio,
      Value<DateTime?> dataHoraFim,
      required String metodo,
      Value<String?> metodoTexto,
      Value<String?> herbicidaProduto,
      Value<String?> herbicidaConcentracao,
      Value<double?> herbicidaVolumeL,
      Value<int?> nIndividuosTratados,
      Value<double?> areaTratadaM2,
      required int nPessoas,
      required double horas,
      Value<String?> destinacao,
      Value<bool?> epiUtilizado,
      Value<String?> condicaoTempo,
      Value<String?> texto,
      Value<int> rowid,
    });
typedef $$AcoesManejoTableUpdateCompanionBuilder =
    AcoesManejoCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> serverUpdatedAt,
      Value<bool> deleted,
      Value<String> syncStatus,
      Value<int> version,
      Value<String> id,
      Value<String> focoId,
      Value<String> usuarioId,
      Value<String> responsavel,
      Value<DateTime> dataHoraInicio,
      Value<DateTime?> dataHoraFim,
      Value<String> metodo,
      Value<String?> metodoTexto,
      Value<String?> herbicidaProduto,
      Value<String?> herbicidaConcentracao,
      Value<double?> herbicidaVolumeL,
      Value<int?> nIndividuosTratados,
      Value<double?> areaTratadaM2,
      Value<int> nPessoas,
      Value<double> horas,
      Value<String?> destinacao,
      Value<bool?> epiUtilizado,
      Value<String?> condicaoTempo,
      Value<String?> texto,
      Value<int> rowid,
    });

final class $$AcoesManejoTableReferences
    extends BaseReferences<_$AppDatabase, $AcoesManejoTable, AcaoManejo> {
  $$AcoesManejoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FocosTable _focoIdTable(_$AppDatabase db) =>
      db.focos.createAlias('acoes_manejo__foco_id__focos__id');

  $$FocosTableProcessedTableManager get focoId {
    final $_column = $_itemColumn<String>('foco_id')!;

    final manager = $$FocosTableTableManager(
      $_db,
      $_db.focos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_focoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AcoesManejoTableFilterComposer
    extends Composer<_$AppDatabase, $AcoesManejoTable> {
  $$AcoesManejoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responsavel => $composableBuilder(
    column: $table.responsavel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataHoraInicio => $composableBuilder(
    column: $table.dataHoraInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataHoraFim => $composableBuilder(
    column: $table.dataHoraFim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metodo => $composableBuilder(
    column: $table.metodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metodoTexto => $composableBuilder(
    column: $table.metodoTexto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get herbicidaProduto => $composableBuilder(
    column: $table.herbicidaProduto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get herbicidaConcentracao => $composableBuilder(
    column: $table.herbicidaConcentracao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get herbicidaVolumeL => $composableBuilder(
    column: $table.herbicidaVolumeL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nIndividuosTratados => $composableBuilder(
    column: $table.nIndividuosTratados,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaTratadaM2 => $composableBuilder(
    column: $table.areaTratadaM2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nPessoas => $composableBuilder(
    column: $table.nPessoas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get horas => $composableBuilder(
    column: $table.horas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinacao => $composableBuilder(
    column: $table.destinacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get epiUtilizado => $composableBuilder(
    column: $table.epiUtilizado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condicaoTempo => $composableBuilder(
    column: $table.condicaoTempo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get texto => $composableBuilder(
    column: $table.texto,
    builder: (column) => ColumnFilters(column),
  );

  $$FocosTableFilterComposer get focoId {
    final $$FocosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.focoId,
      referencedTable: $db.focos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocosTableFilterComposer(
            $db: $db,
            $table: $db.focos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AcoesManejoTableOrderingComposer
    extends Composer<_$AppDatabase, $AcoesManejoTable> {
  $$AcoesManejoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responsavel => $composableBuilder(
    column: $table.responsavel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataHoraInicio => $composableBuilder(
    column: $table.dataHoraInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataHoraFim => $composableBuilder(
    column: $table.dataHoraFim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodo => $composableBuilder(
    column: $table.metodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodoTexto => $composableBuilder(
    column: $table.metodoTexto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get herbicidaProduto => $composableBuilder(
    column: $table.herbicidaProduto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get herbicidaConcentracao => $composableBuilder(
    column: $table.herbicidaConcentracao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get herbicidaVolumeL => $composableBuilder(
    column: $table.herbicidaVolumeL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nIndividuosTratados => $composableBuilder(
    column: $table.nIndividuosTratados,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaTratadaM2 => $composableBuilder(
    column: $table.areaTratadaM2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nPessoas => $composableBuilder(
    column: $table.nPessoas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get horas => $composableBuilder(
    column: $table.horas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinacao => $composableBuilder(
    column: $table.destinacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get epiUtilizado => $composableBuilder(
    column: $table.epiUtilizado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condicaoTempo => $composableBuilder(
    column: $table.condicaoTempo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get texto => $composableBuilder(
    column: $table.texto,
    builder: (column) => ColumnOrderings(column),
  );

  $$FocosTableOrderingComposer get focoId {
    final $$FocosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.focoId,
      referencedTable: $db.focos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocosTableOrderingComposer(
            $db: $db,
            $table: $db.focos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AcoesManejoTableAnnotationComposer
    extends Composer<_$AppDatabase, $AcoesManejoTable> {
  $$AcoesManejoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get responsavel => $composableBuilder(
    column: $table.responsavel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataHoraInicio => $composableBuilder(
    column: $table.dataHoraInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataHoraFim => $composableBuilder(
    column: $table.dataHoraFim,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metodo =>
      $composableBuilder(column: $table.metodo, builder: (column) => column);

  GeneratedColumn<String> get metodoTexto => $composableBuilder(
    column: $table.metodoTexto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get herbicidaProduto => $composableBuilder(
    column: $table.herbicidaProduto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get herbicidaConcentracao => $composableBuilder(
    column: $table.herbicidaConcentracao,
    builder: (column) => column,
  );

  GeneratedColumn<double> get herbicidaVolumeL => $composableBuilder(
    column: $table.herbicidaVolumeL,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nIndividuosTratados => $composableBuilder(
    column: $table.nIndividuosTratados,
    builder: (column) => column,
  );

  GeneratedColumn<double> get areaTratadaM2 => $composableBuilder(
    column: $table.areaTratadaM2,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nPessoas =>
      $composableBuilder(column: $table.nPessoas, builder: (column) => column);

  GeneratedColumn<double> get horas =>
      $composableBuilder(column: $table.horas, builder: (column) => column);

  GeneratedColumn<String> get destinacao => $composableBuilder(
    column: $table.destinacao,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get epiUtilizado => $composableBuilder(
    column: $table.epiUtilizado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get condicaoTempo => $composableBuilder(
    column: $table.condicaoTempo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get texto =>
      $composableBuilder(column: $table.texto, builder: (column) => column);

  $$FocosTableAnnotationComposer get focoId {
    final $$FocosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.focoId,
      referencedTable: $db.focos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocosTableAnnotationComposer(
            $db: $db,
            $table: $db.focos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AcoesManejoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AcoesManejoTable,
          AcaoManejo,
          $$AcoesManejoTableFilterComposer,
          $$AcoesManejoTableOrderingComposer,
          $$AcoesManejoTableAnnotationComposer,
          $$AcoesManejoTableCreateCompanionBuilder,
          $$AcoesManejoTableUpdateCompanionBuilder,
          (AcaoManejo, $$AcoesManejoTableReferences),
          AcaoManejo,
          PrefetchHooks Function({bool focoId})
        > {
  $$AcoesManejoTableTableManager(_$AppDatabase db, $AcoesManejoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AcoesManejoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AcoesManejoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AcoesManejoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> focoId = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<String> responsavel = const Value.absent(),
                Value<DateTime> dataHoraInicio = const Value.absent(),
                Value<DateTime?> dataHoraFim = const Value.absent(),
                Value<String> metodo = const Value.absent(),
                Value<String?> metodoTexto = const Value.absent(),
                Value<String?> herbicidaProduto = const Value.absent(),
                Value<String?> herbicidaConcentracao = const Value.absent(),
                Value<double?> herbicidaVolumeL = const Value.absent(),
                Value<int?> nIndividuosTratados = const Value.absent(),
                Value<double?> areaTratadaM2 = const Value.absent(),
                Value<int> nPessoas = const Value.absent(),
                Value<double> horas = const Value.absent(),
                Value<String?> destinacao = const Value.absent(),
                Value<bool?> epiUtilizado = const Value.absent(),
                Value<String?> condicaoTempo = const Value.absent(),
                Value<String?> texto = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AcoesManejoCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                focoId: focoId,
                usuarioId: usuarioId,
                responsavel: responsavel,
                dataHoraInicio: dataHoraInicio,
                dataHoraFim: dataHoraFim,
                metodo: metodo,
                metodoTexto: metodoTexto,
                herbicidaProduto: herbicidaProduto,
                herbicidaConcentracao: herbicidaConcentracao,
                herbicidaVolumeL: herbicidaVolumeL,
                nIndividuosTratados: nIndividuosTratados,
                areaTratadaM2: areaTratadaM2,
                nPessoas: nPessoas,
                horas: horas,
                destinacao: destinacao,
                epiUtilizado: epiUtilizado,
                condicaoTempo: condicaoTempo,
                texto: texto,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String id,
                required String focoId,
                required String usuarioId,
                required String responsavel,
                required DateTime dataHoraInicio,
                Value<DateTime?> dataHoraFim = const Value.absent(),
                required String metodo,
                Value<String?> metodoTexto = const Value.absent(),
                Value<String?> herbicidaProduto = const Value.absent(),
                Value<String?> herbicidaConcentracao = const Value.absent(),
                Value<double?> herbicidaVolumeL = const Value.absent(),
                Value<int?> nIndividuosTratados = const Value.absent(),
                Value<double?> areaTratadaM2 = const Value.absent(),
                required int nPessoas,
                required double horas,
                Value<String?> destinacao = const Value.absent(),
                Value<bool?> epiUtilizado = const Value.absent(),
                Value<String?> condicaoTempo = const Value.absent(),
                Value<String?> texto = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AcoesManejoCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                focoId: focoId,
                usuarioId: usuarioId,
                responsavel: responsavel,
                dataHoraInicio: dataHoraInicio,
                dataHoraFim: dataHoraFim,
                metodo: metodo,
                metodoTexto: metodoTexto,
                herbicidaProduto: herbicidaProduto,
                herbicidaConcentracao: herbicidaConcentracao,
                herbicidaVolumeL: herbicidaVolumeL,
                nIndividuosTratados: nIndividuosTratados,
                areaTratadaM2: areaTratadaM2,
                nPessoas: nPessoas,
                horas: horas,
                destinacao: destinacao,
                epiUtilizado: epiUtilizado,
                condicaoTempo: condicaoTempo,
                texto: texto,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AcoesManejoTable, AcaoManejo>(table),
                  $$AcoesManejoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({focoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (focoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.focoId,
                        referencedTable: $$AcoesManejoTableReferences
                            ._focoIdTable(db),
                        referencedColumn: $$AcoesManejoTableReferences
                            ._focoIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AcoesManejoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AcoesManejoTable,
      AcaoManejo,
      $$AcoesManejoTableFilterComposer,
      $$AcoesManejoTableOrderingComposer,
      $$AcoesManejoTableAnnotationComposer,
      $$AcoesManejoTableCreateCompanionBuilder,
      $$AcoesManejoTableUpdateCompanionBuilder,
      (AcaoManejo, $$AcoesManejoTableReferences),
      AcaoManejo,
      PrefetchHooks Function({bool focoId})
    >;
typedef $$MidiasTableCreateCompanionBuilder = MidiasCompanion Function({
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> deleted,
  Value<String> syncStatus,
  Value<int> version,
  required String id,
  required String donoTipo,
  required String donoId,
  Value<String> tipo,
  Value<String?> momento,
  Value<String?> caminhoLocal,
  Value<String?> caminhoRemoto,
  Value<double?> lat,
  Value<double?> lon,
  required DateTime tiradaEm,
  Value<int?> tamanhoBytes,
  Value<String> uploadStatus,
  Value<String?> uploadErro,
  Value<int> rowid,
});
typedef $$MidiasTableUpdateCompanionBuilder = MidiasCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> deleted,
  Value<String> syncStatus,
  Value<int> version,
  Value<String> id,
  Value<String> donoTipo,
  Value<String> donoId,
  Value<String> tipo,
  Value<String?> momento,
  Value<String?> caminhoLocal,
  Value<String?> caminhoRemoto,
  Value<double?> lat,
  Value<double?> lon,
  Value<DateTime> tiradaEm,
  Value<int?> tamanhoBytes,
  Value<String> uploadStatus,
  Value<String?> uploadErro,
  Value<int> rowid,
});

class $$MidiasTableFilterComposer
    extends Composer<_$AppDatabase, $MidiasTable> {
  $$MidiasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get donoTipo => $composableBuilder(
    column: $table.donoTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get donoId => $composableBuilder(
    column: $table.donoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get momento => $composableBuilder(
    column: $table.momento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caminhoLocal => $composableBuilder(
    column: $table.caminhoLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caminhoRemoto => $composableBuilder(
    column: $table.caminhoRemoto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tiradaEm => $composableBuilder(
    column: $table.tiradaEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tamanhoBytes => $composableBuilder(
    column: $table.tamanhoBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadErro => $composableBuilder(
    column: $table.uploadErro,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MidiasTableOrderingComposer
    extends Composer<_$AppDatabase, $MidiasTable> {
  $$MidiasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get donoTipo => $composableBuilder(
    column: $table.donoTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get donoId => $composableBuilder(
    column: $table.donoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get momento => $composableBuilder(
    column: $table.momento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caminhoLocal => $composableBuilder(
    column: $table.caminhoLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caminhoRemoto => $composableBuilder(
    column: $table.caminhoRemoto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tiradaEm => $composableBuilder(
    column: $table.tiradaEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tamanhoBytes => $composableBuilder(
    column: $table.tamanhoBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadErro => $composableBuilder(
    column: $table.uploadErro,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MidiasTableAnnotationComposer
    extends Composer<_$AppDatabase, $MidiasTable> {
  $$MidiasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get donoTipo =>
      $composableBuilder(column: $table.donoTipo, builder: (column) => column);

  GeneratedColumn<String> get donoId =>
      $composableBuilder(column: $table.donoId, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get momento =>
      $composableBuilder(column: $table.momento, builder: (column) => column);

  GeneratedColumn<String> get caminhoLocal => $composableBuilder(
    column: $table.caminhoLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get caminhoRemoto => $composableBuilder(
    column: $table.caminhoRemoto,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<DateTime> get tiradaEm =>
      $composableBuilder(column: $table.tiradaEm, builder: (column) => column);

  GeneratedColumn<int> get tamanhoBytes => $composableBuilder(
    column: $table.tamanhoBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uploadErro => $composableBuilder(
    column: $table.uploadErro,
    builder: (column) => column,
  );
}

class $$MidiasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MidiasTable,
          Midia,
          $$MidiasTableFilterComposer,
          $$MidiasTableOrderingComposer,
          $$MidiasTableAnnotationComposer,
          $$MidiasTableCreateCompanionBuilder,
          $$MidiasTableUpdateCompanionBuilder,
          (Midia, BaseReferences<_$AppDatabase, $MidiasTable, Midia>),
          Midia,
          PrefetchHooks Function()
        > {
  $$MidiasTableTableManager(_$AppDatabase db, $MidiasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MidiasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MidiasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MidiasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> donoTipo = const Value.absent(),
                Value<String> donoId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> momento = const Value.absent(),
                Value<String?> caminhoLocal = const Value.absent(),
                Value<String?> caminhoRemoto = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lon = const Value.absent(),
                Value<DateTime> tiradaEm = const Value.absent(),
                Value<int?> tamanhoBytes = const Value.absent(),
                Value<String> uploadStatus = const Value.absent(),
                Value<String?> uploadErro = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MidiasCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                donoTipo: donoTipo,
                donoId: donoId,
                tipo: tipo,
                momento: momento,
                caminhoLocal: caminhoLocal,
                caminhoRemoto: caminhoRemoto,
                lat: lat,
                lon: lon,
                tiradaEm: tiradaEm,
                tamanhoBytes: tamanhoBytes,
                uploadStatus: uploadStatus,
                uploadErro: uploadErro,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                required String id,
                required String donoTipo,
                required String donoId,
                Value<String> tipo = const Value.absent(),
                Value<String?> momento = const Value.absent(),
                Value<String?> caminhoLocal = const Value.absent(),
                Value<String?> caminhoRemoto = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lon = const Value.absent(),
                required DateTime tiradaEm,
                Value<int?> tamanhoBytes = const Value.absent(),
                Value<String> uploadStatus = const Value.absent(),
                Value<String?> uploadErro = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MidiasCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                deleted: deleted,
                syncStatus: syncStatus,
                version: version,
                id: id,
                donoTipo: donoTipo,
                donoId: donoId,
                tipo: tipo,
                momento: momento,
                caminhoLocal: caminhoLocal,
                caminhoRemoto: caminhoRemoto,
                lat: lat,
                lon: lon,
                tiradaEm: tiradaEm,
                tamanhoBytes: tamanhoBytes,
                uploadStatus: uploadStatus,
                uploadErro: uploadErro,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MidiasTable, Midia>(table),
                  BaseReferences<_$AppDatabase, $MidiasTable, Midia>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MidiasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MidiasTable,
      Midia,
      $$MidiasTableFilterComposer,
      $$MidiasTableOrderingComposer,
      $$MidiasTableAnnotationComposer,
      $$MidiasTableCreateCompanionBuilder,
      $$MidiasTableUpdateCompanionBuilder,
      (Midia, BaseReferences<_$AppDatabase, $MidiasTable, Midia>),
      Midia,
      PrefetchHooks Function()
    >;
typedef $$ListaValoresTableCreateCompanionBuilder =
    ListaValoresCompanion Function({
      required String lista,
      required String codigo,
      required String rotulo,
      required int ordem,
      Value<bool> ativo,
      Value<int> rowid,
    });
typedef $$ListaValoresTableUpdateCompanionBuilder =
    ListaValoresCompanion Function({
      Value<String> lista,
      Value<String> codigo,
      Value<String> rotulo,
      Value<int> ordem,
      Value<bool> ativo,
      Value<int> rowid,
    });

class $$ListaValoresTableFilterComposer
    extends Composer<_$AppDatabase, $ListaValoresTable> {
  $$ListaValoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lista => $composableBuilder(
    column: $table.lista,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rotulo => $composableBuilder(
    column: $table.rotulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ListaValoresTableOrderingComposer
    extends Composer<_$AppDatabase, $ListaValoresTable> {
  $$ListaValoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lista => $composableBuilder(
    column: $table.lista,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rotulo => $composableBuilder(
    column: $table.rotulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListaValoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListaValoresTable> {
  $$ListaValoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lista =>
      $composableBuilder(column: $table.lista, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get rotulo =>
      $composableBuilder(column: $table.rotulo, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);
}

class $$ListaValoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListaValoresTable,
          ListaValor,
          $$ListaValoresTableFilterComposer,
          $$ListaValoresTableOrderingComposer,
          $$ListaValoresTableAnnotationComposer,
          $$ListaValoresTableCreateCompanionBuilder,
          $$ListaValoresTableUpdateCompanionBuilder,
          (
            ListaValor,
            BaseReferences<_$AppDatabase, $ListaValoresTable, ListaValor>,
          ),
          ListaValor,
          PrefetchHooks Function()
        > {
  $$ListaValoresTableTableManager(_$AppDatabase db, $ListaValoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListaValoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListaValoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListaValoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> lista = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> rotulo = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListaValoresCompanion(
                lista: lista,
                codigo: codigo,
                rotulo: rotulo,
                ordem: ordem,
                ativo: ativo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String lista,
                required String codigo,
                required String rotulo,
                required int ordem,
                Value<bool> ativo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListaValoresCompanion.insert(
                lista: lista,
                codigo: codigo,
                rotulo: rotulo,
                ordem: ordem,
                ativo: ativo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ListaValoresTable, ListaValor>(table),
                  BaseReferences<_$AppDatabase, $ListaValoresTable, ListaValor>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ListaValoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListaValoresTable,
      ListaValor,
      $$ListaValoresTableFilterComposer,
      $$ListaValoresTableOrderingComposer,
      $$ListaValoresTableAnnotationComposer,
      $$ListaValoresTableCreateCompanionBuilder,
      $$ListaValoresTableUpdateCompanionBuilder,
      (
        ListaValor,
        BaseReferences<_$AppDatabase, $ListaValoresTable, ListaValor>,
      ),
      ListaValor,
      PrefetchHooks Function()
    >;
typedef $$ConfigsTableCreateCompanionBuilder = ConfigsCompanion Function({
  required String chave,
  required String valor,
  Value<int> rowid,
});
typedef $$ConfigsTableUpdateCompanionBuilder = ConfigsCompanion Function({
  Value<String> chave,
  Value<String> valor,
  Value<int> rowid,
});

class $$ConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $ConfigsTable> {
  $$ConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get chave => $composableBuilder(
    column: $table.chave,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfigsTable> {
  $$ConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get chave => $composableBuilder(
    column: $table.chave,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfigsTable> {
  $$ConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get chave =>
      $composableBuilder(column: $table.chave, builder: (column) => column);

  GeneratedColumn<String> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);
}

class $$ConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfigsTable,
          Config,
          $$ConfigsTableFilterComposer,
          $$ConfigsTableOrderingComposer,
          $$ConfigsTableAnnotationComposer,
          $$ConfigsTableCreateCompanionBuilder,
          $$ConfigsTableUpdateCompanionBuilder,
          (Config, BaseReferences<_$AppDatabase, $ConfigsTable, Config>),
          Config,
          PrefetchHooks Function()
        > {
  $$ConfigsTableTableManager(_$AppDatabase db, $ConfigsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> chave = const Value.absent(),
            Value<String> valor = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => ConfigsCompanion(chave: chave, valor: valor, rowid: rowid),
          createCompanionCallback:
              ({
                required String chave,
                required String valor,
                Value<int> rowid = const Value.absent(),
              }) => ConfigsCompanion.insert(
                chave: chave,
                valor: valor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConfigsTable, Config>(table),
                  BaseReferences<_$AppDatabase, $ConfigsTable, Config>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfigsTable,
      Config,
      $$ConfigsTableFilterComposer,
      $$ConfigsTableOrderingComposer,
      $$ConfigsTableAnnotationComposer,
      $$ConfigsTableCreateCompanionBuilder,
      $$ConfigsTableUpdateCompanionBuilder,
      (Config, BaseReferences<_$AppDatabase, $ConfigsTable, Config>),
      Config,
      PrefetchHooks Function()
    >;
typedef $$ErrosSyncTableCreateCompanionBuilder = ErrosSyncCompanion Function({
  required String tabela,
  required String registroId,
  required String mensagem,
  Value<int> tentativas,
  required DateTime ultimaTentativa,
  Value<int> rowid,
});
typedef $$ErrosSyncTableUpdateCompanionBuilder = ErrosSyncCompanion Function({
  Value<String> tabela,
  Value<String> registroId,
  Value<String> mensagem,
  Value<int> tentativas,
  Value<DateTime> ultimaTentativa,
  Value<int> rowid,
});

class $$ErrosSyncTableFilterComposer
    extends Composer<_$AppDatabase, $ErrosSyncTable> {
  $$ErrosSyncTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tabela => $composableBuilder(
    column: $table.tabela,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registroId => $composableBuilder(
    column: $table.registroId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mensagem => $composableBuilder(
    column: $table.mensagem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tentativas => $composableBuilder(
    column: $table.tentativas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ultimaTentativa => $composableBuilder(
    column: $table.ultimaTentativa,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ErrosSyncTableOrderingComposer
    extends Composer<_$AppDatabase, $ErrosSyncTable> {
  $$ErrosSyncTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tabela => $composableBuilder(
    column: $table.tabela,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registroId => $composableBuilder(
    column: $table.registroId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mensagem => $composableBuilder(
    column: $table.mensagem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tentativas => $composableBuilder(
    column: $table.tentativas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ultimaTentativa => $composableBuilder(
    column: $table.ultimaTentativa,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ErrosSyncTableAnnotationComposer
    extends Composer<_$AppDatabase, $ErrosSyncTable> {
  $$ErrosSyncTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tabela =>
      $composableBuilder(column: $table.tabela, builder: (column) => column);

  GeneratedColumn<String> get registroId => $composableBuilder(
    column: $table.registroId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mensagem =>
      $composableBuilder(column: $table.mensagem, builder: (column) => column);

  GeneratedColumn<int> get tentativas => $composableBuilder(
    column: $table.tentativas,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get ultimaTentativa => $composableBuilder(
    column: $table.ultimaTentativa,
    builder: (column) => column,
  );
}

class $$ErrosSyncTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ErrosSyncTable,
          ErroSync,
          $$ErrosSyncTableFilterComposer,
          $$ErrosSyncTableOrderingComposer,
          $$ErrosSyncTableAnnotationComposer,
          $$ErrosSyncTableCreateCompanionBuilder,
          $$ErrosSyncTableUpdateCompanionBuilder,
          (ErroSync, BaseReferences<_$AppDatabase, $ErrosSyncTable, ErroSync>),
          ErroSync,
          PrefetchHooks Function()
        > {
  $$ErrosSyncTableTableManager(_$AppDatabase db, $ErrosSyncTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ErrosSyncTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ErrosSyncTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ErrosSyncTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tabela = const Value.absent(),
                Value<String> registroId = const Value.absent(),
                Value<String> mensagem = const Value.absent(),
                Value<int> tentativas = const Value.absent(),
                Value<DateTime> ultimaTentativa = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ErrosSyncCompanion(
                tabela: tabela,
                registroId: registroId,
                mensagem: mensagem,
                tentativas: tentativas,
                ultimaTentativa: ultimaTentativa,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tabela,
                required String registroId,
                required String mensagem,
                Value<int> tentativas = const Value.absent(),
                required DateTime ultimaTentativa,
                Value<int> rowid = const Value.absent(),
              }) => ErrosSyncCompanion.insert(
                tabela: tabela,
                registroId: registroId,
                mensagem: mensagem,
                tentativas: tentativas,
                ultimaTentativa: ultimaTentativa,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ErrosSyncTable, ErroSync>(table),
                  BaseReferences<_$AppDatabase, $ErrosSyncTable, ErroSync>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ErrosSyncTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ErrosSyncTable,
      ErroSync,
      $$ErrosSyncTableFilterComposer,
      $$ErrosSyncTableOrderingComposer,
      $$ErrosSyncTableAnnotationComposer,
      $$ErrosSyncTableCreateCompanionBuilder,
      $$ErrosSyncTableUpdateCompanionBuilder,
      (ErroSync, BaseReferences<_$AppDatabase, $ErrosSyncTable, ErroSync>),
      ErroSync,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$EspeciesTableTableManager get especies =>
      $$EspeciesTableTableManager(_db, _db.especies);
  $$FocosTableTableManager get focos =>
      $$FocosTableTableManager(_db, _db.focos);
  $$ObservacoesTableTableManager get observacoes =>
      $$ObservacoesTableTableManager(_db, _db.observacoes);
  $$AcoesManejoTableTableManager get acoesManejo =>
      $$AcoesManejoTableTableManager(_db, _db.acoesManejo);
  $$MidiasTableTableManager get midias =>
      $$MidiasTableTableManager(_db, _db.midias);
  $$ListaValoresTableTableManager get listaValores =>
      $$ListaValoresTableTableManager(_db, _db.listaValores);
  $$ConfigsTableTableManager get configs =>
      $$ConfigsTableTableManager(_db, _db.configs);
  $$ErrosSyncTableTableManager get errosSync =>
      $$ErrosSyncTableTableManager(_db, _db.errosSync);
}
