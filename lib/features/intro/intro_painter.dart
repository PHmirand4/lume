import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

import '../../app/theme.dart';

/// Linha do tempo da abertura (frações do controller, 0–1).
abstract final class FasesIntro {
  static const surgir = Interval(0.00, 0.12, curve: Curves.easeOut); // floresta e vaga-lumes aparecem
  static const convergir = Interval(0.26, 0.58, curve: Curves.easeInOutCubic); // vaga-lumes formam o marcador
  static const acender = Interval(0.54, 0.66, curve: Curves.easeOutCubic); // contorno brilha
  static const marcador = Interval(0.58, 0.74, curve: Curves.elasticOut); // símbolo da marca entra
  static const ping = Interval(0.62, 0.86, curve: Curves.easeOut); // anéis de GPS
  static const letras = Interval(0.66, 0.80); // L-U-M-E
  static const slogan = Interval(0.76, 0.86, curve: Curves.easeOut);
  static const revelar = Interval(0.86, 1.00, curve: Curves.easeInOutCubic); // luz abre e revela o app

  static const instanteVibracao = 0.60;
}

/// Um vaga-lume: vagueia pela floresta e depois voa até um ponto do contorno.
class Vagalume {
  Vagalume(math.Random r, this.alvo)
    : inicio = Offset(r.nextDouble(), 0.25 + r.nextDouble() * 0.7),
      fase = r.nextDouble() * math.pi * 2,
      freq = 0.6 + r.nextDouble() * 1.1,
      amplitude = 0.02 + r.nextDouble() * 0.05,
      piscar = 2.2 + r.nextDouble() * 3.5,
      tamanho = 1.6 + r.nextDouble() * 1.8,
      atraso = r.nextDouble() * 0.35,
      quente = r.nextDouble() < 0.35;

  final Offset inicio; // fração da tela
  final Offset alvo; // posição absoluta no contorno do marcador
  final double fase;
  final double freq;
  final double amplitude;
  final double piscar;
  final double tamanho;
  final double atraso; // escalonamento da convergência
  final bool quente; // alguns puxam para o amarelo, como vaga-lume de verdade
}

/// Contorno do marcador do mapa (gota) dentro de uma caixa de largura [w].
/// Proporção do `lume-marcador.svg` (197 × 270).
Path contornoMarcador(Offset centro, double w) {
  final h = w * 270 / 197;
  final topo = centro.dy - h / 2;
  final c = Offset(centro.dx, topo + w * 0.5);
  final r = w * 0.47;
  final ponta = Offset(centro.dx, topo + h);
  final d = ponta.dy - c.dy;
  final beta = math.acos(r / d);
  final theta = math.pi / 2 - beta;
  final tDir = Offset(c.dx + r * math.cos(theta), c.dy + r * math.sin(theta));
  return Path()
    ..moveTo(ponta.dx, ponta.dy)
    ..lineTo(tDir.dx, tDir.dy)
    ..arcTo(Rect.fromCircle(center: c, radius: r), theta, -(2 * math.pi - 2 * beta), false)
    ..close();
}

/// Pontos igualmente espaçados ao longo de um caminho.
List<Offset> amostrar(Path caminho, int n) {
  final metricas = caminho.computeMetrics().toList();
  final total = metricas.fold<double>(0, (s, m) => s + m.length);
  final pontos = <Offset>[];
  for (var i = 0; i < n; i++) {
    var dist = total * i / n;
    for (final m in metricas) {
      if (dist <= m.length) {
        pontos.add(m.getTangentForOffset(dist)!.position);
        break;
      }
      dist -= m.length;
    }
  }
  return pontos;
}

/// Sprite de brilho (branco, núcleo forte + halo suave), desenhado uma vez só.
/// Os vaga-lumes são pintados com ele via `drawRawAtlas`, numa única chamada
/// por frame, em vez de dezenas de círculos com blur.
ui.Image criarSpriteBrilho() {
  const lado = 64.0;
  final rec = ui.PictureRecorder();
  final c = Canvas(rec);
  const centro = Offset(lado / 2, lado / 2);
  c.drawCircle(
    centro,
    lado / 2,
    Paint()
      ..shader = ui.Gradient.radial(
        centro,
        lado / 2,
        const [Color(0xFFFFFFFF), Color(0xF5FFFFFF), Color(0x8CFFFFFF), Color(0x26FFFFFF), Color(0x00FFFFFF)],
        const [0, 0.13, 0.26, 0.55, 1],
      ),
  );
  return rec.endRecording().toImageSync(lado.toInt(), lado.toInt());
}

