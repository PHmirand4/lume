import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../core/geo.dart';
import '../../core/gps.dart';
import '../../data/geo/unidades.dart';
import '../../data/repositories/config_repository.dart';
import '../../domain/regras.dart';
import '../../widgets/comuns.dart';
import '../../widgets/mapa_lume.dart';

final _contagemPorUnidadeProvider =
    StreamProvider<Map<String, int>>((ref) => ref.watch(focoRepoProvider).observarContagemPorUnidade());

/// Escolha da unidade de conservação. Cada Flona tem o próprio mapa, focos e
/// relatórios; o catálogo de espécies é nacional.
class SelecaoUnidadeScreen extends ConsumerStatefulWidget {
  const SelecaoUnidadeScreen({super.key});

  @override
  ConsumerState<SelecaoUnidadeScreen> createState() => _SelecaoUnidadeScreenState();
}

class _SelecaoUnidadeScreenState extends ConsumerState<SelecaoUnidadeScreen> {
  final _mapa = MapController();
  String _busca = '';
  String? _destacada;
  GeoPonto? _aqui;
  bool _procurando = false;

  static final _brasil = LatLngBounds(const LatLng(-33.8, -73.9), const LatLng(5.3, -34.8));

  Future<void> _maisPerto() async {
    setState(() => _procurando = true);
    try {
      final problema = await prepararGps();
      if (problema != null) {
        if (mounted) mostrarMensagem(context, mensagemProblemaGps(problema));
        return;
      }
      final p = await Geolocator.getLastKnownPosition() ??
          await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 20)),
          );
      if (!mounted) return;
      setState(() => _aqui = GeoPonto(p.latitude, p.longitude));
    } catch (_) {
      if (mounted) mostrarMensagem(context, 'Não foi possível obter a sua posição agora.');
    } finally {
      if (mounted) setState(() => _procurando = false);
    }
  }

  double _distancia(Unidade u) => u.contem(_aqui!) ? 0 : distanciaM(_aqui!, u.pontoRotulo);

  Future<void> _escolher(Unidade u) async {
    final atual = ref.read(unidadeSelecionadaProvider);
    if (atual != null && atual.id != u.id) {
      final ok = await confirmar(
        context,
        titulo: 'Trocar para ${u.nomeCurto}?',
        mensagem: 'Mapa, focos e relatórios passam a ser os dessa unidade. '
            'Os registros de ${atual.nomeCurto} continuam guardados no aparelho.',
        confirmar: 'Trocar',
      );
      if (!ok) return;
    }
    await ref.read(configRepoProvider).gravar(ConfigRepository.unidadeAtual, u.id);
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Rotas.inicio);
    }
  }

  void _destacar(Unidade u) {
    setState(() => _destacada = u.id);
    final b = u.limites;
    _mapa.fitCamera(CameraFit.bounds(
      bounds: LatLngBounds(LatLng(b.sul, b.oeste), LatLng(b.norte, b.leste)),
      padding: const EdgeInsets.all(40),
      maxZoom: 11,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final todas = ref.watch(unidadesProvider).todas;
    final atual = ref.watch(unidadeSelecionadaProvider);
    final contagem = ref.watch(_contagemPorUnidadeProvider).value ?? const {};
    final t = Theme.of(context).textTheme;

    final q = normalizarTexto(_busca);
    final lista = todas
        .where((u) => q.isEmpty || normalizarTexto('${u.nome} ${u.uf} ${u.bioma}').contains(q))
        .toList();
    if (_aqui != null) lista.sort((a, b) => _distancia(a).compareTo(_distancia(b)));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: atual != null,
        title: Text(atual == null ? 'Escolha a sua Flona' : 'Trocar de unidade'),
      ),
      body: Column(children: [
        SizedBox(
          height: 230,
          child: FlutterMap(
            mapController: _mapa,
            options: MapOptions(
              backgroundColor: const Color(0xFFEDEBDD),
              initialCameraFit: CameraFit.bounds(bounds: _brasil, padding: const EdgeInsets.all(8)),
              minZoom: 3,
              maxZoom: 14,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: pacoteApp,
              ),
              PolygonLayer(polygons: [
                for (final u in todas)
                  for (final c in u.contornos)
                    Polygon(
                      points: [for (final p in c) LatLng(p.lat, p.lon)],
                      color: (u.id == _destacada ? LumeCores.laranjaAlerta : LumeCores.verdeFloresta)
                          .withValues(alpha: 0.25),
                      borderColor: u.id == _destacada ? LumeCores.laranjaAlerta : LumeCores.verdeFloresta,
                      borderStrokeWidth: u.id == _destacada ? 2.5 : 1.2,
                    ),
              ]),
              // Ponto em cada unidade: as pequenas somem no zoom do país.
              MarkerLayer(markers: [
                for (final u in todas)
                  Marker(
                    point: LatLng(u.pontoRotulo.lat, u.pontoRotulo.lon),
                    width: 30,
                    height: 30,
                    child: GestureDetector(
                      onTap: () => _destacar(u),
                      child: Center(
                        child: Container(
                          width: u.id == _destacada ? 16 : 10,
                          height: u.id == _destacada ? 16 : 10,
                          decoration: BoxDecoration(
                            color: u.id == _destacada ? LumeCores.laranjaAlerta : LumeCores.verdeFloresta,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_aqui != null)
                  Marker(
                    point: LatLng(_aqui!.lat, _aqui!.lon),
                    width: 20,
                    height: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C6BAA),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
              ]),
              const RichAttributionWidget(
                alignment: AttributionAlignment.bottomLeft,
                showFlutterMapAttribution: false,
                attributions: [
                  TextSourceAttribution('© colaboradores do OpenStreetMap'),
                  TextSourceAttribution('Limites: ICMBio', prependCopyright: false),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(children: [
            Expanded(
              child: TextField(
                onChanged: (s) => setState(() => _busca = s),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Nome, estado ou bioma',
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.outlined(
              tooltip: 'Ordenar pela mais perto de mim',
              style: IconButton.styleFrom(minimumSize: const Size(54, 54)),
              onPressed: _procurando ? null : _maisPerto,
              icon: _procurando
                  ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                  : Icon(_aqui == null ? Icons.near_me_outlined : Icons.near_me),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _aqui != null
                  ? '${lista.length} Florestas Nacionais, da mais perto para a mais longe'
                  : '${lista.length} Florestas Nacionais (ICMBio)',
              style: t.bodySmall,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: lista.length,
            separatorBuilder: (_, _) => const Divider(indent: 16, endIndent: 16),
            itemBuilder: (_, i) {
              final u = lista[i];
              final n = contagem[u.id] ?? 0;
              final detalhes = [
                u.uf,
                u.bioma,
                u.areaFormatada,
                if (_aqui != null) _distancia(u) == 0 ? 'você está aqui' : formatarDistancia(_distancia(u)),
              ].join(' · ');
              return ListTile(
                minTileHeight: 72,
                selected: u.id == _destacada,
                selectedTileColor: LumeCores.selecao,
                leading: IconButton(
                  tooltip: 'Ver no mapa',
                  icon: const Icon(Icons.map_outlined, color: LumeCores.verdeFloresta),
                  onPressed: () => _destacar(u),
                ),
                title: Text(u.nomeCurto),
                subtitle: Text(
                  n > 0 ? '$detalhes\n$n ${n == 1 ? 'foco' : 'focos'} neste aparelho' : detalhes,
                  style: t.bodySmall,
                ),
                isThreeLine: n > 0,
                trailing: u.id == atual?.id
                    ? const Chip(label: Text('Atual'), visualDensity: VisualDensity.compact)
                    : u.id == CatalogoUnidades.padrao
                        ? const Chip(label: Text('Piloto'), visualDensity: VisualDensity.compact)
                        : const Icon(Icons.chevron_right),
                onTap: () => _escolher(u),
              );
            },
          ),
        ),
      ]),
    );
  }
}
