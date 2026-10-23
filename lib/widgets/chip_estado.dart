import 'package:flutter/material.dart';

/// Etiqueta pequeña con color (Pendiente, Atendido, Con adeudo...).
class ChipEstado extends StatelessWidget {
  final String texto;
  final Color color;
  final Color tinte;

  const ChipEstado({
    super.key,
    required this.texto,
    required this.color,
    required this.tinte,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: tinte,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}
