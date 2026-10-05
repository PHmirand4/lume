import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../../data/local/database.dart';
import '../../data/remote/supabase_config.dart';
import '../../data/repositories/catalogo_repository.dart';
import '../../domain/codigos.dart';
import 'dados_exportacao.dart';

/// Data/hora ISO 8601 no fuso do aparelho, com deslocamento (ex.: -03:00).
String isoLocal(DateTime? d) {
  if (d == null) return '';
  final l = d.toLocal();
  final off = l.timeZoneOffset;
  final sinal = off.isNegative ? '-' : '+';
  final h = off.inHours.abs().toString().padLeft(2, '0');
  final m = (off.inMinutes.abs() % 60).toString().padLeft(2, '0');
  return '${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(l)}$sinal$h:$m';
}

String _n(num? v) => v == null ? '' : (v is double ? v.toString() : '$v');
String _c(double v) => v.toStringAsFixed(6);

/// CSV UTF-8 com BOM (abre direto no Excel) e separador vírgula (QGIS, R, Python).
String _csv(List<List<Object?>> linhas) => '﻿${Csv(lineDelimiter: '\n').encode(linhas)}';

// ---------------------------------------------------------------------------
// CSV no formato das planilhas do Guia do ICMBio (Ocorrências, Manejo)
// ---------------------------------------------------------------------------

String csvFocos(DadosExportacao d, Vocabulario v) => _csv([
      [
        'codigo', 'foco_id', 'nome_cientifico', 'nome_popular', 'especie_texto', 'familia',
        'latitude', 'longitude', 'precisao_m', 'origem_coordenada', 'ambiente', 'status', 'status_manual',
        'deteccao_precoce', 'motivos_deteccao_precoce', 'fora_do_limite', 'primeira_deteccao', 'ultima_visita',
        'ultima_abundancia', 'criado_por',
      ],
      for (final f in d.focos)
        [
          f.foco.codigo, f.foco.id, f.especie.nomeCientifico, f.especie.nomesPopulares.first, f.foco.especieTexto ?? '',
          f.especie.familia ?? '', _c(f.foco.lat), _c(f.foco.lon), _n(f.foco.precisaoM), f.foco.origemCoordenada,
          f.foco.ambiente ?? '', f.foco.status, f.foco.statusManual ? 'sim' : 'nao',
          f.foco.deteccaoPrecoce ? 'sim' : 'nao', f.foco.motivosPrecoce.join('; '), f.foco.foraDoLimite ? 'sim' : 'nao',
          isoLocal(f.foco.primeiraDeteccaoEm), isoLocal(f.foco.ultimaVisitaEm), f.foco.ultimaAbundancia ?? '',
          d.nomeUsuario(f.foco.criadoPor),
        ],
    ]);

String csvObservacoes(DadosExportacao d, Vocabulario v) => _csv([
      [
        'observacao_id', 'foco_codigo', 'nome_cientifico', 'tipo', 'data_hora', 'registrado_por', 'latitude', 'longitude',
        'precisao_m', 'altitude_m', 'presenca', 'resultado', 'quantificacao_tipo', 'n_individuos', 'classe_abundancia',
        'area_m2', 'cobertura_pct', 'estagio', 'ambiente', 'observacao', 'ditado', 'n_fotos', 'versao_app',
      ],
      for (final o in d.observacoes)
        [
          o.id, d.focoPorId[o.focoId]?.foco.codigo ?? '', d.focoPorId[o.focoId]?.especie.nomeCientifico ?? '', o.tipo,
          isoLocal(o.dataHora), d.nomeUsuario(o.usuarioId), _c(o.lat), _c(o.lon), _n(o.precisaoM), _n(o.altitudeM),
          o.presenca, o.resultado ?? '', o.quantificacaoTipo ?? '', _n(o.nIndividuos),
          o.classeAbundancia == null ? '' : v.rotulo(Listas.classeAbundancia, o.classeAbundancia), _n(o.areaM2),
          _n(o.coberturaPct), o.estagio ?? '', o.ambiente ?? '', o.texto ?? '', o.ditado ? 'sim' : 'nao',
          d.fotosDe(o.id), o.versaoApp ?? '',
        ],
    ]);

