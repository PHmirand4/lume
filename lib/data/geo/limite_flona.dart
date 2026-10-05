import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/geo.dart';

/// Limite oficial da Flona de Pacotuba (KML do ICMBio convertido em GeoJSON).
class LimiteFlona {
  LimiteFlona(this.anel);

  final List<GeoPonto> anel;

  /// Coordenada de referência da ficha técnica (≈ centro da Flona).
  static const referencia = GeoPonto(-20.7453, -41.2914);

  static Future<LimiteFlona> carregar() async {
    final json = jsonDecode(await rootBundle.loadString('assets/geo/limite_flona.geojson'))
        as Map<String, dynamic>;
    final geom = (json['features'] as List).first['geometry'] as Map<String, dynamic>;
    final coords = (geom['coordinates'] as List).first as List;
    return LimiteFlona([
      for (final c in coords) GeoPonto((c[1] as num).toDouble(), (c[0] as num).toDouble()),
    ]);
  }

  bool contem(GeoPonto p) => pontoNoPoligono(p, anel);

  ({double sul, double oeste, double norte, double leste}) get limites {
    var s = 90.0, o = 180.0, n = -90.0, l = -180.0;
    for (final p in anel) {
      if (p.lat < s) s = p.lat;
      if (p.lat > n) n = p.lat;
      if (p.lon < o) o = p.lon;
      if (p.lon > l) l = p.lon;
    }
    return (sul: s, oeste: o, norte: n, leste: l);
  }
}
