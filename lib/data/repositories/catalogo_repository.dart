import 'package:drift/drift.dart';

import '../local/database.dart';

/// Vocabulários indexados por lista e código, para traduzir códigos em rótulos.
class Vocabulario {
  Vocabulario(this._itens);

  final Map<String, List<ListaValor>> _itens;

  static final vazio = Vocabulario(const {});

  List<ListaValor> itens(String lista) =>
      (_itens[lista] ?? const []).where((v) => v.ativo).toList();

  String rotulo(String lista, String? codigo) {
    if (codigo == null) return '—';
    for (final v in _itens[lista] ?? const <ListaValor>[]) {
      if (v.codigo == codigo) return v.rotulo;
    }
    return codigo;
  }
}

/// Espécies e vocabulários controlados.
class CatalogoRepository {
  CatalogoRepository(this.db);

  final AppDatabase db;

  Stream<List<Especie>> observarEspecies() => (db.select(db.especies)
        ..where((e) => e.ativa.equals(true) & e.deleted.equals(false))
        ..orderBy([(e) => OrderingTerm.asc(e.ordem)]))
      .watch();

  Future<Especie?> especie(String id) =>
      (db.select(db.especies)..where((e) => e.id.equals(id))).getSingleOrNull();

  Stream<Vocabulario> observarVocabulario() =>
      (db.select(db.listaValores)..orderBy([(v) => OrderingTerm.asc(v.ordem)]))
          .watch()
          .map((linhas) {
        final m = <String, List<ListaValor>>{};
        for (final l in linhas) {
          m.putIfAbsent(l.lista, () => []).add(l);
        }
        return Vocabulario(m);
      });

  Future<Vocabulario> vocabulario() => observarVocabulario().first;
}