String csvManejos(DadosExportacao d, Vocabulario v) => _csv([
      [
        'manejo_id', 'foco_codigo', 'nome_cientifico', 'inicio', 'fim', 'metodo', 'metodo_descricao', 'herbicida_produto',
        'herbicida_concentracao', 'herbicida_volume_l', 'n_individuos_tratados', 'area_tratada_m2', 'n_pessoas', 'horas',
        'esforco_pessoa_hora', 'destinacao', 'epi_utilizado', 'condicao_tempo', 'responsavel', 'registrado_por',
        'observacao', 'n_fotos',
      ],
      for (final m in d.manejos)
        [
          m.id, d.focoPorId[m.focoId]?.foco.codigo ?? '', d.focoPorId[m.focoId]?.especie.nomeCientifico ?? '',
          isoLocal(m.dataHoraInicio), isoLocal(m.dataHoraFim), m.metodo, m.metodoTexto ?? v.rotulo(Listas.metodoManejo, m.metodo),
          m.herbicidaProduto ?? '', m.herbicidaConcentracao ?? '', _n(m.herbicidaVolumeL), _n(m.nIndividuosTratados),
          _n(m.areaTratadaM2), m.nPessoas, _n(m.horas), _n(m.nPessoas * m.horas), m.destinacao ?? '',
          m.epiUtilizado == null ? '' : (m.epiUtilizado! ? 'sim' : 'nao'), m.condicaoTempo ?? '', m.responsavel,
          d.nomeUsuario(m.usuarioId), m.texto ?? '', d.fotosDe(m.id),
        ],
    ]);

// ---------------------------------------------------------------------------
// GeoJSON e KML (QGIS, Google Earth)
// ---------------------------------------------------------------------------

String geoJsonFocos(DadosExportacao d, Vocabulario v) => const JsonEncoder.withIndent(' ').convert({
      'type': 'FeatureCollection',
      'name': 'focos_eei_flona_pacotuba',
      'features': [
        for (final f in d.focos)
          {
            'type': 'Feature',
            'geometry': {
              'type': 'Point',
              'coordinates': [double.parse(_c(f.foco.lon)), double.parse(_c(f.foco.lat))],
            },
            'properties': {
              'codigo': f.foco.codigo,
              'id': f.foco.id,
              'nome_cientifico': f.especie.nomeCientifico,
              'nome_popular': f.especie.nomesPopulares.first,
              'especie_texto': f.foco.especieTexto,
              'status': f.foco.status,
              'status_rotulo': v.rotulo(Listas.statusFoco, f.foco.status),
              'deteccao_precoce': f.foco.deteccaoPrecoce,
              'precisao_m': f.foco.precisaoM,
              'ambiente': f.foco.ambiente,
              'primeira_deteccao': isoLocal(f.foco.primeiraDeteccaoEm),
              'ultima_visita': isoLocal(f.foco.ultimaVisitaEm),
              'ultima_abundancia': f.foco.ultimaAbundancia,
            },
          },
      ],
    });

String _xml(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

/// Cores KML (aabbggrr) por status.
const _corKml = {
  StatusFoco.detectado: 'ff0552e3',
  StatusFoco.emControle: 'ffaa6b2c',
  StatusFoco.rebrotou: 'ff2828b4',
  StatusFoco.controlado: 'ff529b5e',
  StatusFoco.erradicado: 'ff3f6138',
  StatusFoco.descartado: 'ff8f958a',
};

String kmlFocos(DadosExportacao d, Vocabulario v) {
  final b = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
    ..writeln('<kml xmlns="http://www.opengis.net/kml/2.2"><Document>')
    ..writeln('<name>Focos de EEI — Flona de Pacotuba</name>');
  _corKml.forEach((s, cor) => b.writeln(
      '<Style id="$s"><IconStyle><color>$cor</color><scale>1.1</scale>'
      '<Icon><href>http://maps.google.com/mapfiles/kml/shapes/placemark_circle.png</href></Icon></IconStyle></Style>'));
  for (final f in d.focos) {
    b
      ..writeln('<Placemark><name>${_xml(f.foco.codigo)}</name><styleUrl>#${f.foco.status}</styleUrl>')
      ..writeln('<description>${_xml('${f.nomeExibicao} (${f.especie.nomeCientifico}) — '
          '${v.rotulo(Listas.statusFoco, f.foco.status)}. Última visita: ${isoLocal(f.foco.ultimaVisitaEm)}.')}</description>')
      ..writeln('<Point><coordinates>${_c(f.foco.lon)},${_c(f.foco.lat)},0</coordinates></Point></Placemark>');
  }
  b.writeln('</Document></kml>');
  return b.toString();
}

