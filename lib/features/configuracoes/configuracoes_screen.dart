import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../core/formato.dart' as fmt;
import '../../domain/codigos.dart';
import '../../domain/regras.dart';
import '../../widgets/comuns.dart';
import '../../widgets/marcador_status.dart';

/// T14 — Configurações: usuário, regras (raio de "mesmo foco", detecção
/// precoce, erradicação), legenda e sobre.
class ConfiguracoesScreen extends ConsumerWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioAtualProvider).value;
    final regras = ref.watch(regrasAtuaisProvider);
    final gestor = usuario != null && Perfil.podeGerir(usuario.perfil);
    final t = Theme.of(context).textTheme;

    Future<void> editar(String titulo, String unidade, num atual, RegrasConfig Function(num) aplicar,
        {bool inteiro = false}) async {
      final ctrl = TextEditingController(text: fmt.numero(atual));
      final v = await showDialog<num>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(titulo),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            keyboardType: TextInputType.numberWithOptions(decimal: !inteiro),
            decoration: InputDecoration(suffixText: unidade),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                final n = fmt.lerNumero(ctrl.text);
                if (n != null && n > 0) Navigator.pop(c, inteiro ? n.round() : n);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      );
      ctrl.dispose();
      if (v != null) await ref.read(regrasProvider.notifier).salvar(aplicar(v));
    }

    Widget regra(String titulo, String valor, VoidCallback aoTocar) => ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(titulo),
          trailing: Text(valor, style: estiloMono(tamanho: 15, cor: LumeCores.verdeFloresta)),
          onTap: gestor ? aoTocar : null,
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          if (usuario != null)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: LumeCores.verdeFloresta,
                  foregroundColor: Colors.white,
                  child: Text(usuario.nome.isEmpty ? '?' : usuario.nome[0].toUpperCase()),
                ),
                title: Text(usuario.nome),
                subtitle: Text('${usuario.email}\nPerfil: ${switch (usuario.perfil) {
                  Perfil.gestor => 'gestão',
                  Perfil.admin => 'administração',
                  _ => 'campo',
                }}${usuario.funcao == null ? '' : ' · ${usuario.funcao}'}'),
                isThreeLine: true,
              ),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final p = await ref.read(syncServiceProvider).pendencias();
              if (!context.mounted) return;
              final aviso = p.registros > 0 && ref.read(syncServiceProvider).disponivel
                  ? '\n\nAtenção: ${p.registros} registros ainda não foram enviados. Eles continuam no aparelho.'
                  : '';
              if (await confirmar(context, titulo: 'Sair?', mensagem: 'Você vai precisar entrar de novo.$aviso', confirmar: 'Sair')) {
                await ref.read(sessaoRepoProvider).sair();
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sair'),
          ),
          TituloSecao('Regras', ajuda: gestor
              ? 'Valores iniciais a confirmar com a equipe da Flona. Toque para alterar.'
              : 'Só a gestão pode alterar.'),
          regra('Raio de "mesmo foco"', '${fmt.numero(regras.raioMesmoFocoM)} m',
              () => editar('Raio de "mesmo foco"', 'm', regras.raioMesmoFocoM, (v) => regras.copyWith(raioMesmoFocoM: v.toDouble()))),
          regra('Revisitar após', '${regras.diasParaRevisita} dias',
              () => editar('Revisitar após', 'dias', regras.diasParaRevisita, (v) => regras.copyWith(diasParaRevisita: v.toInt()), inteiro: true)),
          const Divider(),
          Text('Detecção precoce', style: t.titleSmall),
          regra('Distância de nova frente', '${fmt.numero(regras.precoceDistanciaM)} m',
              () => editar('Distância de nova frente', 'm', regras.precoceDistanciaM, (v) => regras.copyWith(precoceDistanciaM: v.toDouble()))),
          regra('Até quantos indivíduos', '${regras.precoceMaxIndividuos}',
              () => editar('Até quantos indivíduos', 'ind.', regras.precoceMaxIndividuos, (v) => regras.copyWith(precoceMaxIndividuos: v.toInt()), inteiro: true)),
          regra('Até qual área', '${fmt.numero(regras.precoceMaxAreaM2)} m²',
              () => editar('Até qual área', 'm²', regras.precoceMaxAreaM2, (v) => regras.copyWith(precoceMaxAreaM2: v.toDouble()))),
          const Divider(),
          Text('Erradicação', style: t.titleSmall),
          regra('Revisitas ausentes seguidas', '${regras.erradicadoRevisitas}',
              () => editar('Revisitas ausentes seguidas', '', regras.erradicadoRevisitas, (v) => regras.copyWith(erradicadoRevisitas: v.toInt()), inteiro: true)),
          regra('Sem presença por pelo menos', '${regras.erradicadoMeses} meses',
              () => editar('Sem presença por pelo menos', 'meses', regras.erradicadoMeses, (v) => regras.copyWith(erradicadoMeses: v.toInt()), inteiro: true)),
          const TituloSecao('Legenda dos status'),
          const LegendaStatus(),
          const SizedBox(height: 12),
          Text('Halo laranja em volta do marcador = detecção precoce.', style: t.bodySmall),
          const TituloSecao('Mais'),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.sync),
            title: const Text('Sincronização'),
            onTap: () => context.push(Rotas.pendencias),
          ),
          if (gestor)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.ios_share),
              title: const Text('Exportar e relatório'),
              onTap: () => context.push(Rotas.exportar),
            ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre o Lume e licenças'),
            onTap: () => context.push(Rotas.sobre),
          ),
        ],
      ),
    );
  }
}

