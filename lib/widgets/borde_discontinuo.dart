import 'package:flutter/material.dart';

/// Contenedor con borde punteado (para la zona de fotografía).
class BordeDiscontinuo extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radio;

  const BordeDiscontinuo({
    super.key,
    required this.child,
    required this.color,
    this.radio = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _PintorDiscontinuo(color: color, radio: radio),
      child: child,
    );
  }
}

class _PintorDiscontinuo extends CustomPainter {
  final Color color;
  final double radio;

  _PintorDiscontinuo({required this.color, required this.radio});

  @override
  void paint(Canvas canvas, Size size) {
    final pincel = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final camino = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radio)),
      );
    for (final metrica in camino.computeMetrics()) {
      var distancia = 0.0;
      while (distancia < metrica.length) {
        canvas.drawPath(metrica.extractPath(distancia, distancia + 6), pincel);
        distancia += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PintorDiscontinuo viejo) =>
      viejo.color != color || viejo.radio != radio;
}
