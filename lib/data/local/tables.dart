import 'dart:convert';

import 'package:drift/drift.dart';

/// Lista de textos guardada como JSON.
class ListaTextoConverter extends TypeConverter<List<String>, String> {
  const ListaTextoConverter();

  @override
  List<String> fromSql(String fromDb) =>
      fromDb.isEmpty ? const [] : (jsonDecode(fromDb) as List).cast<String>();

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

/// Campos de sincronização presentes em todas as tabelas sincronizáveis (§12.2).
mixin CamposSync on Table {
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pendente'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
}

@DataClassName('Usuario')
class Usuarios extends Table with CamposSync {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get email => text()();
  TextColumn get perfil => text()();
  TextColumn get funcao => text().nullable()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Especie')
class Especies extends Table with CamposSync {
  TextColumn get id => text()();
  TextColumn get prefixo => text()();
  TextColumn get nomeCientifico => text()();
  TextColumn get nomesPopulares => text().map(const ListaTextoConverter())();
  TextColumn get familia => text().nullable()();
  TextColumn get formaVida => text()();
  TextColumn get descricaoIdentificacao => text().nullable()();
  TextColumn get confusaoCom => text().nullable()();
  TextColumn get controleCitado => text().nullable()();
  TextColumn get metodosSugeridos => text().map(const ListaTextoConverter())();
  TextColumn get fotosReferencia => text().map(const ListaTextoConverter())();
  IntColumn get prioridade => integer().nullable()();
  BoolColumn get naListaOficialIcmbio => boolean().nullable()();
  BoolColumn get ativa => boolean().withDefault(const Constant(true))();
  IntColumn get ordem => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Foco')
class Focos extends Table with CamposSync {
  TextColumn get id => text()();
  TextColumn get especieId => text().references(Especies, #id)();
  TextColumn get especieTexto => text().nullable()();
  TextColumn get codigo => text()();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  RealColumn get precisaoM => real().nullable()();
  TextColumn get origemCoordenada => text()();
  TextColumn get zona => text().nullable()();
  TextColumn get ambiente => text().nullable()();
  TextColumn get status => text()();
  BoolColumn get statusManual => boolean().withDefault(const Constant(false))();
  TextColumn get statusAlteradoPor => text().nullable()();
  DateTimeColumn get statusAlteradoEm => dateTime().nullable()();
  BoolColumn get deteccaoPrecoce => boolean().withDefault(const Constant(false))();
  TextColumn get motivosPrecoce => text().map(const ListaTextoConverter()).withDefault(const Constant('[]'))();
  BoolColumn get foraDoLimite => boolean().withDefault(const Constant(false))();
  TextColumn get criadoPor => text()();
  DateTimeColumn get primeiraDeteccaoEm => dateTime()();
  DateTimeColumn get ultimaVisitaEm => dateTime()();
  TextColumn get ultimaAbundancia => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Observacao')
class Observacoes extends Table with CamposSync {
  TextColumn get id => text()();
  TextColumn get focoId => text().references(Focos, #id)();
  TextColumn get tipo => text()();
  TextColumn get usuarioId => text()();
  TextColumn get sessaoId => text().nullable()();
  DateTimeColumn get dataHora => dateTime()();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  RealColumn get precisaoM => real().nullable()();
  RealColumn get altitudeM => real().nullable()();
  TextColumn get presenca => text()();
  TextColumn get resultado => text().nullable()();
  TextColumn get quantificacaoTipo => text().nullable()();
  IntColumn get nIndividuos => integer().nullable()();
  TextColumn get classeAbundancia => text().nullable()();
  RealColumn get areaM2 => real().nullable()();
  IntColumn get coberturaPct => integer().nullable()();
  TextColumn get estagio => text().nullable()();
  TextColumn get ambiente => text().nullable()();
  TextColumn get texto => text().nullable()();
  BoolColumn get ditado => boolean().withDefault(const Constant(false))();
  TextColumn get dispositivo => text().nullable()();
  TextColumn get versaoApp => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AcaoManejo')
class AcoesManejo extends Table with CamposSync {
  TextColumn get id => text()();
  TextColumn get focoId => text().references(Focos, #id)();
  TextColumn get usuarioId => text()();
  TextColumn get responsavel => text()();
  DateTimeColumn get dataHoraInicio => dateTime()();
  DateTimeColumn get dataHoraFim => dateTime().nullable()();
  TextColumn get metodo => text()();
  TextColumn get metodoTexto => text().nullable()();
  TextColumn get herbicidaProduto => text().nullable()();
  TextColumn get herbicidaConcentracao => text().nullable()();
  RealColumn get herbicidaVolumeL => real().nullable()();
  IntColumn get nIndividuosTratados => integer().nullable()();
  RealColumn get areaTratadaM2 => real().nullable()();
  IntColumn get nPessoas => integer()();
  RealColumn get horas => real()();
  TextColumn get destinacao => text().nullable()();
  BoolColumn get epiUtilizado => boolean().nullable()();
  TextColumn get condicaoTempo => text().nullable()();
  TextColumn get texto => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Midia')
class Midias extends Table with CamposSync {
  TextColumn get id => text()();
  TextColumn get donoTipo => text()(); // observacao · acao_manejo
  TextColumn get donoId => text()();
  TextColumn get tipo => text().withDefault(const Constant('foto'))();
  TextColumn get momento => text().nullable()(); // antes · depois
  TextColumn get caminhoLocal => text().nullable()();
  TextColumn get caminhoRemoto => text().nullable()();
  RealColumn get lat => real().nullable()();
  RealColumn get lon => real().nullable()();
  DateTimeColumn get tiradaEm => dateTime()();
  IntColumn get tamanhoBytes => integer().nullable()();
  TextColumn get uploadStatus => text().withDefault(const Constant('pendente'))();
  TextColumn get uploadErro => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ListaValor')
class ListaValores extends Table {
  TextColumn get lista => text()();
  TextColumn get codigo => text()();
  TextColumn get rotulo => text()();
  IntColumn get ordem => integer()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {lista, codigo};
}

/// Configurações locais (chave/valor) e marcadores de sincronização.
@DataClassName('Config')
class Configs extends Table {
  TextColumn get chave => text()();
  TextColumn get valor => text()();

  @override
  Set<Column> get primaryKey => {chave};
}

/// Erros de sincronização por registro (aparece em "Pendências").
@DataClassName('ErroSync')
class ErrosSync extends Table {
  TextColumn get tabela => text()();
  TextColumn get registroId => text()();
  TextColumn get mensagem => text()();
  IntColumn get tentativas => integer().withDefault(const Constant(1))();
  DateTimeColumn get ultimaTentativa => dateTime()();

  @override
  Set<Column> get primaryKey => {tabela, registroId};
}
