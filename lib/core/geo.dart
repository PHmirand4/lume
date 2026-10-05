import 'dart:math' as math;

/// Ponto geográfico simples (WGS84, graus decimais).
class GeoPonto {
  const GeoPonto(this.lat, this.lon);

  final double lat;
  final double lon;

  @override
  String toString() => '${lat.toStringAsFixed(6)}, ${lon.toStringAsFixed(6)}';
}

const double _raioTerraM = 6371008.8;

double _rad(double g) => g * math.pi / 180;
double _graus(double r) => r * 180 / math.pi;

/// Distância em metros (fórmula de haversine).
double distanciaM(GeoPonto a, GeoPonto b) {
  final dLat = _rad(b.lat - a.lat);
  final dLon = _rad(b.lon - a.lon);
  final h = math.pow(math.sin(dLat / 2), 2) +
      math.cos(_rad(a.lat)) * math.cos(_rad(b.lat)) * math.pow(math.sin(dLon / 2), 2);
  return 2 * _raioTerraM * math.asin(math.min(1, math.sqrt(h)));
}

/// Rumo inicial de [a] para [b], em graus a partir do norte (0–360).
double rumoGraus(GeoPonto a, GeoPonto b) {
  final y = math.sin(_rad(b.lon - a.lon)) * math.cos(_rad(b.lat));
  final x = math.cos(_rad(a.lat)) * math.sin(_rad(b.lat)) -
      math.sin(_rad(a.lat)) * math.cos(_rad(b.lat)) * math.cos(_rad(b.lon - a.lon));
  return (_graus(math.atan2(y, x)) + 360) % 360;
}

/// Ponto dentro do polígono (ray casting). [anel] é uma lista de pontos fechada ou não.
bool pontoNoPoligono(GeoPonto p, List<GeoPonto> anel) {
  var dentro = false;
  for (var i = 0, j = anel.length - 1; i < anel.length; j = i++) {
    final a = anel[i];
    final b = anel[j];
    final cruza = (a.lat > p.lat) != (b.lat > p.lat) &&
        p.lon < (b.lon - a.lon) * (p.lat - a.lat) / (b.lat - a.lat) + a.lon;
    if (cruza) dentro = !dentro;
  }
  return dentro;
}

/// Ponto cardeal abreviado para um rumo.
String pontoCardeal(double graus) {
  const nomes = ['N', 'NE', 'L', 'SE', 'S', 'SO', 'O', 'NO'];
  return nomes[((graus % 360) / 45).round() % 8];
}

/// Distância legível: "850 m" ou "1,2 km".
String formatarDistancia(double m) {
  if (m < 1000) return '${m.round()} m';
  return '${(m / 1000).toStringAsFixed(1).replaceAll('.', ',')} km';
}
