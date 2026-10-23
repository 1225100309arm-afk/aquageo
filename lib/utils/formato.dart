/// Utilidades de formato (sin paquetes externos).
class Formato {
  Formato._();

  static const List<String> _meses = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
  ];

  /// 486.0 -> $486.00 | 1234.5 -> $1,234.50
  static String moneda(double valor) {
    final partes = valor.toStringAsFixed(2).split('.');
    final entero = partes[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return '\$$entero.${partes[1]}';
  }

  static String fecha(DateTime f) => '${f.day} ${_meses[f.month - 1]} ${f.year}';

  static String hora(DateTime f) {
    final h = f.hour.toString().padLeft(2, '0');
    final m = f.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String fechaHora(DateTime f) => '${fecha(f)} · ${hora(f)}';
}
