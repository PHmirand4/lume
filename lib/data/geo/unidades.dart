import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/geo.dart';

/// Unidade de conservação (hoje, as Florestas Nacionais do ICMBio) com o
/// limite oficial simplificado.
class Unidade {
  Unidade({
    required this.id,
    required this.nome,
    required this.nomeCurto,
    required this.uf,
    required this.bioma,
    required this.areaHa,
    required this.cnuc,
    required this.poligonos,
  });

  final String id;

  /// Ex.: "Floresta Nacional de Pacotuba".
  final String nome;

  /// Ex.: "Flona de Pacotuba".
  final String nomeCurto;
  final String uf;
  final String bioma;
  final double areaHa;
  final String cnuc;

  /// Partes do limite; cada parte é uma lista de anéis (o primeiro é o
  /// contorno externo, os demais são buracos).
  final List<List<List<GeoPonto>>> poligonos;

  /// Contornos externos, para desenhar no mapa.
  Iterable<List<GeoPonto>> get contornos => poligonos.map((p) => p.first);

  bool contem(GeoPonto p) {
    for (final partes in poligonos) {
      if (!pontoNoPoligono(p, partes.first)) continue;
      if (partes.skip(1).any((buraco) => pontoNoPoligono(p, buraco))) continue;
      return true;
    }
    return false;
  }

  ({double sul, double oeste, double norte, double leste}) get limites {
    var s = 90.0, o = 180.0, n = -90.0, l = -180.0;
    for (final anel in contornos) {
      for (final p in anel) {
        if (p.lat < s) s = p.lat;
        if (p.lat > n) n = p.lat;
        if (p.lon < o) o = p.lon;
        if (p.lon > l) l = p.lon;
      }
    }
    return (sul: s, oeste: o, norte: n, leste: l);
  }

  GeoPonto get centro {
    final b = limites;
    return GeoPonto((b.sul + b.norte) / 2, (b.oeste + b.leste) / 2);
  }

  /// Ponto para o rótulo no mapa do país: o meio da maior parte.
  GeoPonto get pontoRotulo {
    var maior = contornos.first;
    for (final c in contornos) {
      if (c.length > maior.length) maior = c;
    }
    var s = 90.0, o = 180.0, n = -90.0, l = -180.0;
    for (final p in maior) {
      if (p.lat < s) s = p.lat;
      if (p.lat > n) n = p.lat;
      if (p.lon < o) o = p.lon;
      if (p.lon > l) l = p.lon;
    }
    return GeoPonto((s + n) / 2, (o + l) / 2);
  }

  /// Área legível: "450 ha" ou "1,9 mi ha".
  String get areaFormatada {
    if (areaHa >= 1e6) return '${(areaHa / 1e6).toStringAsFixed(1).replaceAll('.', ',')} mi ha';
    if (areaHa >= 1e4) return '${(areaHa / 1000).round()} mil ha';
    return '${areaHa.round()} ha';
  }
}

/// Todas as unidades disponíveis, lidas do asset `assets/geo/flonas.geojson`
/// (limites oficiais do ICMBio, simplificados).
class CatalogoUnidades {
  CatalogoUnidades(List<Unidade> unidades)
      : todas = List.unmodifiable(unidades),
        _porId = {for (final u in unidades) u.id: u};

  final List<Unidade> todas;
  final Map<String, Unidade> _porId;

  /// Unidade do MVP; também é a unidade dos registros feitos antes da v2.
  static const padrao = 'flona_pacotuba';

  static const asset = 'assets/geo/flonas.geojson';

  Unidade? porId(String? id) => id == null ? null : _porId[id];

  static Future<CatalogoUnidades> carregar() async =>
      CatalogoUnidades.deGeoJson(await rootBundle.loadString(asset));

  factory CatalogoUnidades.deGeoJson(String texto) {
    final json = jsonDecode(texto) as Map<String, dynamic>;
    return CatalogoUnidades([
      for (final f in (json['features'] as List).cast<Map<String, dynamic>>()) _unidade(f),
    ]);
  }

  static Unidade _unidade(Map<String, dynamic> f) {
    final p = f['properties'] as Map<String, dynamic>;
    final coords = (f['geometry'] as Map<String, dynamic>)['coordinates'] as List;
    return Unidade(
      id: p['id'] as String,
      nome: p['nome'] as String,
      nomeCurto: p['nome_curto'] as String,
      uf: p['uf'] as String,
      bioma: p['bioma'] as String,
      areaHa: (p['area_ha'] as num).toDouble(),
      cnuc: p['cnuc'] as String,
      poligonos: [
        for (final parte in coords)
          [
            for (final anel in parte as List)
              [for (final c in anel as List) GeoPonto((c[1] as num).toDouble(), (c[0] as num).toDouble())],
          ],
      ],
    );
  }
}
