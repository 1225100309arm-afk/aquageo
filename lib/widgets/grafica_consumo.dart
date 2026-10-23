import 'package:flutter/material.dart';

import '../models/cuenta.dart';
import '../theme/app_tema.dart';
import '../utils/formato.dart';

/// Gráfica de barras simple (sin paquetes). La última barra va resaltada.
class GraficaConsumo extends StatelessWidget {
  final List<ConsumoMes> datos;

  const GraficaConsumo({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    if (datos.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text('Aún no hay consumo registrado.', style: AppTema.suave),
        ),
      );
    }
    var maximo = datos.fold<double>(0, (a, d) => d.monto > a ? d.monto : a);
    if (maximo <= 0) maximo = 1;

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < datos.length; i++)
            Expanded(
              child: _Barra(
                dato: datos[i],
                proporcion: datos[i].monto / maximo,
                resaltada: i == datos.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _Barra extends StatelessWidget {
  final ConsumoMes dato;
  final double proporcion;
  final bool resaltada;

  const _Barra({
    required this.dato,
    required this.proporcion,
    required this.resaltada,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          Formato.moneda(dato.monto).replaceAll('.00', ''),
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: resaltada ? FontWeight.w800 : FontWeight.w600,
            color: resaltada ? AppTema.primario : AppTema.textoSuave,
          ),
        ),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: proporcion),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, valor, _) {
            return Container(
              height: 90 * valor,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: resaltada ? null : AppTema.primarioTinte,
                gradient: resaltada
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppTema.primarioClaro, AppTema.primarioOscuro],
                      )
                    : null,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Text(
          dato.mes,
          style: TextStyle(
            fontSize: 11,
            fontWeight: resaltada ? FontWeight.w800 : FontWeight.w500,
            color: resaltada ? AppTema.texto : AppTema.textoSuave,
          ),
        ),
      ],
    );
  }
}
