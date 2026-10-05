import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../core/formato.dart' as fmt;
import '../../core/geo.dart';
import '../../data/local/database.dart';
import '../../data/repositories/catalogo_repository.dart';
import '../../data/repositories/foco_repository.dart';
import '../../domain/codigos.dart';
import '../../domain/regras.dart';
import '../../widgets/comuns.dart';
import '../../widgets/marcador_status.dart';
import '../../widgets/mapa_lume.dart';
import '../mapa/ajuste_posicao_screen.dart';

/// T05 — Ficha do foco: código, espécie, status, mapa, fotos e linha do tempo.
class FocoScreen extends ConsumerWidget {
  const FocoScreen({super.key, required this.focoId});

  final String focoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFoco = ref.watch(focoProvider(focoId));
    final linha = ref.watch(linhaDoTempoProvider(focoId)).value ?? const <ItemLinhaDoTempo>[];
    final vocab = ref.watch(vocabProvider);
    final usuario = ref.watch(usuarioAtualProvider).value;
    final gestor = usuario != null && Perfil.podeGerir(usuario.perfil);
    final item = asyncFoco.value;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: asyncFoco.isLoading ? const CircularProgressIndicator() : const Text('Foco não encontrado.')),
      );
    }
    final f = item.foco;
    final t = Theme.of(context).textTheme;
    final descartado = f.status == StatusFoco.descartado;

    return Scaffold(
      appBar: AppBar(
        title: Text(f.codigo, style: estiloCodigo(tamanho: 20)),
        actions: [
          if (gestor) _MenuGestor(item: item),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.nomeExibicao, style: t.headlineSmall),
              if (f.especieId != especieOutra)
                Text(item.especie.nomeCientifico, style: t.bodyMedium!.copyWith(fontStyle: FontStyle.italic, color: LumeCores.textoSecundario)),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8, children: [
                EtiquetaStatus(status: f.status),
                if (f.deteccaoPrecoce && !descartado) const SeloPrecoce(),
                if (f.statusManual)
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text('Status definido pela gestão', style: t.labelSmall),
                  ),
              ]),
              if (f.deteccaoPrecoce && f.motivosPrecoce.isNotEmpty && !descartado) ...[
                const SizedBox(height: 10),
                Aviso(
                  '${f.motivosPrecoce.join('; ')}. Resposta rápida dispensa projeto autorizado (IN ICMBio 19/2025, art. 12).',
                  tipo: TipoAviso.alerta,
                  icone: Icons.bolt,
                ),
              ],
              if (f.foraDoLimite) ...[
                const SizedBox(height: 10),
                const Aviso('Fora do limite da Flona (possível zona de amortecimento).', tipo: TipoAviso.alerta),
              ],
            ]),
          ),
          // Mapa
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 180,
                child: MapaLume(
                  key: ValueKey('${f.lat}${f.lon}${f.status}'),
                  focos: [item],
                  selecionadoId: f.id,
                  interativo: false,
                  centro: latLng(f.lat, f.lon),
                  zoom: 16.5,
                ),
              ),
            ),
          ),
          // Ações
          if (!descartado)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push(Rotas.manejo(f.id)),
                    icon: const Icon(Icons.content_cut),
                    label: const Text('Manejo'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push(Rotas.revisita(f.id)),
                    icon: const Icon(Icons.replay),
                    label: const Text('Revisita'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  onPressed: () => context.push(Rotas.navegar(f.id)),
                  tooltip: 'Navegar até o foco',
                  style: IconButton.styleFrom(minimumSize: const Size(52, 52)),
                  icon: const Icon(Icons.near_me_outlined),
                ),
              ]),
            ),
          // Dados
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(children: [
                  LinhaDado('Coordenadas', fmt.coordenadas(f.lat, f.lon), mono: true),
                  LinhaDado('Precisão', fmt.precisao(f.precisaoM), mono: true),
                  LinhaDado('Origem', vocab.rotulo(Listas.origemCoordenada, f.origemCoordenada)),
                  LinhaDado('Ambiente', f.ambiente == null ? null : vocab.rotulo(Listas.ambiente, f.ambiente)),
                  LinhaDado('1ª detecção', fmt.dataHora(f.primeiraDeteccaoEm)),
                  LinhaDado('Última visita', '${fmt.dataHora(f.ultimaVisitaEm)} (${fmt.haQuanto(f.ultimaVisitaEm)})'),
                  LinhaDado('Abundância', f.ultimaAbundancia),
                  LinhaDado('Sincronização', f.syncStatus == SyncStatus.enviado ? 'Enviado' : 'Pendente'),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text('Linha do tempo', style: t.titleLarge),
          ),
          for (final i in linha) _ItemTimeline(item: i, vocab: vocab, usuario: usuario),
        ],
      ),
    );
  }
}

