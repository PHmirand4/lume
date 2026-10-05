import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/formato.dart' as fmt;
import '../../data/geo/limite_flona.dart';
import '../../data/repositories/catalogo_repository.dart';
import '../../domain/codigos.dart';
import 'dados_exportacao.dart';

const _verde = PdfColor.fromInt(0xFF38613F);
const _verdeNoite = PdfColor.fromInt(0xFF1E3824);
const _nevoa = PdfColor.fromInt(0xFFEEF4EF);
const _borda = PdfColor.fromInt(0xFFD5DBD7);
const _cinza = PdfColor.fromInt(0xFF4A5650);
const _laranja = PdfColor.fromInt(0xFFC2410C);

const _corStatus = {
  StatusFoco.detectado: PdfColor.fromInt(0xFFE35205),
  StatusFoco.emControle: PdfColor.fromInt(0xFF2C6BAA),
  StatusFoco.rebrotou: PdfColor.fromInt(0xFFB42828),
  StatusFoco.controlado: PdfColor.fromInt(0xFF5E9B52),
  StatusFoco.erradicado: PdfColor.fromInt(0xFF38613F),
  StatusFoco.descartado: PdfColor.fromInt(0xFF8A958F),
};

/// Relatório PDF do período (§17.2), inspirado no roteiro do Guia do ICMBio.
Future<Uint8List> gerarRelatorioPdf({
  required DadosExportacao d,
  required Vocabulario vocab,
  required LimiteFlona limite,
  required String responsavel,
  String observacoesGestor = '',
}) async {
  Future<pw.Font> fonte(String a) async => pw.Font.ttf(await rootBundle.load(a));
  final tema = pw.ThemeData.withFont(
    base: await fonte('assets/fonts/IBMPlexSans-400.ttf'),
    bold: await fonte('assets/fonts/IBMPlexSans-600.ttf'),
    italic: await fonte('assets/fonts/IBMPlexSans-400.ttf'),
  );
  final titulo = await fonte('assets/fonts/ArchivoExpanded-800.ttf');
  final mono = await fonte('assets/fonts/IBMPlexMono-Regular.ttf');

  final agora = DateTime.now();
  final periodo = d.de == null
      ? 'Todo o histórico'
      : '${fmt.data(d.de!)} a ${fmt.data(d.ate ?? agora.toUtc())}';
  bool noPeriodo(DateTime x) =>
      (d.de == null || !x.isBefore(d.de!)) && (d.ate == null || !x.isAfter(d.ate!));

  final focos = d.focos.where((f) => f.foco.status != StatusFoco.descartado).toList();
  final novos = focos.where((f) => noPeriodo(f.foco.primeiraDeteccaoEm)).toList();
  int comStatus(Set<String> s) => focos.where((f) => s.contains(f.foco.status)).length;
  final precoces = novos.where((f) => f.foco.deteccaoPrecoce).toList();
  final revisitas = d.observacoes.where((o) => o.tipo == TipoObservacao.revisita).toList();
  final deteccoes = d.observacoes.where((o) => o.tipo == TipoObservacao.deteccao).toList();

  pw.Widget h1(String t) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 18, bottom: 8),
        child: pw.Text(t, style: pw.TextStyle(font: titulo, fontSize: 13, color: _verde)),
      );
  pw.Widget p(String t, {PdfColor? cor, double tam = 10}) =>
      pw.Text(t, style: pw.TextStyle(fontSize: tam, color: cor, lineSpacing: 2));
  pw.Widget tabela(List<String> cab, List<List<String>> linhas, {Map<int, pw.TableColumnWidth>? larguras}) =>
      linhas.isEmpty
          ? p('Nenhum registro no período.', cor: _cinza)
          : pw.TableHelper.fromTextArray(
              headers: cab,
              data: linhas,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.5, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: _verdeNoite),
              cellStyle: const pw.TextStyle(fontSize: 8.5),
              cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              oddRowDecoration: const pw.BoxDecoration(color: _nevoa),
              border: const pw.TableBorder(horizontalInside: pw.BorderSide(color: _borda, width: 0.5)),
              columnWidths: larguras,
            );
  pw.Widget numero(String valor, String rotulo, {PdfColor cor = _verde}) => pw.Expanded(
        child: pw.Container(
          margin: const pw.EdgeInsets.only(right: 6),
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(border: pw.Border.all(color: _borda), borderRadius: pw.BorderRadius.circular(4)),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(valor, style: pw.TextStyle(font: titulo, fontSize: 18, color: cor)),
            pw.Text(rotulo, style: const pw.TextStyle(fontSize: 8, color: _cinza)),
          ]),
        ),
      );

  // Por espécie
  final especies = <String, ({String nome, int focos, int ind, double area, double tratada})>{};
  for (final f in focos) {
    final id = f.foco.especieId;
    final atual = especies[id] ?? (nome: f.especie.nomeCientifico, focos: 0, ind: 0, area: 0.0, tratada: 0.0);
    especies[id] = (nome: atual.nome, focos: atual.focos + 1, ind: atual.ind, area: atual.area, tratada: atual.tratada);
  }
  for (final o in deteccoes) {
    final f = d.focoPorId[o.focoId];
    if (f == null || !especies.containsKey(f.foco.especieId)) continue;
    final a = especies[f.foco.especieId]!;
    especies[f.foco.especieId] =
        (nome: a.nome, focos: a.focos, ind: a.ind + (o.nIndividuos ?? 0), area: a.area + (o.areaM2 ?? 0), tratada: a.tratada);
  }
  for (final m in d.manejos) {
    final f = d.focoPorId[m.focoId];
    if (f == null || !especies.containsKey(f.foco.especieId)) continue;
    final a = especies[f.foco.especieId]!;
    especies[f.foco.especieId] =
        (nome: a.nome, focos: a.focos, ind: a.ind, area: a.area, tratada: a.tratada + (m.areaTratadaM2 ?? 0));
  }

  // Manejo por método
  final metodos = <String, ({int acoes, int ind, double area, double esforco})>{};
  final herbicidas = <String, double>{};
  for (final m in d.manejos) {
    final a = metodos[m.metodo] ?? (acoes: 0, ind: 0, area: 0.0, esforco: 0.0);
    metodos[m.metodo] = (
      acoes: a.acoes + 1,
      ind: a.ind + (m.nIndividuosTratados ?? 0),
      area: a.area + (m.areaTratadaM2 ?? 0),
      esforco: a.esforco + m.nPessoas * m.horas,
    );
    if (m.herbicidaProduto != null) {
      herbicidas[m.herbicidaProduto!] = (herbicidas[m.herbicidaProduto!] ?? 0) + (m.herbicidaVolumeL ?? 0);
    }
  }
  final esforcoTotal = d.manejos.fold<double>(0, (s, m) => s + m.nPessoas * m.horas);

  final doc = pw.Document(title: 'Relatório Lume — Flona de Pacotuba', author: responsavel, creator: 'Lume');
  doc.addPage(pw.MultiPage(
    theme: tema,
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 40),
    header: (c) => c.pageNumber == 1
        ? pw.SizedBox()
        : pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Text('Lume · Relatório de EEI · Flona de Pacotuba · $periodo',
                style: const pw.TextStyle(fontSize: 8, color: _cinza)),
          ),
    footer: (c) => pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Text('Página ${c.pageNumber} de ${c.pagesCount}', style: const pw.TextStyle(fontSize: 8, color: _cinza)),
    ),
    build: (c) => [
      // 1. Identificação
      pw.Container(
        padding: const pw.EdgeInsets.all(14),
        decoration: const pw.BoxDecoration(color: _verdeNoite),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('LUME', style: pw.TextStyle(font: titulo, fontSize: 22, color: PdfColors.white)),
          pw.SizedBox(height: 2),
          pw.Text('Relatório de monitoramento e manejo de espécies exóticas invasoras',
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.white)),
        ]),
      ),
      pw.SizedBox(height: 10),
      pw.Table(columnWidths: const {0: pw.FixedColumnWidth(120)}, children: [
        for (final (k, v) in [
          ('Unidade de conservação', 'Floresta Nacional de Pacotuba (ICMBio) — Cachoeiro de Itapemirim/ES'),
          ('Período', periodo),
          ('Responsável', responsavel),
          ('Gerado em', fmt.dataHora(agora.toUtc())),
        ])
          pw.TableRow(children: [
            pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 2), child: p(k, cor: _cinza)),
            pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 2), child: p(v)),
          ]),
      ]),

      // 2. Resumo
      h1('1. Resumo'),
      pw.Row(children: [
        numero('${novos.length}', 'focos novos no período'),
        numero('${comStatus(StatusFoco.ativos)}', 'focos ativos (hoje)', cor: _laranja),
        numero('${comStatus({StatusFoco.controlado})}', 'controlados'),
        numero('${comStatus({StatusFoco.erradicado})}', 'erradicados'),
      ]),
      pw.SizedBox(height: 6),
      pw.Row(children: [
        numero('${d.observacoes.length}', 'observações'),
        numero('${d.manejos.length}', 'ações de manejo'),
        numero(fmt.numero(esforcoTotal), 'pessoa·hora de esforço'),
        numero('${especies.length}', 'espécies registradas'),
      ]),

      // 3. Detecção precoce
      h1('2. Detecções precoces no período'),
      p('Casos de detecção precoce e resposta rápida dispensam projeto autorizado (IN ICMBio 19/2025, art. 12).',
          cor: _cinza, tam: 8.5),
      pw.SizedBox(height: 4),
      tabela(['Código', 'Espécie', 'Detectado em', 'Motivos'], [
        for (final f in precoces)
          [f.foco.codigo, f.nomeExibicao, fmt.data(f.foco.primeiraDeteccaoEm), f.foco.motivosPrecoce.join('; ')],
      ], larguras: const {0: pw.FixedColumnWidth(60), 2: pw.FixedColumnWidth(62)}),

      // 4. Por espécie
      h1('3. Por espécie'),
      tabela(['Espécie', 'Focos', 'Indivíduos registrados', 'Área registrada (m²)', 'Área tratada (m²)'], [
        for (final e in especies.values)
          [e.nome, '${e.focos}', '${e.ind}', fmt.numero(e.area), fmt.numero(e.tratada)],
      ]),

      // 5. Manejo
      h1('4. Ações de manejo'),
      tabela(['Método', 'Ações', 'Indivíduos tratados', 'Área tratada (m²)', 'Esforço (pessoa·h)'], [
        for (final e in metodos.entries)
          [vocab.rotulo(Listas.metodoManejo, e.key), '${e.value.acoes}', '${e.value.ind}', fmt.numero(e.value.area), fmt.numero(e.value.esforco)],
      ]),
      if (herbicidas.isNotEmpty) ...[
        pw.SizedBox(height: 6),
        p('Herbicidas usados: ${herbicidas.entries.map((e) => '${e.key}${e.value > 0 ? ' (${fmt.numero(e.value)} L)' : ''}').join('; ')}.'),
      ],

      // 6. Monitoramento pós-controle
      h1('5. Monitoramento pós-controle'),
      p('Revisitas: ${revisitas.length} · ausências: ${revisitas.where((o) => o.presenca == Presenca.ausente).length} · '
          'rebrotas: ${revisitas.where((o) => o.resultado == 'rebrota').length} · '
          'focos com rebrota (status atual): ${comStatus({StatusFoco.rebrotou})}.'),

      // 7. Mapa
      h1('6. Mapa dos focos'),
      pw.Container(
        height: 300,
        decoration: pw.BoxDecoration(border: pw.Border.all(color: _borda)),
        child: pw.CustomPaint(
          size: const PdfPoint(523, 300),
          painter: (canvas, size) => _desenharMapa(canvas, size, limite, d),
        ),
      ),
      pw.SizedBox(height: 4),
      pw.Wrap(spacing: 10, children: [
        for (final e in _corStatus.entries)
          pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
            pw.Container(width: 7, height: 7, decoration: pw.BoxDecoration(color: e.value, shape: pw.BoxShape.circle)),
            pw.SizedBox(width: 3),
            pw.Text(vocab.rotulo(Listas.statusFoco, e.key), style: const pw.TextStyle(fontSize: 8)),
          ]),
        pw.Text('Limite: ICMBio. Coordenadas WGS84.', style: const pw.TextStyle(fontSize: 8, color: _cinza)),
      ]),

      // 9. Observações do gestor
      h1('7. Observações e recomendações'),
      p(observacoesGestor.trim().isEmpty ? '—' : observacoesGestor.trim()),

      // 8. Tabela detalhada
      pw.NewPage(),
      h1('Anexo — Tabela de focos'),
      tabela(['Código', 'Espécie', 'Status', 'Latitude', 'Longitude', '1ª detecção', 'Última visita'], [
        for (final f in d.focos)
          [
            f.foco.codigo,
            f.nomeExibicao,
            vocab.rotulo(Listas.statusFoco, f.foco.status),
            f.foco.lat.toStringAsFixed(6),
            f.foco.lon.toStringAsFixed(6),
            fmt.data(f.foco.primeiraDeteccaoEm),
            fmt.data(f.foco.ultimaVisitaEm),
          ],
      ]),
      pw.SizedBox(height: 12),
      pw.Text('Gerado pelo Lume (ferramenta de apoio, não oficial do ICMBio).',
          style: pw.TextStyle(fontSize: 8, color: _cinza, font: mono)),
    ],
  ));
  return doc.save();
}

