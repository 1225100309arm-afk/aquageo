import 'metodo_pago.dart';

class Pago {
  final String folio;
  final DateTime fecha;
  final double monto;
  final MetodoPago metodo;
  final String contrato;

  const Pago({
    required this.folio,
    required this.fecha,
    required this.monto,
    required this.metodo,
    required this.contrato,
  });

  /// Por ahora no hay pasarela real: el pago se registra en el dispositivo.
  String get estado => 'Pago realizado en local';
}
