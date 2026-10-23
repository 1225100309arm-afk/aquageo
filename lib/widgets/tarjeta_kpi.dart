import 'package:flutter/material.dart';

import '../theme/app_tema.dart';
import 'tarjeta_aquageo.dart';

/// Indicador del panel: ícono, cifra grande y etiqueta.
class TarjetaKpi extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String etiqueta;
  final Color color;
  final Color tinte;
  final VoidCallback? onTap;

  const TarjetaKpi({
    super.key,
    required this.icono,
    required this.valor,
    required this.etiqueta,
    required this.color,
    required this.tinte,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TarjetaAquaGeo(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tinte,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icono, size: 22, color: color),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              valor,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTema.texto,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(etiqueta, style: AppTema.suave),
        ],
      ),
    );
  }
}
