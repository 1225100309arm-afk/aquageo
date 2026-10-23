import 'package:flutter/material.dart';

class AppTema {
  AppTema._();

  // ---- Paleta (agua / aqua)
  static const Color primario = Color(0xFF0E7490);
  static const Color primarioClaro = Color(0xFF22B1CF);
  static const Color primarioOscuro = Color(0xFF0A4A63);
  static const Color fondo = Color(0xFFF1F7FA);
  static const Color tarjeta = Colors.white;
  static const Color borde = Color(0xFFDCE9EF);
  static const Color texto = Color(0xFF0F2A37);
  static const Color textoSuave = Color(0xFF64808E);
  static const Color iconoInactivo = Color(0xFF9DB1BC);

  static const Color exito = Color(0xFF16A34A);
  static const Color alerta = Color(0xFFF59E0B);
  static const Color peligro = Color(0xFFE11D48);
  static const Color azul = Color(0xFF2563EB);
  static const Color violeta = Color(0xFF7C3AED);

  // ---- Tintes suaves para fondos de iconos
  static const Color primarioTinte = Color(0xFFDDF1F6);
  static const Color exitoTinte = Color(0xFFDDF5E8);
  static const Color alertaTinte = Color(0xFFFEF1D2);
  static const Color peligroTinte = Color(0xFFFDE2E8);
  static const Color azulTinte = Color(0xFFE2EBFE);
  static const Color violetaTinte = Color(0xFFEDE5FD);
  static const Color gris = Color(0xFFEAF1F4);

  // ---- Degradados y sombras
  static const LinearGradient gradientePrincipal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primarioClaro, primario, primarioOscuro],
  );

  static const LinearGradient gradienteOscuro = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF24485B), Color(0xFF0F2A37)],
  );

  static const LinearGradient gradienteExito = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34D399), Color(0xFF16A34A)],
  );

  static const List<BoxShadow> sombraSuave = [
    BoxShadow(color: Color(0x140B3B4F), blurRadius: 20, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> sombraBoton = [
    BoxShadow(color: Color(0x590E7490), blurRadius: 16, offset: Offset(0, 8)),
  ];

  // ---- Estilos de texto
  static const TextStyle titulo = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w800,
    color: texto,
    letterSpacing: -0.3,
  );

  static const TextStyle seccion = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: texto,
  );

  static const TextStyle cuerpo = TextStyle(fontSize: 14, color: texto);

  static const TextStyle suave = TextStyle(fontSize: 12.5, color: textoSuave);

  static ThemeData get claro {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primario).copyWith(
        primary: primario,
      ),
      scaffoldBackgroundColor: fondo,
      splashFactory: InkRipple.splashFactory,
    );
  }
}
