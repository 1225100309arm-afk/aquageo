enum TipoSolicitud { pipa, toma }

extension TipoSolicitudX on TipoSolicitud {
  String get etiqueta => this == TipoSolicitud.pipa ? 'Pipa de agua' : 'Nueva toma';

  List<String> get pasos => this == TipoSolicitud.pipa
      ? const ['Recibida', 'En revisión', 'Programada', 'Entregada']
      : const ['Recibida', 'En revisión', 'Programada', 'Instalada'];
}

class Solicitud {
  final String folio;
  final String contrato;
  final TipoSolicitud tipo;
  final String direccion;
  final String notas;
  final DateTime fecha;

  /// Número de pasos completados (0 a 4).
  int estado;

  Solicitud({
    required this.folio,
    required this.contrato,
    required this.tipo,
    required this.direccion,
    required this.notas,
    required this.fecha,
    this.estado = 1,
  });

  bool get completada => estado >= tipo.pasos.length;
}
