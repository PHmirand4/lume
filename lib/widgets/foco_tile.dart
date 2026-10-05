import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router.dart';
import '../app/theme.dart';
import '../core/formato.dart' as fmt;
import '../data/repositories/foco_repository.dart';
import 'marcador_status.dart';

/// Linha de foco usada nas listas (início, lista de focos, diálogo "mesmo foco").
class FocoTile extends StatelessWidget {
  const FocoTile({super.key, required this.item, this.distanciaM, this.aoTocar, this.trailing});

  final FocoComEspecie item;
  final double? distanciaM;
  final VoidCallback? aoTocar;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final f = item.foco;
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: aoTocar ?? () => context.push(Rotas.foco(f.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          MarcadorStatus(status: f.status, tamanho: 26, precoce: f.deteccaoPrecoce),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(f.codigo, style: estiloCodigo(tamanho: 14.5)),
                const SizedBox(width: 8),
                if (f.deteccaoPrecoce && f.status != 'descartado') const SeloPrecoce(compacto: true),
              ]),
              const SizedBox(height: 2),
              Text(item.nomeExibicao, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(
                [
                  EstiloStatus.de(f.status).rotulo,
                  'visto ${fmt.haQuanto(f.ultimaVisitaEm)}',
                  if (f.ultimaAbundancia != null) f.ultimaAbundancia!,
                ].join(' · '),
                style: t.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
          ),
          if (distanciaM != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text('${distanciaM!.round()} m', style: estiloMono(tamanho: 13, cor: LumeCores.textoSecundario)),
            ),
          trailing ?? const Icon(Icons.chevron_right, color: LumeCores.textoSecundario),
        ]),
      ),
    );
  }
}
