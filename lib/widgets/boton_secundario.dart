import 'package:flutter/material.dart';

import '../theme/app_tema.dart';
import 'tarjeta_aquageo.dart';

/// Botón blanco con borde, para acciones secundarias.
class BotonSecundario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icono;

  const BotonSecundario({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return TarjetaAquaGeo(
      onTap: onPressed,
      sombra: false,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 19, color: AppTema.primario),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              texto,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppTema.primario,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
