import 'package:flutter/material.dart';

/// Logo: gota de agua dentro de un círculo + nombre (opcional).
class LogoAquaGeo extends StatelessWidget {
  final double tamano;
  final bool conTexto;
  final Color colorTexto;

  const LogoAquaGeo({
    super.key,
    this.tamano = 64,
    this.conTexto = true,
    this.colorTexto = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: tamano,
          height: tamano,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 2),
          ),
          child: Icon(Icons.water_drop_rounded, color: Colors.white, size: tamano * 0.56),
        ),
        if (conTexto) ...[
          const SizedBox(height: 12),
          Text(
            'AquaGeo',
            style: TextStyle(
              fontSize: tamano * 0.5,
              fontWeight: FontWeight.w900,
              color: colorTexto,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}