/// Recursos que não mudam entre frames (calculados uma vez por tamanho de tela).
class CenaIntro {
  CenaIntro({
    required this.vagalumes,
    required this.contorno,
    required this.centroMarcador,
    required this.floresta,
    required this.sprite,
    required Size tamanho,
  }) : metricas = contorno.computeMetrics().toList(),
       pontaMarcador = contorno.getBounds().bottomCenter,
       ceu = Paint()
         ..shader = ui.Gradient.linear(
           Offset.zero,
           Offset(0, tamanho.height),
           const [Color(0xFF0B1A10), LumeCores.verdeNoite, Color(0xFF15291A)],
           const [0, 0.55, 1],
         ),
       transformacoes = Float32List(vagalumes.length * 4),
       retangulos = Float32List(vagalumes.length * 4),
       cores = Int32List(vagalumes.length);

  final List<Vagalume> vagalumes;
  final Path contorno;
  final Offset centroMarcador;
  final List<Path> floresta;
  final ui.Image sprite;
  final List<ui.PathMetric> metricas;
  final Offset pontaMarcador;
  final Paint ceu;

  // Buffers reaproveitados a cada frame (sem alocar no meio da animação).
  final Float32List transformacoes;
  final Float32List retangulos;
  final Int32List cores;
}

class PintorIntro extends CustomPainter {
  PintorIntro({required this.t, required this.segundos, required this.cena});

  final double t; // progresso 0–1
  final double segundos; // tempo corrido, para o piscar
  final CenaIntro cena;

  static const _menta = LumeCores.mentaClara;
  static const _amarelo = Color(0xFFE9F59B);
  static const _coresFloresta = [Color(0xFF16301D), Color(0xFF10251A), Color(0xFF0A1A11)];
  static final _pincelFloresta = Paint();
  static final _pincelAtlas = Paint()..filterQuality = FilterQuality.low;
  static final _pincelBrilho = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 7
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
  static final _pincelTraco = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.2
    ..strokeCap = StrokeCap.round;
  static final _pincelPing = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  double _f(Interval i) => i.transform(t.clamp(0.0, 1.0));

  @override
  void paint(Canvas canvas, Size size) {
    final surgir = _f(FasesIntro.surgir);
    final acender = _f(FasesIntro.acender);
    final centro = cena.centroMarcador;

    // 1. Céu noturno com um brilho que cresce no centro quando o marcador acende.
    canvas.drawRect(Offset.zero & size, cena.ceu);
    if (acender > 0) {
      final r = size.shortestSide * (0.4 + 0.5 * acender);
      canvas.drawCircle(
        centro,
        r,
        Paint()
          ..shader = ui.Gradient.radial(centro, r, [
            _menta.withValues(alpha: 0.22 * acender),
            _menta.withValues(alpha: 0),
          ]),
      );
    }

    // 2. Copa da floresta em camadas (leve parallax subindo).
    for (var i = 0; i < cena.floresta.length; i++) {
      final subida = (1 - surgir) * 40 * (i + 1) - t * 10 * (i + 1);
      canvas.save();
      canvas.translate(0, subida);
      canvas.drawPath(cena.floresta[i], _pincelFloresta..color = _coresFloresta[i % _coresFloresta.length]);
      canvas.restore();
    }

    // 3. Vaga-lumes: um sprite de brilho por vaga-lume, todos numa chamada só.
    final some = 1 - _f(const Interval(0.66, 0.78));
    if (surgir > 0 && some > 0) {
      final lado = cena.sprite.width.toDouble();
      final tr = cena.transformacoes;
      final re = cena.retangulos;
      final co = cena.cores;
      const duracaoIda = 0.32 - 0.06; // FasesIntro.convergir menos a folga do escalonamento
      var n = 0;
      for (final v in cena.vagalumes) {
        final ida = Curves.easeInOutCubic.transform(
          ((t - FasesIntro.convergir.begin - v.atraso * 0.18) / duracaoIda).clamp(0.0, 1.0),
        );
        final s = segundos * v.freq + v.fase;
        final vx = (v.inicio.dx + math.sin(s) * v.amplitude) * size.width;
        final vy = (v.inicio.dy + math.cos(s * 0.8) * v.amplitude - segundos * 0.012) * size.height;
        // Arco suave até o alvo (curva de Bézier quadrática).
        final mx = (vx + v.alvo.dx) / 2 + math.sin(v.fase) * 60;
        final my = (vy + v.alvo.dy) / 2 - 40;
        final u = 1 - ida;
        final px = vx * u * u + mx * 2 * u * ida + v.alvo.dx * ida * ida;
        final py = vy * u * u + my * 2 * u * ida + v.alvo.dy * ida * ida;

        final pisca = 0.35 + 0.65 * math.pow(math.sin(segundos * v.piscar + v.fase), 2);
        final brilho = (pisca + (1 - pisca) * ida) * surgir * some;
        if (brilho <= 0.01) continue;
        final cor = Color.lerp(v.quente ? _amarelo : _menta, _menta, ida)!;
        final escala = v.tamanho * (6.0 + 1.6 * ida) * 2 / lado;
        final i4 = n * 4;
        tr[i4] = escala; // scos
        tr[i4 + 1] = 0; // ssin
        tr[i4 + 2] = px - lado / 2 * escala;
        tr[i4 + 3] = py - lado / 2 * escala;
        re[i4] = 0;
        re[i4 + 1] = 0;
        re[i4 + 2] = lado;
        re[i4 + 3] = lado;
        co[n] = cor.withValues(alpha: brilho.clamp(0.0, 1.0)).toARGB32();
        n++;
      }
      if (n > 0) {
        canvas.drawRawAtlas(
          cena.sprite,
          Float32List.sublistView(tr, 0, n * 4),
          Float32List.sublistView(re, 0, n * 4),
          Int32List.sublistView(co, 0, n),
          BlendMode.modulate,
          null,
          _pincelAtlas,
        );
      }
    }

    // 4. Contorno do marcador acendendo (traço que se desenha + brilho).
    if (acender > 0) {
      final apaga = 1 - _f(const Interval(0.70, 0.80));
      if (apaga > 0) {
        _pincelBrilho.color = _menta.withValues(alpha: 0.45 * apaga);
        _pincelTraco.color = const Color(0xFFF2FFF4).withValues(alpha: apaga);
        for (final m in cena.metricas) {
          final trecho = m.extractPath(0, m.length * acender);
          canvas.drawPath(trecho, _pincelBrilho);
          canvas.drawPath(trecho, _pincelTraco);
        }
      }
    }

    // 5. Ping de GPS: anéis saindo da ponta do marcador.
    final ping = _f(FasesIntro.ping);
    if (ping > 0 && ping < 1) {
      for (var k = 0; k < 2; k++) {
        final pk = ((ping - k * 0.25) / 0.75).clamp(0.0, 1.0);
        if (pk <= 0) continue;
        canvas.drawOval(
          Rect.fromCenter(center: cena.pontaMarcador, width: 30 + 220 * pk, height: (30 + 220 * pk) * 0.32),
          _pincelPing..color = _menta.withValues(alpha: 0.7 * (1 - pk)),
        );
      }
    }
  }

