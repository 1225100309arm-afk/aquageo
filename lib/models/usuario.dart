class Usuario {
  /// Número único de contrato (5 a 10 dígitos). Es el usuario para iniciar sesión.
  final String numero;
  final String familia;
  final String password;
  final String pin;
  final String zonaId;

  const Usuario({
    required this.numero,
    required this.familia,
    required this.password,
    required this.pin,
    required this.zonaId,
  });

  Usuario copyWith({String? password, String? pin, String? zonaId}) {
    return Usuario(
      numero: numero,
      familia: familia,
      password: password ?? this.password,
      pin: pin ?? this.pin,
      zonaId: zonaId ?? this.zonaId,
    );
  }

  String get contrato => 'AG-$numero';

  /// "Familia Sánchez" o "Sánchez" -> "Sánchez"
  String get apellido {
    final f = familia.trim();
    return f.toLowerCase().startsWith('familia ') ? f.substring(8).trim() : f;
  }

  String get saludoFamilia => 'Familia $apellido';

  String get inicial => apellido.isEmpty ? 'A' : apellido[0].toUpperCase();
}
