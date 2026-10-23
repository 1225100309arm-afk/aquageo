class ReporteFuga {
  final String folio;
  final String contrato;
  final String descripcion;
  final double latitud;
  final double longitud;
  final bool conFoto;
  final DateTime fecha;

  /// Lo marca el administrador cuando la cuadrilla ya revisó la fuga.
  bool atendido;

  ReporteFuga({
    required this.folio,
    required this.contrato,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
    required this.conFoto,
    required this.fecha,
    this.atendido = false,
  });
}
