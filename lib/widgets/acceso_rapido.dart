import 'package:flutter/material.dart';

import '../theme/app_tema.dart';
import 'tarjeta_aquageo.dart';

class AccesoRapido extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String detalle;
  final Color color;
  final Color tinte;
  final VoidCallback? onTap;

  const AccesoRapido({
    super.key,
    required this.icono,
    required this.etiqueta,
    required this.detalle,
    required this.color,
    required this.tinte,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TarjetaAquaGeo(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: tinte,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icono, size: 24, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            etiqueta,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTema.texto,
            ),
          ),
          const SizedBox(height: 2),
          Text(detalle, style: AppTema.suave),
        ],
      ),
    );
  }
}
