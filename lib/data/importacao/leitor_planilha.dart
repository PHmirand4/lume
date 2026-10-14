import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:xml/xml.dart';

class FalhaPlanilha implements Exception {
  FalhaPlanilha(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}

/// Uma aba da planilha, como texto.
class AbaPlanilha {
  const AbaPlanilha({required this.nome, required this.linhas});

  final String nome;
  final List<List<String>> linhas;
}

/// Planilha lida: todas as abas, como texto (a primeira é a principal).
class Planilha {
  const Planilha(this.abas);

  final List<AbaPlanilha> abas;

  String get nomeAba => abas.first.nome;
  List<List<String>> get linhas => abas.first.linhas;
}

/// Lê .xlsx (todas as abas) ou .csv/.txt (separador detectado) como texto.
/// Funciona em Android e na web (não usa arquivos do sistema).
Planilha lerPlanilha(Uint8List bytes, String nomeArquivo) {
  final nome = nomeArquivo.toLowerCase();
  if (nome.endsWith('.xlsx') || nome.endsWith('.xlsm')) return _lerXlsx(bytes);
  if (nome.endsWith('.csv') || nome.endsWith('.txt') || nome.endsWith('.tsv')) return _lerCsv(bytes);
  if (nome.endsWith('.xls')) {
    throw FalhaPlanilha('Arquivo .xls (Excel antigo) não é lido. No Excel, use "Salvar como" → .xlsx ou .csv.');
  }
  throw FalhaPlanilha('Formato não reconhecido. Use .xlsx ou .csv.');
}

Planilha _lerCsv(Uint8List bytes) {
  String texto;
  try {
    texto = utf8.decode(bytes);
  } on FormatException {
    texto = latin1.decode(bytes); // CSV salvo pelo Excel em Windows-1252
  }
  if (texto.startsWith('﻿')) texto = texto.substring(1);
  final linhas = Csv().decode(texto);
  return Planilha([
    AbaPlanilha(nome: 'CSV', linhas: [
      for (final l in linhas) [for (final c in l) c?.toString() ?? ''],
    ]),
  ]);
}

Planilha _lerXlsx(Uint8List bytes) {
  final Archive zip;
  try {
    zip = ZipDecoder().decodeBytes(bytes);
  } catch (_) {
    throw FalhaPlanilha('Não foi possível abrir o arquivo .xlsx (arquivo corrompido ou protegido por senha).');
  }
  XmlDocument? xml(String caminho) {
    final f = zip.findFile(caminho);
    return f == null ? null : XmlDocument.parse(utf8.decode(f.content));
  }

  // Textos compartilhados (a maioria das células de texto aponta para cá).
  final compartilhados = <String>[
    for (final si in xml('xl/sharedStrings.xml')?.findAllElements('si') ?? const <XmlElement>[])
      si.findAllElements('t').map((t) => t.innerText).join(),
  ];

  // Abas do livro, na ordem, achadas pelo relacionamento (o nome do arquivo varia).
  final alvos = <String, String>{
    for (final rel in xml('xl/_rels/workbook.xml.rels')?.findAllElements('Relationship') ?? const <XmlElement>[])
      rel.getAttribute('Id')!: rel.getAttribute('Target')!,
  };
  final abas = <AbaPlanilha>[];
  final folhas = xml('xl/workbook.xml')?.findAllElements('sheet').toList() ?? const <XmlElement>[];
  for (var k = 0; k < folhas.length; k++) {
    final aba = folhas[k];
    final rid = aba.getAttribute('r:id') ??
        aba.attributes.where((a) => a.name.local == 'id').map((a) => a.value).firstOrNull;
    final alvo = alvos[rid] ?? 'worksheets/sheet${k + 1}.xml';
    final folha = xml(alvo.startsWith('/') ? alvo.substring(1) : 'xl/$alvo');
    if (folha == null) continue;
    abas.add(AbaPlanilha(nome: aba.getAttribute('name') ?? 'Aba ${k + 1}', linhas: _linhas(folha, compartilhados)));
  }
  if (abas.isEmpty) throw FalhaPlanilha('A planilha não tem abas que dê para ler.');
  return Planilha(abas);
}

List<List<String>> _linhas(XmlDocument folha, List<String> compartilhados) {
  final linhas = <List<String>>[];
  for (final row in folha.findAllElements('row')) {
    final valores = <String>[];
    for (final c in row.findElements('c')) {
      final ref = c.getAttribute('r');
      if (ref != null) {
        final col = _indiceColuna(ref);
        while (valores.length < col) {
          valores.add('');
        }
      }
      final tipo = c.getAttribute('t');
      final v = c.getElement('v')?.innerText ?? '';
      final i = int.tryParse(v) ?? -1;
      valores.add(switch (tipo) {
        's' => i >= 0 && i < compartilhados.length ? compartilhados[i] : '',
        'inlineStr' => c.findAllElements('t').map((t) => t.innerText).join(),
        'b' => v == '1' ? 'sim' : 'não',
        _ => v,
      });
    }
    final n = int.tryParse(row.getAttribute('r') ?? '');
    // Mantém o número da linha do Excel (linhas vazias no meio viram linhas vazias).
    if (n != null) {
      while (linhas.length < n - 1) {
        linhas.add(const []);
      }
    }
    linhas.add(valores);
  }
  return linhas;
}

/// "AB12" → 27 (coluna A = 0).
int _indiceColuna(String ref) {
  var n = 0;
  for (final ch in ref.codeUnits) {
    if (ch < 65 || ch > 90) break;
    n = n * 26 + (ch - 64);
  }
  return n - 1;
}