  @override
  bool shouldRepaint(PintorIntro old) => old.t != t || old.segundos != segundos;
}

/// Raio da janela de luz que revela o app (até cobrir a diagonal da tela).
double raioRevelacao(Size size, Offset centro, double p) {
  final cantos = [Offset.zero, Offset(size.width, 0), Offset(0, size.height), Offset(size.width, size.height)];
  return p * cantos.map((c) => (c - centro).distance).reduce(math.max);
}

/// Anel de luz creme na borda da revelação.
class PintorAnelRevelacao extends CustomPainter {
  PintorAnelRevelacao(this.centro, this.raio, this.p);

  final Offset centro;
  final double raio;
  final double p;

  @override
  void paint(Canvas canvas, Size size) {
    if (p <= 0 || p >= 1) return;
    canvas.drawCircle(
      centro,
      raio,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30 * (1 - p) + 4
        ..color = LumeCores.creme.withValues(alpha: 0.85 * (1 - p))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
  }

  @override
  bool shouldRepaint(PintorAnelRevelacao old) => old.raio != raio || old.p != p;
}

/// Camadas da copa da floresta (silhuetas), geradas com semente fixa.
List<Path> gerarFloresta(Size size) {
  final r = math.Random(7);
  final camadas = <Path>[];
  for (var i = 0; i < 3; i++) {
    final base = size.height * (0.70 + i * 0.09);
    final altura = size.height * (0.10 - i * 0.015);
    final p = Path()..moveTo(0, size.height);
    p.lineTo(0, base);
    var x = 0.0;
    while (x < size.width) {
      final largura = 28.0 + r.nextDouble() * 46 - i * 6;
      final topo = base - altura * (0.45 + r.nextDouble() * 0.55);
      // Copas arredondadas, de vez em quando uma árvore emergente mais alta.
      final emergente = r.nextDouble() < 0.12 ? altura * 0.6 : 0.0;
      p.quadraticBezierTo(x + largura / 2, topo - emergente, x + largura, base - altura * 0.25 * r.nextDouble());
      x += largura;
    }
    p
      ..lineTo(size.width, size.height)
      ..close();
    camadas.add(p);
  }
  return camadas;
}
