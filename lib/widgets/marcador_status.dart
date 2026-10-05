import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../domain/codigos.dart';

/// Marcador de status do foco: forma + cor (seção 16.1).
class MarcadorStatus extends StatelessWidget {
  const MarcadorStatus({
    super.key,
    required this.status,
    this.tamanho = 20,
    this.precoce = false,
    this.selecionado = false,
  });

  final String status;
  final double tamanho;

  /// Detecção precoce ganha um halo laranja (RN16).
  final bool precoce;
  final bool selecionado;

  @override
  Widget build(BuildContext context) {
    final e = EstiloStatus.de(status);
    return Semantics(
      label: e.rotulo + (precoce ? ', detecção precoce' : ''),
      child: CustomPaint(
        size: Size.square(tamanho),
        painter: _PintorStatus(e, precoce: precoce, selecionado: selecionado),
      ),
    );
  }
}

class _PintorStatus extends CustomPainter {
  _PintorStatus(this.e, {required this.precoce, required this.selecionado});

  final EstiloStatus e;
  final bool precoce;
  final bool selecionado;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final miolo = r * (precoce || selecionado ? 0.62 : 0.8);

    if (selecionado) {
      canvas.drawCircle(c, r, Paint()..color = LumeCores.verdeNoite.withValues(alpha: 0.25));
    } else if (precoce) {
      canvas.drawCircle(c, r, Paint()..color = LumeCores.laranjaAlerta.withValues(alpha: 0.28));
      canvas.drawCircle(
          c,
          r - 1,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = LumeCores.laranjaAlerta);
    }

    final cheio = Paint()..color = e.cor;
    final contornoBranco = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, miolo * 0.18)
      ..color = Colors.white;
    final traco = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.5, miolo * 0.38)
      ..color = e.cor;

    switch (e.forma) {
      case FormaStatus.circulo:
        canvas.drawCircle(c, miolo, cheio);
        canvas.drawCircle(c, miolo, contornoBranco);
      case FormaStatus.anel:
        canvas.drawCircle(c, miolo, Paint()..color = Colors.white);
        canvas.drawCircle(c, miolo - traco.strokeWidth / 2, traco);
      case FormaStatus.triangulo:
        final h = miolo * 1.9;
        final path = Path()
          ..moveTo(c.dx, c.dy - h * 0.58)
          ..lineTo(c.dx + h * 0.58, c.dy + h * 0.42)
          ..lineTo(c.dx - h * 0.58, c.dy + h * 0.42)
          ..close();
        canvas.drawPath(path, cheio);
        canvas.drawPath(path, contornoBranco);
      case FormaStatus.quadrado:
      case FormaStatus.quadradoCheck:
        final ret = RRect.fromRectAndRadius(
            Rect.fromCircle(center: c, radius: miolo * 0.88), Radius.circular(miolo * 0.18));
        canvas.drawRRect(ret, cheio);
        canvas.drawRRect(ret, contornoBranco);
        if (e.forma == FormaStatus.quadradoCheck) {
          final s = miolo * 0.5;
          final check = Path()
            ..moveTo(c.dx - s, c.dy)
            ..lineTo(c.dx - s * 0.25, c.dy + s * 0.7)
            ..lineTo(c.dx + s, c.dy - s * 0.65);
          canvas.drawPath(
              check,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = math.max(1.8, miolo * 0.24)
                ..strokeCap = StrokeCap.round
                ..strokeJoin = StrokeJoin.round
                ..color = Colors.white);
        }
      case FormaStatus.circuloVazado:
        canvas.drawCircle(c, miolo, Paint()..color = Colors.white);
        canvas.drawCircle(
            c,
            miolo - 1.5,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.5
              ..color = e.cor);
    }
  }

  @override
  bool shouldRepaint(_PintorStatus old) =>
      old.e != e || old.precoce != precoce || old.selecionado != selecionado;
}

/// Etiqueta de status: marcador + rótulo.
class EtiquetaStatus extends StatelessWidget {
  const EtiquetaStatus({super.key, required this.status, this.compacta = false});

  final String status;
  final bool compacta;

  @override
  Widget build(BuildContext context) {
    final e = EstiloStatus.de(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compacta ? 6 : 8, vertical: compacta ? 2 : 4),
      decoration: BoxDecoration(
        color: e.cor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: e.cor.withValues(alpha: 0.45)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        MarcadorStatus(status: status, tamanho: compacta ? 12 : 14),
        const SizedBox(width: 6),
        Text(
          e.rotulo,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: status == StatusFoco.detectado ? LumeCores.laranjaTexto : LumeCores.grafite,
                fontSize: compacta ? 12 : 13,
              ),
        ),
      ]),
    );
  }
}

/// Selo "Detecção precoce".
class SeloPrecoce extends StatelessWidget {
  const SeloPrecoce({super.key, this.compacto = false});

  final bool compacto;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: compacto ? 6 : 8, vertical: compacto ? 2 : 4),
        decoration: BoxDecoration(
          color: LumeCores.laranjaAlerta,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.bolt, size: compacto ? 13 : 15, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            compacto ? 'Precoce' : 'Detecção precoce',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.white, fontSize: compacto ? 11.5 : 13),
          ),
        ]),
      );
}

/// Legenda completa dos status (mapa e configurações).
class LegendaStatus extends StatelessWidget {
  const LegendaStatus({super.key});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          for (final s in StatusFoco.todos)
            Row(mainAxisSize: MainAxisSize.min, children: [
              MarcadorStatus(status: s, tamanho: 16),
              const SizedBox(width: 5),
              Text(EstiloStatus.de(s).rotulo, style: Theme.of(context).textTheme.bodySmall),
            ]),
        ],
      );
}
