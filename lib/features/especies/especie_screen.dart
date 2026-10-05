import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../domain/codigos.dart';
import '../../widgets/comuns.dart';
import '../ocorrencia/seletor_especie.dart';

/// Ficha de uma espécie: como reconhecer, confusões e métodos citados.
class EspecieScreen extends ConsumerWidget {
  const EspecieScreen({super.key, required this.especieId});

  final String especieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final especies = ref.watch(especiesProvider).value ?? const [];
    final vocab = ref.watch(vocabProvider);
    final e = especies.where((x) => x.id == especieId).firstOrNull;
    final t = Theme.of(context).textTheme;
    if (e == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: Text(capitalizar(e.nomesPopulares.first))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(color: LumeCores.nevoa, borderRadius: BorderRadius.circular(14)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(iconeFormaVida(e.formaVida), size: 64, color: LumeCores.verdeFloresta),
              const SizedBox(height: 6),
              Text('Fotos de referência da Flona em breve', style: t.bodySmall),
            ]),
          ),
          const SizedBox(height: 16),
          Text(e.nomeCientifico, style: t.titleMedium!.copyWith(fontStyle: FontStyle.italic)),
          const SizedBox(height: 4),
          Text(
            [
              if (e.nomesPopulares.length > 1) 'Também: ${e.nomesPopulares.skip(1).join(', ')}',
              if (e.familia?.isNotEmpty ?? false) e.familia!,
              vocab.rotulo(Listas.formaVida, e.formaVida),
            ].join(' · '),
            style: t.bodySmall,
          ),
          if (e.descricaoIdentificacao != null) ...[
            const TituloSecao('Como reconhecer'),
            Text(e.descricaoIdentificacao!, style: t.bodyLarge),
          ],
          if (e.confusaoCom != null) ...[
            const SizedBox(height: 16),
            Aviso(e.confusaoCom!, tipo: TipoAviso.alerta, icone: Icons.compare_arrows),
          ],
          if (e.controleCitado != null) ...[
            const TituloSecao('Controle já usado na Flona'),
            Text(e.controleCitado!, style: t.bodyLarge),
          ],
          if (e.metodosSugeridos.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final m in e.metodosSugeridos) Chip(label: Text(vocab.rotulo(Listas.metodoManejo, m))),
            ]),
          ],
          const SizedBox(height: 12),
          Text(
            'Regra geral da Flona: árvores isoladas são cortadas rente à base; árvores dentro da mata são aneladas. '
            'O Lume registra o que foi feito, mas não recomenda produto nem dose.',
            style: t.bodySmall,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('${Rotas.novaOcorrencia}?especie=${e.id}'),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Registrar ocorrência'),
      ),
    );
  }
}
