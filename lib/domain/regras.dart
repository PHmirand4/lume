import '../core/geo.dart';
import 'codigos.dart';

/// Parâmetros configuráveis das regras de negócio (seção 13). Valores iniciais
/// marcados como [A CONFIRMAR] no documento.
class RegrasConfig {
  const RegrasConfig({
    this.raioMesmoFocoM = 20,
    this.erradicadoRevisitas = 3,
    this.erradicadoMeses = 12,
    this.precoceDistanciaM = 200,
    this.precoceMaxIndividuos = 5,
    this.precoceMaxAreaM2 = 10,
    this.diasParaRevisita = 30,
    this.gpsPrecisaoAlvoM = 10,
    this.gpsPrecisaoAvisoM = 30,
    this.gpsTempoMaxS = 30,
  });

  final double raioMesmoFocoM; // RN07/RN08
  final int erradicadoRevisitas; // RN13 (N)
  final int erradicadoMeses; // RN13 (X)
  final double precoceDistanciaM; // RN15/RN17
  final int precoceMaxIndividuos;
  final double precoceMaxAreaM2;
  final int diasParaRevisita;
  final double gpsPrecisaoAlvoM; // RN01
  final double gpsPrecisaoAvisoM; // RN03
  final int gpsTempoMaxS; // RN01

  RegrasConfig copyWith({
    double? raioMesmoFocoM,
    int? erradicadoRevisitas,
    int? erradicadoMeses,
    double? precoceDistanciaM,
    int? precoceMaxIndividuos,
    double? precoceMaxAreaM2,
    int? diasParaRevisita,
  }) =>
      RegrasConfig(
        raioMesmoFocoM: raioMesmoFocoM ?? this.raioMesmoFocoM,
        erradicadoRevisitas: erradicadoRevisitas ?? this.erradicadoRevisitas,
        erradicadoMeses: erradicadoMeses ?? this.erradicadoMeses,
        precoceDistanciaM: precoceDistanciaM ?? this.precoceDistanciaM,
        precoceMaxIndividuos: precoceMaxIndividuos ?? this.precoceMaxIndividuos,
        precoceMaxAreaM2: precoceMaxAreaM2 ?? this.precoceMaxAreaM2,
        diasParaRevisita: diasParaRevisita ?? this.diasParaRevisita,
      );
}

// ---------------------------------------------------------------------------
// Status do foco (RN09–RN13)
// ---------------------------------------------------------------------------

enum TipoEvento { deteccao, revisita, manejo }

/// Evento da linha do tempo de um foco, usado no cálculo do status.
class EventoFoco {
  const EventoFoco({
    required this.tipo,
    required this.data,
    this.presenca,
    this.resultado,
  });

  final TipoEvento tipo;
  final DateTime data;
  final String? presenca;
  final String? resultado;

  bool get ausente =>
      presenca == Presenca.ausente || resultado == ResultadoRevisita.ausente;
}

/// Calcula o status de um foco a partir dos eventos (em qualquer ordem).
///
/// - RN09: detecção → `detectado`.
/// - RN10: manejo → `em_controle`.
/// - RN11: revisita ausente → `controlado`.
/// - RN12: revisita com rebrota → `rebrotou`; presente depois de `controlado` → `rebrotou`.
/// - RN13: `erradicado` com N revisitas ausentes seguidas no fim da linha do tempo,
///   e pelo menos X meses entre o último registro de presença/manejo e a última ausência.
String calcularStatus(List<EventoFoco> eventos, RegrasConfig cfg) {
  if (eventos.isEmpty) return StatusFoco.detectado;
  final ordenados = [...eventos]..sort((a, b) => a.data.compareTo(b.data));

  var status = StatusFoco.detectado;
  DateTime? ultimaPresencaOuManejo;
  var ausentesSeguidas = 0;
  DateTime? ultimaAusencia;

  for (final e in ordenados) {
    switch (e.tipo) {
      case TipoEvento.deteccao:
        // Uma detecção ausente não faz sentido; trata como presença.
        status = StatusFoco.detectado;
        ultimaPresencaOuManejo = e.data;
        ausentesSeguidas = 0;
      case TipoEvento.manejo:
        status = StatusFoco.emControle;
        ultimaPresencaOuManejo = e.data;
        ausentesSeguidas = 0;
      case TipoEvento.revisita:
        if (e.ausente) {
          status = StatusFoco.controlado;
          ausentesSeguidas++;
          ultimaAusencia = e.data;
        } else {
          if (e.resultado == ResultadoRevisita.rebrota ||
              status == StatusFoco.controlado ||
              status == StatusFoco.rebrotou) {
            status = StatusFoco.rebrotou;
          }
          // Presente em foco detectado ou em controle: mantém o status.
          ultimaPresencaOuManejo = e.data;
          ausentesSeguidas = 0;
        }
    }
  }

  if (status == StatusFoco.controlado &&
      ausentesSeguidas >= cfg.erradicadoRevisitas &&
      ultimaPresencaOuManejo != null &&
      ultimaAusencia != null &&
      _mesesEntre(ultimaPresencaOuManejo, ultimaAusencia) >= cfg.erradicadoMeses) {
    status = StatusFoco.erradicado;
  }
  return status;
}