/// Desenha o limite da Flona e os focos (projeção equirretangular local).
void _desenharMapa(PdfGraphics g, PdfPoint size, LimiteFlona limite, DadosExportacao d) {
  final b = limite.limites;
  var sul = b.sul, norte = b.norte, oeste = b.oeste, leste = b.leste;
  for (final f in d.focos) {
    sul = math.min(sul, f.foco.lat);
    norte = math.max(norte, f.foco.lat);
    oeste = math.min(oeste, f.foco.lon);
    leste = math.max(leste, f.foco.lon);
  }
  final kx = math.cos((sul + norte) / 2 * math.pi / 180);
  final largura = (leste - oeste) * kx;
  final altura = norte - sul;
  const margem = 14.0;
  final escala = math.min((size.x - 2 * margem) / largura, (size.y - 2 * margem) / altura);
  final dx = (size.x - largura * escala) / 2;
  final dy = (size.y - altura * escala) / 2;
  PdfPoint pt(double lat, double lon) => PdfPoint(dx + (lon - oeste) * kx * escala, dy + (lat - sul) * escala);

  // Limite
  final primeiro = pt(limite.anel.first.lat, limite.anel.first.lon);
  g.moveTo(primeiro.x, primeiro.y);
  for (final p in limite.anel.skip(1)) {
    final q = pt(p.lat, p.lon);
    g.lineTo(q.x, q.y);
  }
  g
    ..closePath()
    ..setFillColor(const PdfColor.fromInt(0x1438613F))
    ..setStrokeColor(_verde)
    ..setLineWidth(1.2)
    ..fillPath(evenOdd: false);
  g.moveTo(primeiro.x, primeiro.y);
  for (final p in limite.anel.skip(1)) {
    final q = pt(p.lat, p.lon);
    g.lineTo(q.x, q.y);
  }
  g
    ..closePath()
    ..strokePath();

  // Focos
  for (final f in d.focos) {
    final q = pt(f.foco.lat, f.foco.lon);
    g
      ..setFillColor(_corStatus[f.foco.status] ?? PdfColors.grey)
      ..drawEllipse(q.x, q.y, 3.2, 3.2)
      ..fillPath();
    if (f.foco.deteccaoPrecoce) {
      g
        ..setStrokeColor(const PdfColor.fromInt(0xFFE35205))
        ..setLineWidth(0.8)
        ..drawEllipse(q.x, q.y, 5.5, 5.5)
        ..strokePath();
    }
  }
}
