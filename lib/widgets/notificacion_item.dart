import 'package:flutter/material.dart';

import '../models/notificacion.dart';
import '../theme/app_tema.dart';
import '../utils/formato.dart';
import 'iconos_tipo.dart';
import 'tarjeta_aquageo.dart';

class NotificacionItem extends StatelessWidget {
  final Notificacion notificacion;
  final VoidCallback onTap;

  const NotificacionItem({
    super.key,
    required this.notificacion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final estilo = estiloNotificacion(notificacion.tipo);
    final sinLeer = !notificacion.leida;
    return TarjetaAquaGeo(
      onTap: onTap,
      sombra: false,
      colorBorde: sinLeer ? AppTema.primarioClaro : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: estilo.tinte,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(estilo.icono, color: estilo.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notificacion.titulo,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: sinLeer ? FontWeight.w800 : FontWeight.w600,
                    color: AppTema.texto,
                  ),
                ),
                const SizedBox(height: 3),
                Text(Formato.fechaHora(notificacion.fecha), style: AppTema.suave),
              ],
            ),
          ),
          if (sinLeer)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppTema.primario,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
