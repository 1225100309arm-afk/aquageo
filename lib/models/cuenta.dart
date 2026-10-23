import 'actividad.dart';
import 'metodo_pago.dart';
import 'notificacion.dart';
import 'pago.dart';
import 'reporte_fuga.dart';
import 'solicitud.dart';

class ConsumoMes {
  final String mes;
  final double monto;

  const ConsumoMes(this.mes, this.monto);
}

class Factura {
  final String periodo;
  final double monto;
  bool pagada;

  Factura({required this.periodo, required this.monto, this.pagada = false});
}

/// Todo lo que pertenece a un contrato: facturas, consumo, pagos, avisos, etc.
class Cuenta {
  final List<ConsumoMes> consumos;
  final List<Factura> facturas;
  final List<MetodoPago> metodos;
  final List<Notificacion> notificaciones;
  final List<Actividad> actividad;
  final List<Pago> pagos;
  final List<ReporteFuga> reportes;
  Solicitud? solicitudActiva;

  Cuenta({
    List<ConsumoMes>? consumos,
    List<Factura>? facturas,
    List<MetodoPago>? metodos,
    List<Notificacion>? notificaciones,
    List<Actividad>? actividad,
    this.solicitudActiva,
  })  : consumos = consumos ?? <ConsumoMes>[],
        facturas = facturas ?? <Factura>[],
        metodos = metodos ?? <MetodoPago>[],
        notificaciones = notificaciones ?? <Notificacion>[],
        actividad = actividad ?? <Actividad>[],
        pagos = <Pago>[],
        reportes = <ReporteFuga>[];

  double get saldo => facturas
      .where((f) => !f.pagada)
      .fold<double>(0, (suma, f) => suma + f.monto);

  bool get hayAdeudo => saldo > 0;

  int get noLeidas => notificaciones.where((n) => !n.leida).length;
}
