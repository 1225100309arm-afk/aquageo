import 'package:flutter/material.dart';

import '../models/actividad.dart';
import '../models/notificacion.dart';
import '../theme/app_tema.dart';

/// Ícono + colores para cada tipo de actividad / notificación.
class EstiloIcono {
  final IconData icono;
  final Color color;
  final Color tinte;

  const EstiloIcono(this.icono, this.color, this.tinte);
}

EstiloIcono estiloActividad(TipoActividad tipo) {
  switch (tipo) {
    case TipoActividad.lectura:
      return const EstiloIcono(Icons.show_chart_rounded, AppTema.violeta, AppTema.violetaTinte);
    case TipoActividad.pago:
      return const EstiloIcono(Icons.check_circle_rounded, AppTema.exito, AppTema.exitoTinte);
    case TipoActividad.solicitud:
      return const EstiloIcono(Icons.description_rounded, AppTema.azul, AppTema.azulTinte);
    case TipoActividad.fuga:
      return const EstiloIcono(Icons.warning_amber_rounded, AppTema.alerta, AppTema.alertaTinte);
  }
}

EstiloIcono estiloNotificacion(TipoNotificacion tipo) {
  switch (tipo) {
    case TipoNotificacion.fuga:
      return const EstiloIcono(Icons.warning_amber_rounded, AppTema.alerta, AppTema.alertaTinte);
    case TipoNotificacion.solicitud:
      return const EstiloIcono(Icons.description_rounded, AppTema.azul, AppTema.azulTinte);
    case TipoNotificacion.pago:
      return const EstiloIcono(Icons.check_circle_rounded, AppTema.exito, AppTema.exitoTinte);
    case TipoNotificacion.lectura:
      return const EstiloIcono(Icons.show_chart_rounded, AppTema.violeta, AppTema.violetaTinte);
    case TipoNotificacion.recordatorio:
      return const EstiloIcono(Icons.schedule_rounded, AppTema.primario, AppTema.primarioTinte);
  }
}
