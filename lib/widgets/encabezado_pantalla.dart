import 'package:flutter/material.dart';

import '../theme/app_tema.dart';
import 'boton_icono.dart';

/// Encabezado de pantalla: botón atrás (opcional), título y acción (opcional).
class EncabezadoPantalla extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final VoidCallback? onAtras;
  final Widget? accion;

  const EncabezadoPantalla({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.onAtras,
    this.accion,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onAtras != null) ...[
          BotonIcono(icono: Icons.arrow_back_ios_new_rounded, onTap: onAtras),
          const SizedBox(width: 14),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: AppTema.titulo),
              if (subtitulo != null) ...[
                const SizedBox(height: 2),
                Text(subtitulo!, style: AppTema.suave),
              ],
            ],
          ),
        ),
        if (accion != null) accion!,
      ],
    );
  }
}