// ---------------------------------------------------------------------------
// Darwin Core (§12.4)
// ---------------------------------------------------------------------------

String _codigoAnonimo(String usuarioId) => 'obs-${usuarioId.replaceAll('-', '').substring(0, 8)}';

String csvDarwinCore(DadosExportacao d, Vocabulario v, {required bool anonimizar}) {
  String? quantidade(Observacao o) => switch (o.quantificacaoTipo) {
        'area' => o.areaM2?.toString(),
        'cobertura' => o.coberturaPct?.toString(),
        'classe' => o.classeAbundancia == null ? null : v.rotulo(Listas.classeAbundancia, o.classeAbundancia),
        _ => null,
      };
  String? tipoQuantidade(Observacao o) => switch (o.quantificacaoTipo) {
        'area' => 'square meters',
        'cobertura' => '% of area',
        'classe' => 'abundance class',
        _ => null,
      };
  String midias(Observacao o) => d.midias
      .where((m) => m.donoId == o.id && m.caminhoRemoto != null)
      .map((m) => SupabaseConfig.configurado
          ? '${SupabaseConfig.url}/storage/v1/object/${SupabaseConfig.bucketMidias}/${m.caminhoRemoto}'
          : m.caminhoRemoto!)
      .join(' | ');

  return _csv([
    [
      'occurrenceID', 'basisOfRecord', 'eventDate', 'recordedBy', 'scientificName', 'vernacularName', 'family',
      'kingdom', 'decimalLatitude', 'decimalLongitude', 'geodeticDatum', 'coordinateUncertaintyInMeters',
      'occurrenceStatus', 'individualCount', 'organismQuantity', 'organismQuantityType', 'lifeStage', 'habitat',
      'establishmentMeans', 'degreeOfEstablishment', 'locationID', 'locality', 'municipality', 'stateProvince',
      'countryCode', 'occurrenceRemarks', 'associatedMedia',
    ],
    for (final o in d.observacoes)
      if (d.focoPorId[o.focoId] case final f?)
        [
          o.id,
          'HumanObservation',
          isoLocal(o.dataHora),
          anonimizar ? _codigoAnonimo(o.usuarioId) : d.nomeUsuario(o.usuarioId),
          f.foco.especieId == especieOutra ? (f.foco.especieTexto ?? '') : f.especie.nomeCientifico,
          f.foco.especieId == especieOutra ? '' : f.especie.nomesPopulares.first,
          f.especie.familia ?? '',
          'Plantae',
          _c(o.lat),
          _c(o.lon),
          'WGS84',
          _n(o.precisaoM),
          o.presenca == Presenca.ausente ? 'absent' : 'present',
          _n(o.nIndividuos),
          quantidade(o) ?? '',
          tipoQuantidade(o) ?? '',
          o.estagio == null ? '' : v.rotulo(Listas.estagio, o.estagio),
          o.ambiente == null ? '' : v.rotulo(Listas.ambiente, o.ambiente),
          'introduced',
          'invasive',
          f.foco.codigo,
          'Floresta Nacional de Pacotuba',
          'Cachoeiro de Itapemirim',
          'Espírito Santo',
          'BR',
          o.texto ?? '',
          midias(o),
        ],
  ]);
}

