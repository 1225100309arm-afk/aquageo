enum TipoActividad { lectura, pago, solicitud, fuga }

class Actividad {
  final TipoActividad tipo;
  final String titulo;
  final DateTime fecha;

  const Actividad({
    required this.tipo,
    required this.titulo,
    required this.fecha,
  });
}
