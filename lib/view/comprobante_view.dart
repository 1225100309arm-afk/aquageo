import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/app_scope.dart';
import '../models/pago.dart';
import '../theme/app_tema.dart';
import '../utils/formato.dart';
import '../widgets/aviso.dart';
import '../widgets/boton_icono.dart';
import '../widgets/boton_primario.dart';
import '../widgets/boton_secundario.dart';
import '../widgets/fila_dato.dart';
import '../widgets/tarjeta_aquageo.dart';

class ComprobanteView extends StatelessWidget {
  final Pago pago;

  const ComprobanteView({super.key, required this.pago});

  String get _texto => 'AquaGeo · Comprobante de pago\n'
      'Folio: ${pago.folio}\n'
      'Contrato: ${pago.contrato}\n'
      'Fecha: ${Formato.fechaHora(pago.fecha)}\n'
      'Método: ${pago.metodo.descripcion}\n'
      'Monto: ${Formato.moneda(pago.monto)}\n'
      'Estado: ${pago.estado}';

  Future<void> _compartir(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _texto));
    if (!context.mounted) return;
    mostrarAviso(context, 'Comprobante copiado al portapapeles.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  BotonIcono(
                    icono: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(child: Text('Comprobante', style: AppTema.titulo)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                children: [
                  TarjetaAquaGeo(
                    padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            gradient: AppTema.gradienteExito,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Pago registrado',
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formato.moneda(pago.monto),
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: AppTema.primario,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
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
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Divider(color: AppTema.borde, height: 1),
                        ),
                        FilaDato(etiqueta: 'Folio', valor: pago.folio),
                        FilaDato(etiqueta: 'Contrato', valor: pago.contrato),
                        FilaDato(etiqueta: 'Fecha', valor: Formato.fechaHora(pago.fecha)),
                        FilaDato(
                          etiqueta: 'Método',
                          valor: pago.metodo.descripcion,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  BotonSecundario(
                    texto: 'Compartir comprobante',
                    icono: Icons.ios_share_rounded,
                    onPressed: () => _compartir(context),
                  ),
                  const SizedBox(height: 10),
                  BotonSecundario(
                    texto: 'Descargar PDF',
                    icono: Icons.picture_as_pdf_outlined,
                    onPressed: () => mostrarAviso(
                      context,
                      'La descarga en PDF llegará en la siguiente versión.',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
              child: BotonPrimario(
                texto: 'Volver al inicio',
                icono: Icons.home_rounded,
                onPressed: () {
                  AppScope.leer(context).irAPestana(0);
                  Navigator.of(context).popUntil((ruta) => ruta.isFirst);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
