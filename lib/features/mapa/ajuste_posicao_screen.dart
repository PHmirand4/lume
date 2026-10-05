import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/formato.dart' as fmt;
import '../../widgets/mapa_lume.dart';

/// Ajuste manual da posição (RN03/RN04): o usuário arrasta o mapa até a mira.
/// Retorna o [LatLng] escolhido.
class AjustePosicaoScreen extends ConsumerStatefulWidget {
  const AjustePosicaoScreen({super.key, this.inicial, this.titulo = 'Ajustar posição'});

  final LatLng? inicial;
  final String titulo;

  static Future<LatLng?> abrir(BuildContext context, {LatLng? inicial, String? titulo}) =>
      Navigator.of(context).push<LatLng>(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AjustePosicaoScreen(inicial: inicial, titulo: titulo ?? 'Ajustar posição'),
      ));

  @override
  ConsumerState<AjustePosicaoScreen> createState() => _AjustePosicaoScreenState();
}

class _AjustePosicaoScreenState extends ConsumerState<AjustePosicaoScreen> {
  final _mapa = MapController();
  late LatLng _centro;

  @override
  void initState() {
    super.initState();
    final ref0 = ref.read(limiteFlonaProvider);
    final b = ref0.limites;
    _centro = widget.inicial ?? LatLng((b.sul + b.norte) / 2, (b.oeste + b.leste) / 2);
  }

  @override
  Widget build(BuildContext context) {
    final focos = ref.watch(focosProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: Stack(children: [
        MapaLume(
          controller: _mapa,
          focos: focos,
          centro: _centro,
          zoom: widget.inicial == null ? 14.5 : 17,
          enquadrarFlona: false,
        ),
        // Mira fixa no centro do mapa (a ponta do marcador marca o ponto).
        const Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Icon(Icons.location_on, size: 52, color: LumeCores.laranjaAlerta),
              ),
            ),
          ),
        ),
        // Coordenada atual do centro, atualizada conforme o mapa se move.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: StreamBuilder<MapEvent>(
              stream: _mapa.mapEventStream,
              builder: (context, snap) {
                if (snap.hasData) _centro = snap.data!.camera.center;
                return Container(
                  color: LumeCores.verdeNoite,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    fmt.coordenadas(_centro.latitude, _centro.longitude),
                    style: estiloMono(tamanho: 15, cor: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: Column(children: [
            Text(
              'Arraste o mapa até a ponta do marcador ficar sobre o foco',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: LumeCores.grafite,
                    backgroundColor: Colors.white70,
                  ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, _centro),
                icon: const Icon(Icons.check),
                label: const Text('Usar esta posição'),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
