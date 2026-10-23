import 'package:flutter/material.dart';

import '../models/pago.dart';
import '../theme/app_tema.dart';
import '../utils/formato.dart';
import 'boton_primario.dart';
import 'boton_secundario.dart';

/// Ventana de "pago exitoso". Devuelve `true` si el usuario quiere ver el comprobante.
Future<bool> mostrarDialogoPagoExitoso(BuildContext context, Pago pago) async {
  final r = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _DialogoPago(pago: pago),
  );
  return r ?? false;
}

class _DialogoPago extends StatelessWidget {
  final Pago pago;

  const _DialogoPago({required this.pago});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTema.tarjeta,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 650),
              curve: Curves.elasticOut,
              builder: (context, v, hijo) => Transform.scale(scale: v, child: hijo),
              child: Container(
                width: 86,
                height: 86,
                decoration: const BoxDecoration(
                  gradient: AppTema.gradienteExito,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x6616A34A),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 52),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Pago exitoso!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTema.texto,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              Formato.moneda(pago.monto),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppTema.primario,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppTema.exitoTinte,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                pago.estado,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppTema.exito,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text('Folio ${pago.folio}', style: AppTema.suave),
            const SizedBox(height: 22),
            BotonPrimario(
              texto: 'Ver comprobante',
              icono: Icons.receipt_long_rounded,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: 10),
            BotonSecundario(
              texto: 'Cerrar',
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
  }
}
