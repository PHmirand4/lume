import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../core/gps.dart';
import '../../data/repositories/foco_repository.dart';
import '../../domain/codigos.dart';
import '../../widgets/comuns.dart';
import '../../widgets/foco_tile.dart';
import '../../widgets/mapa_lume.dart';
import '../../widgets/marcador_status.dart';

/// T08 — Mapa: limite da Flona, focos por status, filtros e minha posição.
class MapaScreen extends ConsumerStatefulWidget {
  const MapaScreen({super.key});

  @override
  ConsumerState<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends ConsumerState<MapaScreen> {
  final _mapa = MapController();
  final Set<String> _status = {...StatusFoco.todos}..remove(StatusFoco.descartado);
  String? _especie;
  FocoComEspecie? _selecionado;
  StreamSubscription<LeituraGps>? _gps;
  LeituraGps? _posicao;
  bool _legenda = false;

  @override
  void dispose() {
    _gps?.cancel();
    super.dispose();
  }

  Future<void> _alternarPosicao() async {
    if (_gps != null) {
      await _gps!.cancel();
      setState(() {
        _gps = null;
        _posicao = null;
      });
      return;
    }
    final problema = await prepararGps();
    if (problema != null) {
      if (mounted) mostrarMensagem(context, mensagemProblemaGps(problema));
      return;
    }
    var primeira = true;
    setState(() {
      _gps = fluxoPosicao().listen((l) {
        setState(() => _posicao = l);
        if (primeira) {
          primeira = false;
          _mapa.move(LatLng(l.lat, l.lon), 17);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(focosProvider).value ?? const <FocoComEspecie>[];
    final especies = ref.watch(especiesProvider).value ?? const [];
    final focos = todos
        .where((f) => _status.contains(f.foco.status) && (_especie == null || f.foco.especieId == _especie))
        .toList();
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(children: [
        MapaLume(
          controller: _mapa,
          focos: focos,
          selecionadoId: _selecionado?.foco.id,
          aoTocarFoco: (f) => setState(() => _selecionado = f),
          aoTocarMapa: (_) => setState(() => _selecionado = null),
          posicaoAtual: _posicao == null ? null : LatLng(_posicao!.lat, _posicao!.lon),
          precisaoAtualM: _posicao?.precisaoM,
        ),
        // Filtros
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(children: [
                    const Icon(Icons.filter_alt_outlined, color: LumeCores.textoSecundario),
                    const SizedBox(width: 6),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          isExpanded: true,
                          value: _especie,
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Todas as espécies')),
                            for (final e in especies)
                              DropdownMenuItem(value: e.id, child: Text(e.nomesPopulares.first, overflow: TextOverflow.ellipsis)),
                          ],
                          onChanged: (v) => setState(() {
                            _especie = v;
                            _selecionado = null;
                          }),
                        ),
                      ),
                    ),
                    Text('${focos.length}', style: estiloMono(tamanho: 14, cor: LumeCores.verdeFloresta)),
                    IconButton(
                      tooltip: 'Legenda e status',
                      onPressed: () => setState(() => _legenda = !_legenda),
                      icon: Icon(_legenda ? Icons.expand_less : Icons.tune),
                    ),
                  ]),
                ),
              ),
              if (_legenda) ...[
                const SizedBox(height: 8),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Wrap(spacing: 6, runSpacing: 6, children: [
                      for (final s in StatusFoco.todos)
                        FilterChip(
                          avatar: MarcadorStatus(status: s, tamanho: 16),
                          label: Text(EstiloStatus.de(s).rotulo),
                          selected: _status.contains(s),
                          showCheckmark: false,
                          onSelected: (v) => setState(() => v ? _status.add(s) : _status.remove(s)),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const MarcadorStatus(status: StatusFoco.detectado, tamanho: 18, precoce: true),
                          const SizedBox(width: 6),
                          Text('Halo laranja = detecção precoce', style: t.bodySmall),
                        ]),
                      ),
                    ]),
                  ),
                ),
              ],
            ]),
          ),
        ),
        // Botões do mapa
        Positioned(
          right: 12,
          bottom: (_selecionado == null ? 16 : 150),
          child: Column(children: [
            FloatingActionButton.small(
              heroTag: 'flona',
              tooltip: 'Ver a Flona inteira',
              backgroundColor: Colors.white,
              foregroundColor: LumeCores.verdeFloresta,
              onPressed: () {
                final b = ref.read(limiteFlonaProvider).limites;
                _mapa.fitCamera(CameraFit.bounds(
                  bounds: LatLngBounds(LatLng(b.sul, b.oeste), LatLng(b.norte, b.leste)),
                  padding: const EdgeInsets.all(32),
                ));
              },
              child: const Icon(Icons.crop_free),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'pos',
              tooltip: _gps == null ? 'Mostrar minha posição' : 'Parar de mostrar minha posição',
              backgroundColor: _gps == null ? Colors.white : LumeCores.verdeFloresta,
              foregroundColor: _gps == null ? LumeCores.verdeFloresta : Colors.white,
              onPressed: _alternarPosicao,
              child: Icon(_gps == null ? Icons.my_location : Icons.gps_fixed),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'novo',
              tooltip: 'Registrar ocorrência',
              onPressed: () => context.push(Rotas.novaOcorrencia),
              child: const Icon(Icons.add_location_alt_outlined),
            ),
          ]),
        ),
        if (_selecionado != null)
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                FocoTile(item: _selecionado!),
                const Divider(),
                Row(children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => context.push(Rotas.navegar(_selecionado!.foco.id)),
                      icon: const Icon(Icons.near_me_outlined),
                      label: const Text('Navegar até aqui'),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => context.push(Rotas.foco(_selecionado!.foco.id)),
                      icon: const Icon(Icons.article_outlined),
                      label: const Text('Ver ficha'),
                    ),
                  ),
                ]),
              ]),
            ),
          ),
      ]),
    );
  }
}
