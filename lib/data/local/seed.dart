import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import 'database.dart';

/// Carrega espécies e vocabulários dos assets na primeira execução
/// (ou quando a versão do seed aumenta). Depois disso, novidades vêm do servidor.
class Seeder {
  Seeder(this.db);

  final AppDatabase db;

  static const _chaveVersaoEspecies = 'seed_especies_versao';
  static const _chaveVersaoListas = 'seed_listas_versao';

  Future<void> executar() async {
    await _seedListas();
    await _seedEspecies();
  }

  Future<int> _versaoAtual(String chave) async {
    final linha = await (db.select(db.configs)..where((c) => c.chave.equals(chave)))
        .getSingleOrNull();
    return int.tryParse(linha?.valor ?? '') ?? 0;
  }

  Future<void> _gravarVersao(String chave, int versao) => db
      .into(db.configs)
      .insertOnConflictUpdate(ConfigsCompanion.insert(chave: chave, valor: '$versao'));

  Future<void> _seedListas() async {
    final json = jsonDecode(await rootBundle.loadString('assets/seed/listas.json'))
        as Map<String, dynamic>;
    final versao = json['versao'] as int;
    if (await _versaoAtual(_chaveVersaoListas) >= versao) return;

    final listas = json['listas'] as Map<String, dynamic>;
    await db.batch((b) {
      listas.forEach((lista, itens) {
        var ordem = 0;
        for (final item in (itens as List)) {
          final par = (item as List).cast<String>();
          b.insert(
            db.listaValores,
            ListaValoresCompanion.insert(
              lista: lista,
              codigo: par[0],
              rotulo: par[1],
              ordem: ordem++,
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
    });
    await _gravarVersao(_chaveVersaoListas, versao);
  }

  Future<void> _seedEspecies() async {
    final json = jsonDecode(await rootBundle.loadString('assets/seed/especies.json'))
        as Map<String, dynamic>;
    final versao = json['versao'] as int;
    if (await _versaoAtual(_chaveVersaoEspecies) >= versao) return;

    // Data antiga: qualquer edição vinda do servidor vence o seed.
    final dataSeed = DateTime.utc(2026, 10, 1);
    await db.batch((b) {
      for (final e in (json['especies'] as List).cast<Map<String, dynamic>>()) {
        b.insert(
          db.especies,
          EspeciesCompanion.insert(
            id: e['id'] as String,
            prefixo: e['prefixo'] as String,
            nomeCientifico: e['nome_cientifico'] as String,
            nomesPopulares: (e['nomes_populares'] as List).cast<String>(),
            familia: Value(e['familia'] as String?),
            formaVida: e['forma_vida'] as String,
            descricaoIdentificacao: Value(e['descricao_identificacao'] as String?),
            confusaoCom: Value(_vazioNulo(e['confusao_com'] as String?)),
            controleCitado: Value(_vazioNulo(e['controle_citado'] as String?)),
            metodosSugeridos: (e['metodos_sugeridos'] as List).cast<String>(),
            fotosReferencia: const [],
            ordem: Value(e['ordem'] as int),
            createdAt: dataSeed,
            updatedAt: dataSeed,
            syncStatus: const Value('enviado'),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
    await _gravarVersao(_chaveVersaoEspecies, versao);
  }

  static String? _vazioNulo(String? s) => (s == null || s.isEmpty) ? null : s;
}
