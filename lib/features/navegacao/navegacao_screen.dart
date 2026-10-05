import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../core/formato.dart' as fmt;
import '../../core/geo.dart';
import '../../core/gps.dart';
import '../../widgets/comuns.dart';
import '../../widgets/marcador_status.dart';

/// T09 — Navegar até o foco: seta (rumo compensado pela bússola) e distância.
/// Ao chegar a ≤ 20 m (considerando a precisão), sugere registrar a revisita.
class NavegacaoScreen extends ConsumerStatefulWidget {
  const NavegacaoScreen({super.key, required this.focoId});

  final String focoId;

  @override
  ConsumerState<NavegacaoScreen> createState() => _NavegacaoScreenState();
}

class _NavegacaoScreenState extends ConsumerState<NavegacaoScreen> {
  StreamSubscription<LeituraGps>? _gps;
  StreamSubscription<CompassEvent>? _bussola;
  LeituraGps? _pos;
  double? _rumoAparelho;
  bool _semBussola = false;
  String? _problema;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final p = await prepararGps();
    if (p != null) {
      setState(() => _problema = mensagemProblemaGps(p));
      return;
    }
    _gps = fluxoPosicao().listen((l) => setState(() => _pos = l));
    final eventos = FlutterCompass.events;
    if (eventos == null) {
      setState(() => _semBussola = true);
    } else {
      _bussola = eventos.listen((e) {
        if (e.heading == null) {
          if (!_semBussola) setState(() => _semBussola = true);
        } else {
          setState(() => _rumoAparelho = e.heading);
        }
      });
    }
  }

  @override
  void dispose() {
    _gps?.cancel();
    _bussola?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = ref.watch(focoProvider(widget.focoId)).value;
    final raio = ref.watch(regrasAtuaisProvider).raioMesmoFocoM;
    final t = Theme.of(context).textTheme;
    if (item == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final alvo = GeoPonto(item.foco.lat, item.foco.lon);
    final aqui = _pos == null ? null : GeoPonto(_pos!.lat, _pos!.lon);
    final dist = aqui == null ? null : distanciaM(aqui, alvo);
    final rumo = aqui == null ? null : rumoGraus(aqui, alvo);
    final chegou = dist != null && dist <= raio + (_pos!.precisaoM.clamp(0, 30));
    // Seta relativa ao aparelho: rumo ao foco menos para onde o aparelho aponta.
    final angulo = rumo == null ? null : (rumo - (_rumoAparelho ?? 0)) * math.pi / 180;

    return Scaffold(
      backgroundColor: LumeCores.verdeNoite,
      appBar: AppBar(
        backgroundColor: LumeCores.verdeNoite,
        foregroundColor: Colors.white,
        title: Text('Até ${item.foco.codigo}', style: estiloCodigo(tamanho: 19, cor: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(children: [
              MarcadorStatus(status: item.foco.status, tamanho: 26, precoce: item.foco.deteccaoPrecoce),
              const SizedBox(width: 10),
              Expanded(child: Text(item.nomeExibicao, style: t.titleLarge!.copyWith(color: Colors.white))),
            ]),
            const SizedBox(height: 12),
            if (_problema != null) Aviso(_problema!, tipo: TipoAviso.erro),
            Expanded(
              child: Center(
                child: chegou
                    ? Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.where_to_vote, size: 120, color: LumeCores.mentaClara),
                        const SizedBox(height: 8),
                        Text('Você chegou ao foco', style: t.headlineSmall!.copyWith(color: Colors.white)),
                      ])
                    : angulo == null
                        ? Column(mainAxisSize: MainAxisSize.min, children: [
                            const CircularProgressIndicator(color: LumeCores.mentaClara),
                            const SizedBox(height: 16),
                            Text('Procurando sua posição…', style: t.bodyLarge!.copyWith(color: Colors.white70)),
                          ])
                        : AspectRatio(
                            aspectRatio: 1,
                            child: Stack(alignment: Alignment.center, children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white24, width: 2),
                                ),
                              ),
                              Transform.rotate(
                                angle: angulo,
                                child: const Icon(Icons.navigation, size: 200, color: LumeCores.mentaClara),
                              ),
                            ]),
                          ),
              ),
            ),
            Text(dist == null ? '—' : formatarDistancia(dist), style: estiloCodigo(tamanho: 54, cor: Colors.white)),
            if (rumo != null)
              Text('Rumo ${rumo.round()}° ${pontoCardeal(rumo)}', style: estiloMono(tamanho: 15, cor: Colors.white70)),
            const SizedBox(height: 6),
            Text(
              _pos == null ? 'GPS: aguardando' : 'Precisão do GPS: ${fmt.precisao(_pos!.precisaoM)}',
              style: estiloMono(tamanho: 14, cor: LumeCores.mentaClara),
            ),
            if (_semBussola)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Bússola indisponível: a seta aponta como se o celular estivesse virado para o norte.',
                  textAlign: TextAlign.center,
                  style: t.bodySmall!.copyWith(color: Colors.white70),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: chegou ? LumeCores.mentaClara : Colors.white,
                  foregroundColor: LumeCores.verdeNoite,
                  minimumSize: const Size.fromHeight(60),
                ),
                onPressed: () => context.pushReplacement(Rotas.revisita(item.foco.id)),
                icon: const Icon(Icons.replay),
                label: Text(chegou ? 'Registrar revisita' : 'Registrar revisita mesmo assim'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
