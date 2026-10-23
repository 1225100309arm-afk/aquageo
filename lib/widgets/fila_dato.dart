import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

/// Renglón "etiqueta ........ valor" para comprobantes y resúmenes.
class FilaDato extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final bool destacado;
  final Color? colorValor;

  const FilaDato({
    super.key,
    required this.etiqueta,
    required this.valor,
    this.destacado = false,
    this.colorValor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etiqueta, style: AppTema.suave),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: destacado ? 17 : 14,
                fontWeight: destacado ? FontWeight.w900 : FontWeight.w700,
                color: colorValor ?? AppTema.texto,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
