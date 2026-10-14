import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import 'database.dart';

/// Carrega espécies e vocabulários dos assets na primeira execução
/// (ou quando a versão do seed aumenta). Depois disso, novidades vêm do servidor.
/// Espécies: catálogo nacional (Base de Dados Nacional de EEI — Instituto Hórus)
/// mais as 10 espécies manejadas na Flona de Pacotuba.
class Seeder {
  Seeder(this.db);

  final AppDatabase db;

  static const _chaveVersaoEspecies = 'seed_especies_versao';
  static const _chaveVersaoListas = 'seed_listas_versao';
  static const _chaveVersaoListaUc = 'seed_lista_uc_versao';

  Future<void> executar() async {
    await _seedListas();
    await _seedEspecies();
    await _seedListaUc();
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
    final dataSeed = DateTime.utc(2026, 10, 14);
    final existentes = {for (final e in await db.select(db.especies).get()) e.id: e};
    await db.batch((b) {
      for (final e in (json['especies'] as List).cast<Map<String, dynamic>>()) {
        final linha = EspeciesCompanion.insert(
          id: e['id'] as String,
          prefixo: e['prefixo'] as String,
          nomeCientifico: e['nome_cientifico'] as String,
          nomesPopulares: (e['nomes_populares'] as List).cast<String>(),
          familia: Value(e['familia'] as String?),
          formaVida: e['forma_vida'] as String,
          descricaoIdentificacao: Value(_vazioNulo(e['descricao_identificacao'] as String?)),
          confusaoCom: Value(_vazioNulo(e['confusao_com'] as String?)),
          controleCitado: Value(_vazioNulo(e['controle_citado'] as String?)),
          metodosSugeridos: (e['metodos_sugeridos'] as List).cast<String>(),
          fotosReferencia: const [],
          ordem: Value(e['ordem'] as int),
          origemNativa: Value(_vazioNulo(e['origem_nativa'] as String?)),
          ambientesInvasao: Value(_vazioNulo(e['ambientes_invasao'] as String?)),
          impactos: Value(_vazioNulo(e['impactos'] as String?)),
          controleLiteratura: Value(_vazioNulo(e['controle_literatura'] as String?)),
          nativaBrasil: Value(e['nativa_brasil'] as bool? ?? false),
          fonte: Value(_vazioNulo(e['fonte'] as String?)),
          reino: Value(e['reino'] as String? ?? 'planta'),
          naListaOficialIcmbio: Value(e['na_lista_oficial_icmbio'] as bool?),
          createdAt: dataSeed,
          updatedAt: dataSeed,
          syncStatus: const Value('enviado'),
        );
        final atual = existentes[e['id']];
        if (atual == null) {
          b.insert(db.especies, linha);
        } else if (atual.syncStatus == 'enviado' && atual.updatedAt == atual.createdAt) {
          // Atualiza só o que ninguém editou desde o seed anterior.
          b.replace(db.especies, linha.copyWith(createdAt: Value(atual.createdAt)));
        }
      }
    });
    await _gravarVersao(_chaveVersaoEspecies, versao);
  }

  /// Lista de EEI em UC federais (ICMBio) por Flona. Só entra se for de um
  /// ciclo mais novo que o guardado (a importação da planilha também atualiza).
  Future<void> _seedListaUc() async {
    final json = jsonDecode(await rootBundle.loadString('assets/seed/lista_uc.json')) as Map<String, dynamic>;
    final ciclo = json['ciclo'] as int;
    if (await _versaoAtual(_chaveVersaoListaUc) >= ciclo) return;
    final guardado = await db
        .customSelect('SELECT MAX(ciclo) AS c FROM especies_unidade', readsFrom: {db.especiesUnidade})
        .getSingle();
    if ((guardado.readNullable<int>('c') ?? 0) < ciclo) {
      final existentes = {for (final e in await db.select(db.especies).get()) e.id};
      await db.transaction(() async {
        await db.delete(db.especiesUnidade).go();
        await db.batch((b) {
          (json['unidades'] as Map<String, dynamic>).forEach((unidade, ids) {
            for (final id in (ids as List).cast<String>().where(existentes.contains)) {
              b.insert(
                db.especiesUnidade,
                EspeciesUnidadeCompanion.insert(
                    unidadeId: unidade, especieId: id, ciclo: ciclo, fonte: Value(json['fonte'] as String?)),
              );
            }
          });
        });
      });
    }
    await _gravarVersao(_chaveVersaoListaUc, ciclo);
  }

  static String? _vazioNulo(String? s) => (s == null || s.isEmpty) ? null : s;
}
