import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/local/database.dart';
import '../../data/repositories/catalogo_repository.dart';
import '../../domain/codigos.dart';
import '../../domain/priorizacao.dart';
import '../../widgets/comuns.dart';
import '../ocorrencia/seletor_especie.dart';

/// Priorização de EEI para controle e erradicação na unidade (Ferramenta de
/// Priorização do ICMBio, Portaria 510/2025, art. 5º): 12 critérios por
/// espécie; a soma é o Índice de Priorização. O resultado orienta, não obriga.
class PriorizacaoScreen extends ConsumerStatefulWidget {
  const PriorizacaoScreen({super.key, this.especieInicial});

  final String? especieInicial;

  @override
  ConsumerState<PriorizacaoScreen> createState() => _PriorizacaoScreenState();
}

class _PriorizacaoScreenState extends ConsumerState<PriorizacaoScreen> {
  bool _abriuInicial = false;

  Future<void> _avaliar(Especie e) => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => _FormularioPriorizacao(especie: e),
      ));

  Future<void> _exportar(List<(Especie, Priorizacao?)> linhas, List<CriterioPriorizacao> criterios) async {
    final unidade = ref.read(unidadeAtualProvider);
    // Mesmas colunas da aba "Critérios para priorização" da planilha do ICMBio.
    final tabela = <List<Object?>>[
      [
        'Espécie Exótica Invasora com ocorrência na UC',
        for (final c in criterios) ...[c.titulo, 'Pontos'],
        'Índice de Priorização',
      ],
      for (final (e, pr) in linhas)
        if (pr != null)
          [
            e.binomio,
            for (final c in criterios) ...[
              c.opcao(respostasDeJson(pr.respostas)[c.id])?.rotulo ?? '',
              c.opcao(respostasDeJson(pr.respostas)[c.id])?.pontos ?? 0,
            ],
            pr.indice,
          ],
    ];
    if (tabela.length == 1) {
      mostrarMensagem(context, 'Nenhuma espécie avaliada ainda.');
      return;
    }
    final nome = 'priorizacao_${unidade.id}.csv';
    final f = File(p.join((await getTemporaryDirectory()).path, nome));
    await f.writeAsBytes(utf8.encode('﻿${Csv(fieldDelimiter: ';', lineDelimiter: '\n').encode(tabela)}'));
    await SharePlus.instance.share(ShareParams(
      files: [XFile(f.path, name: nome)],
      subject: 'Priorização de EEI — ${unidade.nomeCurto}',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final especies = ref.watch(especiesProvider).value ?? const <Especie>[];
    final lista = ref.watch(listaOficialProvider).value ?? const <String>{};
    final resumos = ref.watch(resumosEspeciesProvider).value ?? const {};
    final avaliacoes = ref.watch(priorizacoesProvider).value ?? const {};
    final criterios = ref.watch(criteriosPriorizacaoProvider).value;
    final unidade = ref.watch(unidadeAtualProvider);
    final t = Theme.of(context).textTheme;
    if (criterios == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final maximo = indiceMaximo(criterios);

    final daUnidade = especies
        .where((e) => e.id != especieOutra && (lista.contains(e.id) || (resumos[e.id]?.ocorrencias ?? 0) > 0))
        .map((e) => (e, avaliacoes[e.id]))
        .toList()
      ..sort((a, b) {
        if ((a.$2 == null) != (b.$2 == null)) return a.$2 == null ? 1 : -1;
        final c = (b.$2?.indice ?? 0).compareTo(a.$2?.indice ?? 0);
        return c != 0 ? c : a.$1.nomeComum.compareTo(b.$1.nomeComum);
      });

    if (!_abriuInicial && widget.especieInicial != null) {
      _abriuInicial = true;
      final e = especies.where((x) => x.id == widget.especieInicial).firstOrNull;
      if (e != null) WidgetsBinding.instance.addPostFrameCallback((_) => _avaliar(e));
    }

    final avaliadas = daUnidade.where((x) => x.$2 != null).length;
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Priorização para controle'),
          Text(unidade.nomeCurto, style: t.bodySmall),
        ]),
        actions: [
          IconButton(
            tooltip: 'Exportar (formato da ferramenta do ICMBio)',
            icon: const Icon(Icons.ios_share),
            onPressed: () => _exportar(daUnidade, criterios),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Aviso(
              'Avalie cada espécie nos 12 critérios da Ferramenta de Priorização do ICMBio. '
              'Quanto maior o índice (máximo $maximo), maior a prioridade de manejo. '
              'O resultado orienta, mas a decisão é da equipe gestora. '
              '$avaliadas de ${daUnidade.length} espécies avaliadas.',
            ),
          ),
          if (daUnidade.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Nenhuma espécie na lista oficial ou registrada nesta unidade.'),
            ),
          for (final (i, (e, pr)) in daUnidade.indexed) ...[
            ListTile(
              minTileHeight: 72,
              leading: pr == null
                  ? const CircleAvatar(
                      backgroundColor: LumeCores.nevoa,
                      foregroundColor: LumeCores.textoSecundario,
                      child: Icon(Icons.pending_outlined),
                    )
                  : CircleAvatar(
                      backgroundColor: i < 3 ? LumeCores.verdeFloresta : LumeCores.selecao,
                      foregroundColor: i < 3 ? Colors.white : LumeCores.verdeNoite,
                      child: Text('${i + 1}º', style: estiloCodigo(tamanho: 14, cor: i < 3 ? Colors.white : null)),
                    ),
              title: Text(capitalizar(e.nomeComum)),
              subtitle: Text(
                [
                  e.binomio,
                  if (!lista.contains(e.id)) 'fora da lista oficial',
                  if (pr != null && !priorizacaoCompleta(respostasDeJson(pr.respostas), criterios)) 'avaliação incompleta',
                ].join(' · '),
                style: t.bodySmall,
              ),
              trailing: pr == null
                  ? const Text('Avaliar')
                  : Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('${pr.indice}', style: estiloCodigo(tamanho: 22, cor: LumeCores.verdeFloresta)),
                      Text('de $maximo', style: t.bodySmall),
                    ]),
              onTap: () => _avaliar(e),
            ),
            const Divider(indent: 72),
          ],
        ],
      ),
    );
  }
}

