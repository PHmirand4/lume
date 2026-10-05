import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../data/repositories/foco_repository.dart';
import 'marcador_status.dart';

const pacoteApp = 'app.lume.pacotuba';

LatLng latLng(double lat, double lon) => LatLng(lat, lon);

/// Mapa base do Lume: camada de fundo (OpenStreetMap com cache do que já foi
/// visto), limite oficial da Flona e focos.
///
/// Mapa offline completo (MBTiles próprio) é a decisão em aberto da §14.4: sem
/// conexão, o app mostra o limite e os focos sobre fundo neutro, mais os blocos
/// do mapa que já estiverem no cache.
class MapaLume extends ConsumerWidget {
  const MapaLume({
    super.key,
    this.focos = const [],
    this.controller,
    this.selecionadoId,
    this.aoTocarFoco,
    this.aoTocarMapa,
    this.posicaoAtual,
    this.precisaoAtualM,
    this.pino,
    this.interativo = true,
    this.enquadrarFlona = true,
    this.centro,
    this.zoom,
    this.tamanhoMarcador = 26,
  });

  final List<FocoComEspecie> focos;
  final MapController? controller;
  final String? selecionadoId;
  final ValueChanged<FocoComEspecie>? aoTocarFoco;
  final void Function(LatLng)? aoTocarMapa;
  final LatLng? posicaoAtual;
  final double? precisaoAtualM;
  final LatLng? pino;
  final bool interativo;
  final bool enquadrarFlona;
  final LatLng? centro;
  final double? zoom;
  final double tamanhoMarcador;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limite = ref.watch(limiteFlonaProvider);
    final anel = [for (final p in limite.anel) LatLng(p.lat, p.lon)];
    final b = limite.limites;
    final limitesFlona = LatLngBounds(LatLng(b.sul, b.oeste), LatLng(b.norte, b.leste));

    // Focos precoces e selecionado por cima.
    final ordenados = [...focos]..sort((a, c) {
        int peso(FocoComEspecie f) =>
            (f.foco.id == selecionadoId ? 2 : 0) + (f.foco.deteccaoPrecoce ? 1 : 0);
        return peso(a).compareTo(peso(c));
      });

    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        backgroundColor: const Color(0xFFEDEBDD),
        initialCenter: centro ?? limitesFlona.center,
        initialZoom: zoom ?? 14.5,
        initialCameraFit: (enquadrarFlona && centro == null)
            ? CameraFit.bounds(bounds: limitesFlona, padding: const EdgeInsets.all(24))
            : null,
        minZoom: 10,
        maxZoom: 19,
        interactionOptions: InteractionOptions(
          flags: interativo ? InteractiveFlag.all & ~InteractiveFlag.rotate : InteractiveFlag.none,
        ),
        onTap: aoTocarMapa == null ? null : (_, p) => aoTocarMapa!(p),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: pacoteApp,
          maxNativeZoom: 19,
        ),
        PolygonLayer(polygons: [
          Polygon(
            points: anel,
            color: LumeCores.verdeFloresta.withValues(alpha: 0.07),
            borderColor: LumeCores.verdeFloresta,
            borderStrokeWidth: 2.5,
          ),
        ]),
        if (posicaoAtual != null && precisaoAtualM != null)
          CircleLayer(circles: [
            CircleMarker(
              point: posicaoAtual!,
              radius: precisaoAtualM!,
              useRadiusInMeter: true,
              color: const Color(0x332C6BAA),
              borderColor: const Color(0x882C6BAA),
              borderStrokeWidth: 1,
            ),
          ]),
        MarkerLayer(markers: [
          for (final f in ordenados)
            Marker(
              point: LatLng(f.foco.lat, f.foco.lon),
              width: tamanhoMarcador + 18,
              height: tamanhoMarcador + 18,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: aoTocarFoco == null ? null : () => aoTocarFoco!(f),
                child: Center(
                  child: MarcadorStatus(
                    status: f.foco.status,
                    tamanho: f.foco.id == selecionadoId ? tamanhoMarcador * 1.4 : tamanhoMarcador,
                    precoce: f.foco.deteccaoPrecoce,
                    selecionado: f.foco.id == selecionadoId,
                  ),
                ),
              ),
            ),
          if (posicaoAtual != null)
            Marker(
              point: posicaoAtual!,
              width: 22,
              height: 22,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C6BAA),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
              ),
            ),
          if (pino != null)
            Marker(
              point: pino!,
              width: 44,
              height: 54,
              alignment: Alignment.topCenter,
              child: const Icon(Icons.location_on, size: 50, color: LumeCores.laranjaAlerta),
            ),
        ]),
        RichAttributionWidget(
          alignment: AttributionAlignment.bottomLeft,
          showFlutterMapAttribution: false,
          attributions: [
            TextSourceAttribution(
              '© colaboradores do OpenStreetMap',
              onTap: () => launchUrl(Uri.parse('https://www.openstreetmap.org/copyright')),
            ),
            const TextSourceAttribution('Limite: ICMBio', prependCopyright: false),
          ],
        ),
      ],
    );
  }
}
