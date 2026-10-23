import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

/// Cabecera con degradado y ondas decorativas (login / registro / inicio).
class FondoOndas extends StatelessWidget {
  final double alto;
  final Widget child;
  final Gradient gradiente;

  const FondoOndas({
    super.key,
    required this.alto,
    required this.child,
    this.gradiente = AppTema.gradientePrincipal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: alto,
      child: ClipPath(
        clipper: _ClipOnda(),
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: gradiente),
          child: Stack(
            children: [
              Positioned(
                top: -50,
                right: -40,
                child: _Burbuja(tamano: 170, opacidad: 0.10),
              ),
              Positioned(
                top: 70,
                left: -60,
                child: _Burbuja(tamano: 140, opacidad: 0.08),
              ),
              Positioned(
                bottom: 30,
                right: 40,
                child: _Burbuja(tamano: 60, opacidad: 0.12),
              ),
              Positioned.fill(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _Burbuja extends StatelessWidget {
  final double tamano;
  final double opacidad;

  const _Burbuja({required this.tamano, required this.opacidad});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacidad),
      ),
    );
  }
}

class _ClipOnda extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path()..lineTo(0, size.height - 40);
    p.quadraticBezierTo(
      size.width * 0.25, size.height,
      size.width * 0.55, size.height - 22,
    );
    p.quadraticBezierTo(
      size.width * 0.82, size.height - 44,
      size.width, size.height - 14,
    );
    p.lineTo(size.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
