import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../data/repositories/foco_repository.dart';
import '../../data/sync/sync_service.dart';
import '../../domain/codigos.dart';
import '../../domain/regras.dart';
import '../../widgets/comuns.dart';
import '../../widgets/foco_tile.dart';
import '../../widgets/mapa_lume.dart';

/// T02 — Início.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focos = ref.watch(focosProvider).value ?? const <FocoComEspecie>[];
    final usuario = ref.watch(usuarioAtualProvider).value;
    final regras = ref.watch(regrasAtuaisProvider);
    final t = Theme.of(context).textTheme;

    final ativos = focos.where((f) => StatusFoco.ativos.contains(f.foco.status)).toList();
    final precoces = ativos.where((f) => f.foco.deteccaoPrecoce).toList();
    final revisitar = _paraRevisitar(focos, regras);
    final controlados = focos
        .where((f) => f.foco.status == StatusFoco.controlado || f.foco.status == StatusFoco.erradicado)
        .length;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: const LogoLume(altura: 34, variante: VarianteLogo.semSlogan),
        actions: [
          const _IndicadorSync(),
          PopupMenuButton<String>(
            tooltip: 'Mais opções',
            onSelected: (r) async {
              if (r != 'sair') {
                context.push(r);
              } else if (await confirmar(context, titulo: 'Sair?', mensagem: 'Você vai precisar entrar de novo.', confirmar: 'Sair')) {
                await ref.read(sessaoRepoProvider).sair();
              }
            },
            itemBuilder: (_) => [
              if (usuario != null && Perfil.podeGerir(usuario.perfil))
                const PopupMenuItem(value: Rotas.exportar, child: ListTile(leading: Icon(Icons.ios_share), title: Text('Exportar e relatório'))),
              const PopupMenuItem(value: Rotas.pendencias, child: ListTile(leading: Icon(Icons.sync), title: Text('Sincronização'))),
              const PopupMenuItem(value: Rotas.configuracoes, child: ListTile(leading: Icon(Icons.settings_outlined), title: Text('Configurações'))),
              const PopupMenuItem(value: Rotas.sobre, child: ListTile(leading: Icon(Icons.info_outline), title: Text('Sobre'))),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'sair', child: ListTile(leading: Icon(Icons.logout), title: Text('Sair'))),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Text(
              usuario == null ? '' : 'Olá, ${usuario.nome.split(' ').first}',
              style: t.bodyMedium!.copyWith(color: LumeCores.textoSecundario),
            ),
          ),
          // Prévia do mapa
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 190,
                child: Stack(children: [
                  MapaLume(focos: focos, interativo: false, tamanhoMarcador: 16),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(onTap: () => context.go(Rotas.mapa)),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: _Pilula(icone: Icons.open_in_full, texto: 'Abrir mapa', aoTocar: () => context.go(Rotas.mapa)),
                  ),
                ]),
              ),
            ),
          ),
          // Botão principal
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: SizedBox(
              height: 72,
              child: FilledButton.icon(
                onPressed: () => context.push(Rotas.novaOcorrencia),
                icon: const Icon(Icons.add_location_alt_outlined, size: 30),
                label: Text('Registrar ocorrência',
                    style: estiloCodigo(tamanho: 18, cor: Colors.white)),
              ),
            ),
          ),
          // Indicadores
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(children: [
              Expanded(child: _Indicador(valor: ativos.length, rotulo: 'Focos ativos')),
              const SizedBox(width: 10),
              Expanded(
                child: _Indicador(
                  valor: precoces.length,
                  rotulo: 'Detecção precoce',
                  cor: precoces.isEmpty ? null : LumeCores.laranjaTexto,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _Indicador(valor: controlados, rotulo: 'Controlados')),
            ]),
          ),
          if (precoces.isNotEmpty) ...[
            _Cabecalho(
              titulo: 'Detecção precoce',
              subtitulo: 'Resposta rápida dispensa autorização (IN ICMBio 19/2025, art. 12)',
              cor: LumeCores.laranjaTexto,
            ),
            _Cartao(children: [for (final f in precoces.take(5)) FocoTile(item: f)]),
          ],
          _Cabecalho(
            titulo: 'Revisitas pendentes',
            subtitulo: 'Focos sem visita há mais de ${regras.diasParaRevisita} dias',
          ),
          if (revisitar.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Aviso('Nenhuma revisita atrasada.', tipo: TipoAviso.sucesso),
            )
          else
            _Cartao(children: [
              for (final f in revisitar.take(6))
                FocoTile(
                  item: f,
                  trailing: IconButton(
                    tooltip: 'Navegar até o foco',
                    icon: const Icon(Icons.near_me_outlined, color: LumeCores.verdeFloresta),
                    onPressed: () => context.push(Rotas.navegar(f.foco.id)),
                  ),
                ),
            ]),
          if (focos.isNotEmpty) ...[
            const _Cabecalho(titulo: 'Últimos registros'),
            _Cartao(children: [for (final f in focos.take(5)) FocoTile(item: f)]),
          ] else
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Aviso(
                'Nenhum foco registrado ainda. Toque em "Registrar ocorrência" quando encontrar uma espécie invasora.',
              ),
            ),
        ],
      ),
    );
  }

  static List<FocoComEspecie> _paraRevisitar(List<FocoComEspecie> focos, RegrasConfig r) {
    final limite = DateTime.now().toUtc().subtract(Duration(days: r.diasParaRevisita));
    const precisam = {StatusFoco.emControle, StatusFoco.controlado, StatusFoco.rebrotou, StatusFoco.detectado};
    return focos
        .where((f) => precisam.contains(f.foco.status) && f.foco.ultimaVisitaEm.isBefore(limite))
        .toList()
      ..sort((a, b) => a.foco.ultimaVisitaEm.compareTo(b.foco.ultimaVisitaEm));
  }
}

