import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lume/data/importacao/leitor_planilha.dart';
import 'package:lume/domain/importacao.dart';

/// Lê as planilhas reais enviadas pela equipe (pasta `arquivos/`, fora do
/// git). Sem a pasta, os testes são pulados.
void main() {
  final lista = File('arquivos/Lista EEI em UC federais_2025 (1).xlsx');

  test('Lista de EEI em UC federais 2025 (arquivo real do ICMBio)', () {
    final p = lerPlanilha(lista.readAsBytesSync(), lista.path);
    expect(p.abas.map((a) => a.nome), containsAll(['Lista Fauna', 'Lista Flora']));
    final abas = p.abas.where((a) => a.linhas.isNotEmpty && ehListaOficial(a.linhas.first)).toList();
    expect(abas.map((a) => a.nome).toSet(), {'Lista Fauna', 'Lista Flora'});
    final linhas = [for (final a in abas) ...lerListaOficial(a.linhas)];
    expect(linhas.length, greaterThan(2500));
    final pacotuba = linhas.where((l) => l.cnuc == '0000.00.0101').toList();
    expect(pacotuba.map((l) => l.especie), containsAll(['Acacia mangium', 'Aquarana catesbeiana']));
    expect(pacotuba.where((l) => l.animal), hasLength(11));
    expect(pacotuba.where((l) => !l.animal), hasLength(8));
  }, skip: lista.existsSync() ? false : 'pasta arquivos/ ausente');
}
