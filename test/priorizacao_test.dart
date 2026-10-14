import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lume/domain/priorizacao.dart';

void main() {
  final criterios = criteriosDeJson(File('assets/seed/priorizacao.json').readAsStringSync());

  test('ferramenta do ICMBio: 12 critérios, índice máximo 36', () {
    expect(criterios, hasLength(12));
    expect(indiceMaximo(criterios), 36);
    expect(criterios.first.opcoes.first.pontos, 6, reason: 'único local = 6 pontos');
  });

  test('índice é a soma das opções; critério sem resposta vale 0', () {
    // Exemplo do Manual (EEI3): 6+2+2+4+3+0+2+0+0+0+2+2 = 23.
    String cod(int id, String inicio) =>
        criterios[id - 1].opcoes.firstWhere((o) => o.rotulo.toLowerCase().startsWith(inicio)).codigo;
    final r = {
      1: cod(1, 'único'),
      2: cod(2, 'baixa'),
      3: cod(3, 'pouca chance de erradicação'),
      4: cod(4, 'inferido por bibliografia e'),
      5: cod(5, 'inferido por bibliografia e'),
      6: cod(6, 'desconhecido'),
      7: cod(7, 'observado'),
      8: cod(8, 'a uc não tem'),
      9: cod(9, 'a uc não tem'),
      10: cod(10, 'não'),
      11: cod(11, 'sim'),
      12: cod(12, 'sim'),
    };
    expect(indicePriorizacao(r, criterios), 23);
    expect(priorizacaoCompleta(r, criterios), isTrue);
    expect(indicePriorizacao({1: cod(1, 'único')}, criterios), 6);
    expect(respostasDeJson(respostasParaJson(r)), r);
  });
}
