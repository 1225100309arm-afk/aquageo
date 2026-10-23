import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

/// Fila de filtros (una sola opción activa).
class FiltroChips extends StatelessWidget {
  final List<String> opciones;
  final int seleccion;
  final ValueChanged<int> onCambio;

  const FiltroChips({
    super.key,
    required this.opciones,
    required this.seleccion,
    required this.onCambio,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (var i = 0; i < opciones.length; i++)
          ChoiceChip(
            label: Text(opciones[i]),
            selected: i == seleccion,
            onSelected: (_) => onCambio(i),
            selectedColor: AppTema.primarioTinte,
            backgroundColor: AppTema.tarjeta,
            side: BorderSide(
              color: i == seleccion ? AppTema.primarioClaro : AppTema.borde,
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: i == seleccion ? AppTema.primario : AppTema.textoSuave,
            ),
          ),
      ],
    );
  }
}
