import 'package:flutter/material.dart';

import '../models/actividad.dart';
import '../theme/app_tema.dart';
import '../utils/formato.dart';
import 'iconos_tipo.dart';
import 'tarjeta_aquageo.dart';

class ActividadItem extends StatelessWidget {
  final Actividad actividad;

  const ActividadItem({super.key, required this.actividad});

  @override
  Widget build(BuildContext context) {
    final estilo = estiloActividad(actividad.tipo);
    return TarjetaAquaGeo(
      sombra: false,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: estilo.tinte, shape: BoxShape.circle),
            child: Icon(estilo.icono, size: 20, color: estilo.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actividad.titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTema.texto,
                  ),
                ),
                const SizedBox(height: 2),
                Text(Formato.fecha(actividad.fecha), style: AppTema.suave),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
