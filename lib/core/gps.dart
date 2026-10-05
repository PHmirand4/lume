import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

enum ProblemaGps { servicoDesligado, semPermissao, permissaoNegadaSempre }

class LeituraGps {
  const LeituraGps({
    required this.lat,
    required this.lon,
    required this.precisaoM,
    this.altitudeM,
    required this.data,
  });

  final double lat;
  final double lon;
  final double precisaoM;
  final double? altitudeM;
  final DateTime data;

  factory LeituraGps.de(Position p) => LeituraGps(
        lat: p.latitude,
        lon: p.longitude,
        precisaoM: p.accuracy,
        altitudeM: p.altitude == 0 ? null : p.altitude,
        data: p.timestamp.toUtc(),
      );
}

/// Garante serviço de localização ligado e permissão concedida.
Future<ProblemaGps?> prepararGps() async {
  if (!await Geolocator.isLocationServiceEnabled()) return ProblemaGps.servicoDesligado;
  var perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.denied) {
    perm = await Geolocator.requestPermission();
  }
  if (perm == LocationPermission.deniedForever) return ProblemaGps.permissaoNegadaSempre;
  if (perm == LocationPermission.denied) return ProblemaGps.semPermissao;
  return null;
}

String mensagemProblemaGps(ProblemaGps p) => switch (p) {
      ProblemaGps.servicoDesligado => 'A localização do aparelho está desligada.',
      ProblemaGps.semPermissao => 'O Lume não tem permissão para usar a localização.',
      ProblemaGps.permissaoNegadaSempre =>
        'A permissão de localização foi negada. Libere nas configurações do aparelho.',
    };

LocationSettings _configAltaPrecisao() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return AndroidSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
      intervalDuration: const Duration(seconds: 1),
    );
  }
  return const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 0);
}

/// Coleta de GPS para registro (RN01–RN02): lê em alta precisão por até
/// [tempoMax] ou até atingir [precisaoAlvoM], guardando a melhor leitura.
class ColetorGps extends ChangeNotifier {
  ColetorGps({this.tempoMax = const Duration(seconds: 30), this.precisaoAlvoM = 10});

  final Duration tempoMax;
  final double precisaoAlvoM;

  LeituraGps? melhor;
  LeituraGps? ultima;
  ProblemaGps? problema;
  bool coletando = false;
  int segundos = 0;

  StreamSubscription<Position>? _sub;
  Timer? _relogio;
  bool _descartado = false;

  bool get concluido => !coletando && melhor != null;

  Future<void> iniciar() async {
    await parar();
    problema = await prepararGps();
    if (problema != null) {
      _notificar();
      return;
    }
    coletando = true;
    segundos = 0;
    _notificar();
    _relogio = Timer.periodic(const Duration(seconds: 1), (_) {
      segundos++;
      if (segundos >= tempoMax.inSeconds) {
        parar();
      } else {
        _notificar();
      }
    });
    _sub = Geolocator.getPositionStream(locationSettings: _configAltaPrecisao()).listen(
      (p) {
        final l = LeituraGps.de(p);
        ultima = l;
        if (melhor == null || l.precisaoM <= melhor!.precisaoM) melhor = l;
        if (l.precisaoM <= precisaoAlvoM) {
          parar();
        } else {
          _notificar();
        }
      },
      onError: (Object _) => parar(),
    );
  }

  Future<void> parar() async {
    _relogio?.cancel();
    _relogio = null;
    await _sub?.cancel();
    _sub = null;
    if (coletando) {
      coletando = false;
      _notificar();
    }
  }

  void _notificar() {
    if (!_descartado) notifyListeners();
  }

  @override
  void dispose() {
    _descartado = true;
    parar();
    super.dispose();
  }
}

/// Fluxo contínuo de posições (tela de navegação e "minha posição" no mapa).
Stream<LeituraGps> fluxoPosicao() =>
    Geolocator.getPositionStream(locationSettings: _configAltaPrecisao()).map(LeituraGps.de);