class _IndicadorSync extends ConsumerWidget {
  const _IndicadorSync();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pendenciasProvider).value ?? const Pendencias();
    final servico = ref.watch(syncServiceProvider);
    return ValueListenableBuilder(
      valueListenable: servico.estado,
      builder: (context, estado, _) {
        final (icone, cor, texto) = !servico.disponivel
            ? (Icons.phone_android, LumeCores.textoSecundario, p.registros == 0 ? 'Local' : '${p.registros}')
            : estado.rodando
                ? (Icons.sync, LumeCores.verdeFloresta, '…')
                : p.erros > 0
                    ? (Icons.sync_problem, LumeCores.erro, '${p.erros}')
                    : p.vazio
                        ? (Icons.cloud_done_outlined, LumeCores.verdeFloresta, '')
                        : (Icons.cloud_upload_outlined, LumeCores.laranjaTexto, '${p.registros}');
        return TextButton.icon(
          onPressed: () => context.push(Rotas.pendencias),
          icon: Icon(icone, color: cor),
          label: Text(texto, style: estiloMono(tamanho: 13, cor: cor)),
        );
      },
    );
  }
}

class _Indicador extends StatelessWidget {
  const _Indicador({required this.valor, required this.rotulo, this.cor});

  final int valor;
  final String rotulo;
  final Color? cor;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$valor', style: estiloCodigo(tamanho: 26, cor: cor ?? LumeCores.verdeFloresta)),
            const SizedBox(height: 2),
            Text(rotulo, style: Theme.of(context).textTheme.bodySmall, maxLines: 2),
          ]),
        ),
      );
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho({required this.titulo, this.subtitulo, this.cor});

  final String titulo;
  final String? subtitulo;
  final Color? cor;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(titulo, style: t.titleLarge!.copyWith(color: cor)),
        if (subtitulo != null) Text(subtitulo!, style: t.bodySmall),
      ]),
    );
  }
}

class _Cartao extends StatelessWidget {
  const _Cartao({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const Divider(indent: 56),
              children[i],
            ],
          ]),
        ),
      );
}

class _Pilula extends StatelessWidget {
  const _Pilula({required this.icone, required this.texto, required this.aoTocar});

  final IconData icone;
  final String texto;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: aoTocar,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icone, size: 16, color: LumeCores.verdeFloresta),
              const SizedBox(width: 6),
              Text(texto, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: LumeCores.verdeFloresta)),
            ]),
          ),
        ),
      );
}

