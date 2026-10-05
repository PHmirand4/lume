import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../domain/codigos.dart';
import '../../widgets/comuns.dart';
import '../ocorrencia/seletor_especie.dart';

/// T11 — Guia de espécies invasoras da Flona (offline).
class GuiaScreen extends ConsumerWidget {
  const GuiaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final especies = ref.watch(especiesProvider).value ?? const [];
    final focos = ref.watch(focosProvider).value ?? const [];
    final vocab = ref.watch(vocabProvider);
    final t = Theme.of(context).textTheme;

    int ativos(String id) =>
        focos.where((f) => f.foco.especieId == id && StatusFoco.ativos.contains(f.foco.status)).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Guia de espécies')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Aviso(
              'As 10 espécies exóticas invasoras manejadas na Flona de Pacotuba (Costa et al., 2024). '
              'Características em validação com a equipe da Flona.',
            ),
          ),
          for (final e in especies.where((e) => e.id != especieOutra)) ...[
            ListTile(
              minTileHeight: 72,
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: LumeCores.nevoa,
                foregroundColor: LumeCores.verdeFloresta,
                child: Icon(iconeFormaVida(e.formaVida)),
              ),
              title: Text(capitalizar(e.nomesPopulares.first)),
              subtitle: Text(
                '${e.nomeCientifico}\n${vocab.rotulo(Listas.formaVida, e.formaVida)} · ${e.familia ?? ''}',
                style: t.bodySmall,
              ),
              isThreeLine: true,
              trailing: ativos(e.id) > 0
                  ? Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text('${ativos(e.id)} ativos', style: estiloMono(tamanho: 12, cor: LumeCores.laranjaTexto)),
                    )
                  : null,
              onTap: () => context.push(Rotas.especie(e.id)),
            ),
            const Divider(indent: 72),
          ],
        ],
      ),
    );
  }
}