class _ItemTimeline extends ConsumerWidget {
  const _ItemTimeline({required this.item, required this.vocab, required this.usuario});

  final ItemLinhaDoTempo item;
  final Vocabulario vocab;
  final Usuario? usuario;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final (icone, cor, titulo, linhas, autorId, criadoEm) = switch (item) {
      ItemObservacao(:final obs) => (
          obs.tipo == TipoObservacao.deteccao
              ? Icons.add_location_alt_outlined
              : (obs.presenca == Presenca.ausente ? Icons.visibility_off_outlined : Icons.visibility_outlined),
          obs.tipo == TipoObservacao.deteccao
              ? LumeCores.laranjaAlerta
              : (obs.presenca == Presenca.ausente ? const Color(0xFF5E9B52) : const Color(0xFF2C6BAA)),
          obs.tipo == TipoObservacao.deteccao
              ? 'Detecção'
              : 'Revisita · ${obs.resultado == null ? (obs.presenca == Presenca.ausente ? 'ausente' : 'presente') : vocab.rotulo(Listas.resultadoRevisita, obs.resultado).toLowerCase()}',
          <String>[
            if (obs.nIndividuos != null) '${obs.nIndividuos} indivíduos',
            if (obs.classeAbundancia != null) 'Classe: ${vocab.rotulo(Listas.classeAbundancia, obs.classeAbundancia)}',
            if (obs.areaM2 != null) 'Área: ${fmt.numero(obs.areaM2!)} m²',
            if (obs.coberturaPct != null) 'Cobertura: ${obs.coberturaPct}%',
            if (obs.estagio != null) 'Estágio: ${vocab.rotulo(Listas.estagio, obs.estagio)}',
            if (obs.ambiente != null) 'Ambiente: ${vocab.rotulo(Listas.ambiente, obs.ambiente)}',
            'GPS ${fmt.precisao(obs.precisaoM)}',
            if (obs.texto != null) '“${obs.texto}”${obs.ditado ? ' (ditado)' : ''}',
          ],
          obs.usuarioId,
          obs.createdAt,
        ),
      ItemManejo(:final acao) => (
          Icons.content_cut,
          const Color(0xFF2C6BAA),
          'Manejo · ${acao.metodo == 'outro' ? (acao.metodoTexto ?? 'outro') : vocab.rotulo(Listas.metodoManejo, acao.metodo).toLowerCase()}',
          <String>[
            if (acao.herbicidaProduto != null)
              'Herbicida: ${acao.herbicidaProduto}${acao.herbicidaConcentracao == null ? '' : ' (${acao.herbicidaConcentracao})'}'
                  '${acao.herbicidaVolumeL == null ? '' : ' · ${fmt.numero(acao.herbicidaVolumeL!)} L'}',
            if (acao.nIndividuosTratados != null) '${acao.nIndividuosTratados} indivíduos tratados',
            if (acao.areaTratadaM2 != null) '${fmt.numero(acao.areaTratadaM2!)} m² tratados',
            'Esforço: ${acao.nPessoas} × ${fmt.numero(acao.horas)} h = ${fmt.numero(acao.nPessoas * acao.horas)} pessoa·hora',
            if (acao.destinacao != null) 'Destinação: ${vocab.rotulo(Listas.destinacao, acao.destinacao)}',
            'Responsável: ${acao.responsavel}',
            if (acao.texto != null) '“${acao.texto}”',
          ],
          acao.usuarioId,
          acao.createdAt,
        ),
    };
    final pode = usuario != null &&
        podeEditar(perfil: usuario!.perfil, autorId: autorId, usuarioId: usuario!.id, criadoEm: criadoEm);

    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(
          width: 56,
          child: Column(children: [
            const SizedBox(height: 4),
            CircleAvatar(radius: 16, backgroundColor: cor.withValues(alpha: 0.12), child: Icon(icone, size: 18, color: cor)),
            const Expanded(child: VerticalDivider(width: 2, thickness: 2, color: LumeCores.borda)),
          ]),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(titulo, style: t.titleMedium)),
                if (pode)
                  IconButton(
                    tooltip: 'Excluir registro',
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => _excluir(context, ref),
                  ),
              ]),
              Text(fmt.dataHora(item.data), style: estiloMono(tamanho: 12.5, cor: LumeCores.textoSecundario)),
              const SizedBox(height: 4),
              for (final l in linhas) Text(l, style: t.bodyMedium),
              if (item.midias.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  for (final m in item.midias)
                    Stack(children: [
                      MiniaturaMidia(midia: m),
                      if (m.momento != null)
                        Positioned(
                          left: 4,
                          bottom: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            color: Colors.black54,
                            child: Text(m.momento!, style: const TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ),
                    ]),
                ]),
              ],
            ]),
          ),
        ),
      ]),
    );
  }

  Future<void> _excluir(BuildContext context, WidgetRef ref) async {
    final ok = await confirmar(context,
        titulo: 'Excluir registro?',
        mensagem: 'O registro some da linha do tempo e o status do foco é recalculado. '
            'Ele fica guardado como excluído para rastreabilidade.',
        confirmar: 'Excluir',
        perigo: true);
    if (!ok) return;
    final repo = ref.read(focoRepoProvider);
    final cfg = ref.read(regrasAtuaisProvider);
    switch (item) {
      case ItemObservacao(:final obs):
        await repo.excluirObservacao(obs, cfg);
      case ItemManejo(:final acao):
        await repo.excluirManejo(acao, cfg);
    }
  }
}

