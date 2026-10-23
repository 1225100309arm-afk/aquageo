enum TipoNotificacion { fuga, solicitud, pago, lectura, recordatorio }

class Notificacion {
  final TipoNotificacion tipo;
  final String titulo;
  final DateTime fecha;
  bool leida;

  Notificacion({
    required this.tipo,
    required this.titulo,
    required this.fecha,
    this.leida = false,
  });
}
