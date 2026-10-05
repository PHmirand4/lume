import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/formato.dart' as fmt;
import '../../domain/codigos.dart';
import '../../widgets/comuns.dart';
import '../../widgets/marcador_status.dart';
import '../lista/lista_focos_screen.dart';
import 'dados_exportacao.dart';
import 'exportadores.dart';
import 'relatorio_pdf.dart';

enum _Periodo { mes, trimestre, ano, tudo, personalizado }

/// T12 — Exportar / relatório: período + filtros → CSV · GeoJSON · KML ·
/// Darwin Core · PDF → compartilhar.
class ExportarScreen extends ConsumerStatefulWidget {
  const ExportarScreen({super.key});

  @override
  ConsumerState<ExportarScreen> createState() => _ExportarScreenState();
}

class _ExportarScreenState extends ConsumerState<ExportarScreen> {
  _Periodo _periodo = _Periodo.ano;
  DateTimeRange? _personalizado;
  String? _especie;
  final Set<String> _status = {};
  bool _csv = true;
  bool _geojson = true;
  bool _kml = false;
  bool _dwc = true;
  bool _anonimizar = true;
  bool _pdf = true;
  final _obsGestor = TextEditingController();
  bool _gerando = false;

  @override
  void dispose() {
    _obsGestor.dispose();
    super.dispose();
  }

  FiltroFocos get _filtro {
    final agora = DateTime.now();
    DateTime? de;
    DateTime? ate;
    switch (_periodo) {
      case _Periodo.mes:
        de = agora.subtract(const Duration(days: 30));
      case _Periodo.trimestre:
        de = agora.subtract(const Duration(days: 90));
      case _Periodo.ano:
        de = DateTime(agora.year);
      case _Periodo.tudo:
        break;
      case _Periodo.personalizado:
        if (_personalizado != null) {
          de = _personalizado!.start;
          final f = _personalizado!.end;
          ate = DateTime(f.year, f.month, f.day, 23, 59, 59);
        }
    }
    return FiltroFocos(especie: _especie, status: _status, de: de?.toUtc(), ate: ate?.toUtc());
  }

