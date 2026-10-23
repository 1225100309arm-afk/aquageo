import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

/// Línea de tiempo vertical con pasos completados / actual / pendientes.
/// [completados] = número de pasos terminados.
class LineaSeguimiento extends StatelessWidget {
  final List<String> pasos;
  final int completados;

  const LineaSeguimiento({
    super.key,
    required this.pasos,
    required this.completados,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < pasos.length; i++)
          _Paso(
            texto: pasos[i],
            hecho: i < completados,
            actual: i == completados,
            ultimo: i == pasos.length - 1,
          ),
      ],
    );
  }
}

class _Paso extends StatelessWidget {
  final String texto;
  final bool hecho;
  final bool actual;
  final bool ultimo;

  const _Paso({
    required this.texto,
    required this.hecho,
    required this.actual,
    required this.ultimo,
  });

  @override
  Widget build(BuildContext context) {
    final color = hecho ? AppTema.exito : (actual ? AppTema.primario : AppTema.borde);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: hecho ? AppTema.exito : AppTema.tarjeta,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2.4),
                  ),
                  child: hecho
                      ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                      : (actual
                          ? Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTema.primario,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null),
                ),
                if (!ultimo)
                  Expanded(
                    child: Container(
                      width: 3,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: hecho ? AppTema.exito : AppTema.borde,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 3, bottom: ultimo ? 0 : 20),
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: (hecho || actual) ? FontWeight.w800 : FontWeight.w500,
                  color: (hecho || actual) ? AppTema.texto : AppTema.textoSuave,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
