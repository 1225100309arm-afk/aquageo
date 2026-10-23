import 'zona.dart';

class ResumenZona {
  final Zona zona;
  final int clientes;
  final double porCobrar;
  final double recaudado;

  const ResumenZona({
    required this.zona,
    required this.clientes,
    required this.porCobrar,
    required this.recaudado,
  });

  /// Proporción cobrada (0 a 1) respecto a lo facturado en la zona.
  double get avance {
    final total = porCobrar + recaudado;
    return total <= 0 ? 0 : recaudado / total;
  }
}

class ResumenAdmin {
  final int clientes;
  final int clientesConAdeudo;
  final double porCobrar;
  final double recaudado;
  final int pagos;
  final int reportesPendientes;
  final int solicitudesEnProceso;
  final List<ResumenZona> porZona;

  const ResumenAdmin({
    required this.clientes,
    required this.clientesConAdeudo,
    required this.porCobrar,
    required this.recaudado,
    required this.pagos,
    required this.reportesPendientes,
    required this.solicitudesEnProceso,
    required this.porZona,
  });
}
