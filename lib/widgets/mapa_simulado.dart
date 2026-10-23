import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

/// Mapa de relleno (sin GPS ni mapas reales todavía).
/// Dibuja calles de ejemplo y un pin cuando ya hay ubicación.
class MapaSimulado extends StatelessWidget {
  final bool conUbicacion;
  final String? leyenda;

  const MapaSimulado({super.key, required this.conUbicacion, this.leyenda});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTema.borde),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: CustomPaint(painter: _PintorCalles())),
          Icon(
            Icons.location_on_rounded,
            size: conUbicacion ? 46 : 38,
            color: conUbicacion ? AppTema.peligro : AppTema.iconoInactivo,
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppTema.tarjeta,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                leyenda ?? 'Aún sin ubicación',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTema.textoSuave,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PintorCalles extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final calle = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final rio = Paint()
      ..color = const Color(0xFFBFE3EC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, size.height * 0.30), Offset(size.width, size.height * 0.42), calle);
    canvas.drawLine(Offset(0, size.height * 0.75), Offset(size.width, size.height * 0.62), calle);
    canvas.drawLine(Offset(size.width * 0.28, 0), Offset(size.width * 0.36, size.height), calle);
    canvas.drawLine(Offset(size.width * 0.72, 0), Offset(size.width * 0.64, size.height), calle);

    final camino = Path()
      ..moveTo(0, size.height * 0.10)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.55, size.width, size.height * 0.15);
    canvas.drawPath(camino, rio);
  }

  @override
  bool shouldRepaint(covariant CustomPainter viejo) => false;
}
