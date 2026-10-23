import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

/// Botón cuadrado con ícono (atrás, notificaciones...). [aviso] pinta el punto.
class BotonIcono extends StatelessWidget {
  final IconData icono;
  final VoidCallback? onTap;
  final bool aviso;

  const BotonIcono({
    super.key,
    required this.icono,
    required this.onTap,
    this.aviso = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppTema.tarjeta,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTema.borde),
        boxShadow: AppTema.sombraSuave,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icono, size: 21, color: AppTema.texto),
              if (aviso)
                Positioned(
                  top: 11,
                  right: 12,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppTema.peligro,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTema.tarjeta, width: 1.8),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