/// RN14: gestor sobrescreve status, descarta ou ajusta a posição.
class _MenuGestor extends ConsumerWidget {
  const _MenuGestor({required this.item});

  final FocoComEspecie item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = item.foco;
    return PopupMenuButton<String>(
      tooltip: 'Ações da gestão',
      onSelected: (acao) async {
        final repo = ref.read(focoRepoProvider);
        final usuario = ref.read(usuarioAtualProvider).value!;
        final cfg = ref.read(regrasAtuaisProvider);
        switch (acao) {
          case 'status':
            final novo = await showDialog<String>(
              context: context,
              builder: (c) => SimpleDialog(
                title: const Text('Definir status'),
                children: [
                  for (final s in StatusFoco.todos)
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(c, s),
                      child: Row(children: [
                        MarcadorStatus(status: s, tamanho: 18),
                        const SizedBox(width: 12),
                        Text(EstiloStatus.de(s).rotulo),
                      ]),
                    ),
                ],
              ),
            );
            if (novo != null) await repo.alterarStatusManual(focoId: f.id, status: novo, usuarioId: usuario.id);
          case 'descartar':
            if (context.mounted &&
                await confirmar(context,
                    titulo: 'Descartar foco?',
                    mensagem: 'Use para erro de identificação ou registro duplicado. O foco continua guardado.',
                    confirmar: 'Descartar',
                    perigo: true)) {
              await repo.alterarStatusManual(focoId: f.id, status: StatusFoco.descartado, usuarioId: usuario.id);
            }
          case 'automatico':
            await repo.voltarStatusAutomatico(f.id, cfg);
          case 'posicao':
            final p = await AjustePosicaoScreen.abrir(context, inicial: latLng(f.lat, f.lon), titulo: 'Posição de ${f.codigo}');
            if (p != null) await repo.ajustarPosicao(f.id, GeoPonto(p.latitude, p.longitude));
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'status', child: Text('Definir status manualmente')),
        if (f.statusManual) const PopupMenuItem(value: 'automatico', child: Text('Voltar ao status automático')),
        const PopupMenuItem(value: 'posicao', child: Text('Ajustar posição no mapa')),
        if (f.status != StatusFoco.descartado) const PopupMenuItem(value: 'descartar', child: Text('Descartar foco')),
      ],
    );
  }
}
