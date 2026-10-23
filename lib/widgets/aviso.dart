import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

/// Mensaje corto en la parte baja de la pantalla.
void mostrarAviso(BuildContext context, String mensaje, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? AppTema.peligro : AppTema.texto,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
}