  Future<void> _gerar({bool soVisualizarPdf = false}) async {
    setState(() => _gerando = true);
    try {
      final db = ref.read(databaseProvider);
      final vocab = await ref.read(catalogoRepoProvider).vocabulario();
      final d = await DadosExportacao.coletar(db, _filtro);
      final usuario = ref.read(usuarioAtualProvider).value;
      final responsavel = usuario == null ? '—' : '${usuario.nome}${usuario.funcao == null ? '' : ' (${usuario.funcao})'}';

      if (soVisualizarPdf) {
        final bytes = await gerarRelatorioPdf(
            d: d, vocab: vocab, limite: ref.read(limiteFlonaProvider), responsavel: responsavel, observacoesGestor: _obsGestor.text);
        await Printing.layoutPdf(onLayout: (_) async => bytes, name: 'relatorio_lume.pdf');
        return;
      }

      final carimbo = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final pasta = Directory(p.join((await getTemporaryDirectory()).path, 'lume_export_$carimbo'));
      await pasta.create(recursive: true);
      final arquivos = <XFile>[];
      Future<void> gravar(String nome, String conteudo) async {
        final f = File(p.join(pasta.path, nome));
        await f.writeAsBytes(utf8.encode(conteudo), flush: true);
        arquivos.add(XFile(f.path, name: nome));
      }

      if (_csv) {
        await gravar('focos_$carimbo.csv', csvFocos(d, vocab));
        await gravar('observacoes_$carimbo.csv', csvObservacoes(d, vocab));
        await gravar('manejos_$carimbo.csv', csvManejos(d, vocab));
      }
      if (_geojson) await gravar('focos_$carimbo.geojson', geoJsonFocos(d, vocab));
      if (_kml) await gravar('focos_$carimbo.kml', kmlFocos(d, vocab));
      if (_dwc) await gravar('darwin_core_$carimbo.csv', csvDarwinCore(d, vocab, anonimizar: _anonimizar));
      if (_pdf) {
        final bytes = await gerarRelatorioPdf(
            d: d, vocab: vocab, limite: ref.read(limiteFlonaProvider), responsavel: responsavel, observacoesGestor: _obsGestor.text);
        final f = File(p.join(pasta.path, 'relatorio_$carimbo.pdf'));
        await f.writeAsBytes(bytes, flush: true);
        arquivos.add(XFile(f.path, name: 'relatorio_$carimbo.pdf', mimeType: 'application/pdf'));
      }
      if (arquivos.isEmpty) {
        if (mounted) mostrarMensagem(context, 'Escolha ao menos um formato.');
        return;
      }
      await SharePlus.instance.share(ShareParams(
        files: arquivos,
        subject: 'Lume — dados de EEI da Flona de Pacotuba',
        text: '${d.focos.length} focos, ${d.observacoes.length} observações e ${d.manejos.length} manejos.',
      ));
    } catch (e) {
      if (mounted) mostrarMensagem(context, 'Erro ao exportar: $e');
    } finally {
      if (mounted) setState(() => _gerando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final especies = ref.watch(especiesProvider).value ?? const [];
    final focos = ref.watch(focosProvider).value ?? const [];
    final filtro = _filtro;
    final qtd = focos.where(filtro.aceita).length;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Exportar e relatório')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          const TituloSecao('Período'),
          OpcoesChips(
            permitirLimpar: false,
            opcoes: [
              (_Periodo.mes.name, 'Últimos 30 dias'),
              (_Periodo.trimestre.name, 'Últimos 90 dias'),
              (_Periodo.ano.name, 'Este ano'),
              (_Periodo.tudo.name, 'Tudo'),
              (_Periodo.personalizado.name, _personalizado == null
                  ? 'Escolher…'
                  : '${fmt.data(_personalizado!.start)} – ${fmt.data(_personalizado!.end)}'),
            ],
            valor: _periodo.name,
            aoMudar: (v) async {
              final escolhido = _Periodo.values.byName(v!);
              if (escolhido == _Periodo.personalizado) {
                final r = await showDateRangePicker(
                    context: context, firstDate: DateTime(2020), lastDate: DateTime.now(), initialDateRange: _personalizado);
                if (r == null) return;
                _personalizado = r;
              }
              setState(() => _periodo = escolhido);
            },
          ),
          const TituloSecao('Filtros'),
          DropdownButtonFormField<String?>(
            initialValue: _especie,
            decoration: const InputDecoration(labelText: 'Espécie'),
            items: [
              const DropdownMenuItem(value: null, child: Text('Todas')),
              for (final e in especies) DropdownMenuItem(value: e.id, child: Text(e.nomesPopulares.first)),
            ],
            onChanged: (v) => setState(() => _especie = v),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final s in StatusFoco.todos)
              FilterChip(
                avatar: MarcadorStatus(status: s, tamanho: 14),
                label: Text(EstiloStatus.de(s).rotulo),
                showCheckmark: false,
                selected: _status.contains(s),
                onSelected: (v) => setState(() => v ? _status.add(s) : _status.remove(s)),
              ),
          ]),
          const SizedBox(height: 6),
          Text(_status.isEmpty ? 'Todos os status.' : 'Só os status marcados.', style: t.bodySmall),
          const SizedBox(height: 12),
          Aviso('$qtd ${qtd == 1 ? 'foco entra' : 'focos entram'} na exportação.'),
          const TituloSecao('Formatos'),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _csv,
            onChanged: (v) => setState(() => _csv = v!),
            title: const Text('CSV (focos, observações, manejos)'),
            subtitle: const Text('Equivalem às planilhas do Guia do ICMBio'),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _geojson,
            onChanged: (v) => setState(() => _geojson = v!),
            title: const Text('GeoJSON'),
            subtitle: const Text('QGIS e outros SIG'),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _kml,
            onChanged: (v) => setState(() => _kml = v!),
            title: const Text('KML'),
            subtitle: const Text('Google Earth'),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _dwc,
            onChanged: (v) => setState(() => _dwc = v!),
            title: const Text('Darwin Core (CSV)'),
            subtitle: const Text('Padrão de biodiversidade (ICMBio, SiBBr)'),
          ),
          if (_dwc)
            SwitchListTile(
              contentPadding: const EdgeInsets.only(left: 16),
              value: _anonimizar,
              onChanged: (v) => setState(() => _anonimizar = v),
              title: const Text('Anonimizar quem registrou'),
              subtitle: const Text('recordedBy vira um código (LGPD)'),
            ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _pdf,
            onChanged: (v) => setState(() => _pdf = v!),
            title: const Text('Relatório PDF do período'),
            subtitle: const Text('Resumo, detecção precoce, espécies, manejo, mapa e tabela'),
          ),
          if (_pdf) ...[
            const SizedBox(height: 6),
            TextField(
              controller: _obsGestor,
              minLines: 3,
              maxLines: 8,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Observações e recomendações (vão no PDF)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _gerando ? null : () => _gerar(soVisualizarPdf: true),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Visualizar / imprimir PDF'),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 60,
            child: FilledButton.icon(
              onPressed: _gerando ? null : _gerar,
              icon: _gerando
                  ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : const Icon(Icons.ios_share),
              label: Text('Gerar e compartilhar', style: estiloCodigo(tamanho: 16, cor: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