/// Meses completos entre duas datas.
int _mesesEntre(DateTime a, DateTime b) {
  var meses = (b.year - a.year) * 12 + (b.month - a.month);
  if (b.day < a.day) meses--;
  return meses;
}

// ---------------------------------------------------------------------------
// Foco próximo (RN07) e detecção precoce (RN15)
// ---------------------------------------------------------------------------

/// Resumo de um foco existente, usado nas regras espaciais.
class FocoResumo {
  const FocoResumo({
    required this.id,
    required this.especieId,
    required this.ponto,
    required this.status,
  });

  final String id;
  final String especieId;
  final GeoPonto ponto;
  final String status;
}

/// Focos da mesma espécie (não descartados) dentro de `raio + precisão`,
/// do mais próximo ao mais distante. Não se aplica a "outra espécie".
List<(FocoResumo, double)> focosProximosMesmaEspecie({
  required String especieId,
  required GeoPonto ponto,
  required double? precisaoM,
  required Iterable<FocoResumo> focos,
  required RegrasConfig cfg,
}) {
  if (especieId == especieOutra) return const [];
  final limite = cfg.raioMesmoFocoM + (precisaoM ?? 0);
  final achados = <(FocoResumo, double)>[];
  for (final f in focos) {
    if (f.especieId != especieId || f.status == StatusFoco.descartado) continue;
    final d = distanciaM(ponto, f.ponto);
    if (d <= limite) achados.add((f, d));
  }
  achados.sort((a, b) => a.$2.compareTo(b.$2));
  return achados;
}

/// Motivos que tornam uma detecção "precoce". Lista vazia = não é precoce.
List<String> motivosDeteccaoPrecoce({
  required String especieId,
  required GeoPonto ponto,
  required Iterable<FocoResumo> focosExistentes,
  required RegrasConfig cfg,
  int? nIndividuos,
  String? classeAbundancia,
  double? areaM2,
}) {
  final motivos = <String>[];
  if (especieId == especieOutra) {
    motivos.add('Possível espécie nova na Flona');
  } else {
    final mesmaEspecie = focosExistentes
        .where((f) => f.especieId == especieId && f.status != StatusFoco.descartado)
        .toList();
    if (mesmaEspecie.isEmpty) {
      motivos.add('Primeira ocorrência da espécie na Flona');
    } else {
      final ativos = mesmaEspecie.where((f) => StatusFoco.ativos.contains(f.status));
      final longe = ativos.every((f) => distanciaM(ponto, f.ponto) > cfg.precoceDistanciaM);
      if (longe) {
        motivos.add('Mais de ${cfg.precoceDistanciaM.round()} m de qualquer foco ativo (nova frente)');
      }
    }
  }
  final pequena = (nIndividuos != null && nIndividuos <= cfg.precoceMaxIndividuos) ||
      classeAbundancia == 'c1' ||
      classeAbundancia == 'c2' ||
      (areaM2 != null && areaM2 <= cfg.precoceMaxAreaM2);
  if (pequena) motivos.add('Abundância pequena');
  return motivos;
}

/// RN20: manejo químico exige produto.
bool manejoExigeHerbicida(String metodo) => MetodoManejo.quimicos.contains(metodo);

/// RN22: o autor edita por 24 h; depois, só o gestor.
bool podeEditar({
  required String perfil,
  required String autorId,
  required String usuarioId,
  required DateTime criadoEm,
  DateTime? agora,
}) {
  if (Perfil.podeGerir(perfil)) return true;
  final n = agora ?? DateTime.now().toUtc();
  return autorId == usuarioId && n.difference(criadoEm).inHours < 24;
}
