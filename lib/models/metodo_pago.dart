class MetodoPago {
  final String marca;
  final String ultimos4;

  const MetodoPago({required this.marca, required this.ultimos4});

  /// Pago recibido en ventanilla (lo registra el administrador).
  static const MetodoPago efectivo =
      MetodoPago(marca: 'Efectivo en caja', ultimos4: '');

  bool get esEfectivo => ultimos4.isEmpty;

  String get etiqueta => esEfectivo ? marca : '•••• $ultimos4';

  /// "Visa •••• 4581" o "Efectivo en caja".
  String get descripcion => esEfectivo ? marca : '$marca •••• $ultimos4';
}
