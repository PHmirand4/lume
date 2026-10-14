/// Ferramenta de Priorização de EEI pela UC (ICMBio/CMEEI, 2025): 12
/// critérios, cada um com opções pontuadas; a soma é o Índice de Priorização.
/// Quanto maior o índice, maior a prioridade de manejo da espécie na unidade.
/// O resultado orienta, mas não obriga: a decisão é da equipe gestora.
library;

import 'dart:convert';

class OpcaoPriorizacao {
  const OpcaoPriorizacao({required this.codigo, required this.rotulo, required this.pontos});

  final String codigo;
  final String rotulo;
  final int pontos;
}

class CriterioPriorizacao {
  const CriterioPriorizacao({
    required this.id,
    required this.titulo,
    required this.curto,
    required this.ajuda,
    required this.opcoes,
  });

  final int id;
  final String titulo;
  final String curto;
  final String ajuda;
  final List<OpcaoPriorizacao> opcoes;

  int get maximo => opcoes.fold(0, (m, o) => o.pontos > m ? o.pontos : m);

  OpcaoPriorizacao? opcao(String? codigo) => opcoes.where((o) => o.codigo == codigo).firstOrNull;
}

/// Critérios lidos de `assets/seed/priorizacao.json`.
List<CriterioPriorizacao> criteriosDeJson(String texto) {
  final json = jsonDecode(texto) as Map<String, dynamic>;
  return [
    for (final c in (json['criterios'] as List).cast<Map<String, dynamic>>())
      CriterioPriorizacao(
        id: c['id'] as int,
        titulo: c['titulo'] as String,
        curto: c['curto'] as String,
        ajuda: (c['ajuda'] as String?) ?? '',
        opcoes: [
          for (final o in (c['opcoes'] as List).cast<Map<String, dynamic>>())
            OpcaoPriorizacao(codigo: o['codigo'] as String, rotulo: o['rotulo'] as String, pontos: o['pontos'] as int),
        ],
      ),
  ];
}

/// Índice de Priorização: soma dos pontos das respostas (critério sem resposta vale 0).
int indicePriorizacao(Map<int, String> respostas, List<CriterioPriorizacao> criterios) =>
    criterios.fold(0, (soma, c) => soma + (c.opcao(respostas[c.id])?.pontos ?? 0));

/// Índice máximo possível (todos os critérios na melhor opção).
int indiceMaximo(List<CriterioPriorizacao> criterios) => criterios.fold(0, (s, c) => s + c.maximo);

/// Avaliação completa: todos os critérios respondidos.
bool priorizacaoCompleta(Map<int, String> respostas, List<CriterioPriorizacao> criterios) =>
    criterios.every((c) => c.opcao(respostas[c.id]) != null);

/// Respostas guardadas no banco como JSON ({"1": "codigo", …}).
String respostasParaJson(Map<int, String> r) => jsonEncode({for (final e in r.entries) '${e.key}': e.value});

Map<int, String> respostasDeJson(String texto) {
  final m = jsonDecode(texto) as Map<String, dynamic>;
  return {for (final e in m.entries) int.parse(e.key): e.value as String};
}
