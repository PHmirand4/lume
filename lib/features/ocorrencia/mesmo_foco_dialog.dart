import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/formato.dart' as fmt;
import '../../data/local/database.dart';
import '../../data/repositories/foco_repository.dart';
import '../../widgets/marcador_status.dart';

/// Resposta do diálogo: [foco] nulo = é um foco novo.
class EscolhaMesmoFoco {
  const EscolhaMesmoFoco(this.foco);

  final FocoComEspecie? foco;
}

/// T04 — "É o mesmo foco?" (RN07). Retorna null se o usuário cancelar.
Future<EscolhaMesmoFoco?> mostrarDialogoMesmoFoco(
  BuildContext context,
  WidgetRef ref,
  List<(FocoComEspecie, double)> proximos,
) async {
  final repo = ref.read(focoRepoProvider);
  final fotos = <String, Midia?>{
    for (final (f, _) in proximos.take(3)) f.foco.id: await repo.primeiraFoto(f.foco.id),
  };
  if (!context.mounted) return null;

  return showModalBottomSheet<EscolhaMesmoFoco>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (c) {
      final t = Theme.of(c).textTheme;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('É o mesmo foco?', style: t.headlineSmall),
            const SizedBox(height: 4),
            Text(
              proximos.length == 1
                  ? 'Já existe um foco desta espécie aqui perto.'
                  : 'Já existem ${proximos.length} focos desta espécie aqui perto.',
              style: t.bodyMedium!.copyWith(color: LumeCores.textoSecundario),
            ),
            const SizedBox(height: 12),
            for (final (f, d) in proximos.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => Navigator.pop(c, EscolhaMesmoFoco(f)),
                    child: Row(children: [
                      SizedBox(
                        width: 88,
                        height: 88,
                        child: fotos[f.foco.id]?.caminhoLocal != null
                            ? Image.file(File(fotos[f.foco.id]!.caminhoLocal!), fit: BoxFit.cover, cacheWidth: 260)
                            : Container(
                                color: LumeCores.nevoa,
                                child: Center(child: MarcadorStatus(status: f.foco.status, tamanho: 30)),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(f.foco.codigo, style: estiloCodigo(tamanho: 15)),
                          Text('Detectado em ${fmt.data(f.foco.primeiraDeteccaoEm)}', style: t.bodyMedium),
                          Text(
                            '${EstiloStatus.de(f.foco.status).rotulo} · a ${d.round()} m',
                            style: t.bodySmall,
                          ),
                        ]),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Text('É este', style: TextStyle(color: LumeCores.verdeFloresta, fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            FilledButton.icon(
              onPressed: () => Navigator.pop(c, const EscolhaMesmoFoco(null)),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Não, é um foco novo'),
            ),
            const SizedBox(height: 4),
            TextButton(onPressed: () => Navigator.pop(c), child: const Text('Voltar ao registro')),
          ]),
        ),
      );
    },
  );
}
