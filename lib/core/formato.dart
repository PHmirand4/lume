import 'package:intl/intl.dart';

/// Datas ficam em UTC no banco e são exibidas no fuso do aparelho (Brasília).
String dataHora(DateTime d) => DateFormat('dd/MM/yyyy HH:mm').format(d.toLocal());
String data(DateTime d) => DateFormat('dd/MM/yyyy').format(d.toLocal());
String dataCurta(DateTime d) => DateFormat('d MMM', 'pt_BR').format(d.toLocal());
String hora(DateTime d) => DateFormat('HH:mm').format(d.toLocal());

String coordenada(double v) => v.toStringAsFixed(6);
String coordenadas(double lat, double lon) => '${coordenada(lat)}, ${coordenada(lon)}';

String precisao(double? m) => m == null ? 'sem GPS' : '±${m.round()} m';

/// "há 3 dias", "hoje", "ontem".
String haQuanto(DateTime d) {
  final hoje = DateTime.now();
  final local = d.toLocal();
  final dias = DateTime(hoje.year, hoje.month, hoje.day)
      .difference(DateTime(local.year, local.month, local.day))
      .inDays;
  if (dias <= 0) return 'hoje';
  if (dias == 1) return 'ontem';
  if (dias < 30) return 'há $dias dias';
  final meses = (dias / 30).floor();
  if (meses < 12) return meses == 1 ? 'há 1 mês' : 'há $meses meses';
  final anos = (dias / 365).floor();
  return anos <= 1 ? 'há 1 ano' : 'há $anos anos';
}

String numero(num v, {int casas = 1}) {
  if (v == v.roundToDouble()) return v.toStringAsFixed(0);
  return v.toStringAsFixed(casas).replaceAll('.', ',');
}

/// Lê número digitado com vírgula ou ponto.
double? lerNumero(String s) => double.tryParse(s.trim().replaceAll(',', '.'));
int? lerInteiro(String s) => int.tryParse(s.trim());