/// Os 12 critérios de uma espécie, com a soma ao vivo.
class _FormularioPriorizacao extends ConsumerStatefulWidget {
  const _FormularioPriorizacao({required this.especie});

  final Especie especie;

  @override
  ConsumerState<_FormularioPriorizacao> createState() => _FormularioPriorizacaoState();
}

class _FormularioPriorizacaoState extends ConsumerState<_FormularioPriorizacao> {
  final _respostas = <int, String>{};
  final _obs = TextEditingController();
  bool _carregado = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final unidade = ref.read(unidadeAtualProvider);
    ref.read(priorizacaoRepoProvider).atual(unidade.id, widget.especie.id).then((pr) {
      if (!mounted) return;
      setState(() {
        if (pr != null && !pr.deleted) {
          _respostas.addAll(respostasDeJson(pr.respostas));
          _obs.text = pr.observacao ?? '';
        }
        _carregado = true;
      });
    });
  }

  @override
  void dispose() {
    _obs.dispose();
    super.dispose();
  }

  Future<void> _salvar(List<CriterioPriorizacao> criterios) async {
    final usuario = ref.read(usuarioAtualProvider).value;
    if (usuario == null) return;
    setState(() => _salvando = true);
    try {
      final indice = await ref.read(priorizacaoRepoProvider).salvar(
            unidadeId: ref.read(unidadeAtualProvider).id,
            especieId: widget.especie.id,
            respostas: _respostas,
            criterios: criterios,
            usuarioId: usuario.id,
            observacao: _obs.text.trim().isEmpty ? null : _obs.text.trim(),
          );
      if (!mounted) return;
      mostrarMensagem(context, 'Índice de priorização: $indice.');
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final criterios = ref.watch(criteriosPriorizacaoProvider).value ?? const [];
    final t = Theme.of(context).textTheme;
    final indice = indicePriorizacao(_respostas, criterios);
    final faltam = criterios.where((c) => c.opcao(_respostas[c.id]) == null).length;

    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(capitalizar(widget.especie.nomeComum)),
          Text(widget.especie.binomio, style: t.bodySmall!.copyWith(fontStyle: FontStyle.italic)),
        ]),
      ),
      body: !_carregado
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                for (final c in criterios) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 4),
                    child: Text('${c.id}. ${c.titulo}', style: t.titleMedium),
                  ),
                  if (c.ajuda.isNotEmpty)
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        dense: true,
                        title: Text('O que considerar', style: t.labelMedium!.copyWith(color: LumeCores.verdeFloresta)),
                        childrenPadding: const EdgeInsets.only(bottom: 8),
                        children: [Text(c.ajuda, style: t.bodySmall)],
                      ),
                    ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(children: [
                      for (final o in c.opcoes)
                        ListTile(
                          dense: true,
                          minTileHeight: 48,
                          selected: _respostas[c.id] == o.codigo,
                          selectedTileColor: LumeCores.selecao,
                          leading: Icon(_respostas[c.id] == o.codigo
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked),
                          title: Text(o.rotulo, style: t.bodyMedium),
                          trailing: Text('${o.pontos} pt', style: estiloMono(tamanho: 13)),
                          onTap: () => setState(() => _respostas[c.id] = o.codigo),
                        ),
                    ]),
                  ),
                ],
                const TituloSecao('Observação'),
                TextField(
                  controller: _obs,
                  minLines: 2,
                  maxLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(hintText: 'Justificativa, fontes consultadas, parceiros…'),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(children: [
            Expanded(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Índice: $indice de ${indiceMaximo(criterios)}',
                    style: estiloCodigo(tamanho: 18, cor: LumeCores.verdeFloresta)),
                Text(faltam == 0 ? 'Todos os critérios respondidos' : 'Faltam $faltam critérios (valem 0)',
                    style: t.bodySmall),
              ]),
            ),
            FilledButton(
              onPressed: _salvando || !_carregado ? null : () => _salvar(criterios),
              child: const Text('Salvar'),
            ),
          ]),
        ),
      ),
    );
  }
}
