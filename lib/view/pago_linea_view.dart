import 'package:flutter/material.dart';

import '../controllers/app_scope.dart';
import '../models/metodo_pago.dart';
import '../theme/app_tema.dart';
import '../utils/formato.dart';
import '../widgets/boton_icono.dart';
import '../widgets/boton_primario.dart';
import '../widgets/boton_secundario.dart';
import '../widgets/dialogo_pago_exitoso.dart';
import '../widgets/dialogo_pin.dart';
import '../widgets/fila_dato.dart';
import '../widgets/hoja_agregar_tarjeta.dart';
import '../widgets/tarjeta_aquageo.dart';
import 'comprobante_view.dart';

class PagoLineaView extends StatefulWidget {
  const PagoLineaView({super.key});

  @override
  State<PagoLineaView> createState() => _PagoLineaViewState();
}

class _PagoLineaViewState extends State<PagoLineaView> {
  int _seleccion = 0;
  bool _procesando = false;

  Future<void> _pagar() async {
    final app = AppScope.leer(context);
    final cuenta = app.cuenta;
    if (!cuenta.hayAdeudo || cuenta.metodos.isEmpty) return;
    final metodo = cuenta.metodos[_seleccion.clamp(0, cuenta.metodos.length - 1)];

    // 1) PIN obligatorio
    final autorizado = await mostrarDialogoPin(
      context,
      validar: app.validarPin,
      titulo: 'Confirma tu pago',
      subtitulo: 'Ingresa tu PIN para pagar ${Formato.moneda(cuenta.saldo)}.',
    );
    if (!autorizado || !mounted) return;

    // 2) Se registra el pago (sin API: queda como pago realizado en local)
    setState(() => _procesando = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final pago = app.pagar(metodo);
    setState(() => _procesando = false);

    // 3) Ventana de pago exitoso
    final verComprobante = await mostrarDialogoPagoExitoso(context, pago);
    if (!mounted) return;
    final navegador = Navigator.of(context);
    if (verComprobante) {
      navegador.pushReplacement(
        MaterialPageRoute<void>(builder: (_) => ComprobanteView(pago: pago)),
      );
    } else {
      navegador.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cuenta = app.cuenta;
    final metodos = cuenta.metodos;
    final seleccion = metodos.isEmpty ? 0 : _seleccion.clamp(0, metodos.length - 1);

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
                  const Expanded(child: Text('Pago en línea', style: AppTema.titulo)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                children: [
                  TarjetaAquaGeo(
                    child: Column(
                      children: [
                        FilaDato(etiqueta: 'Contrato', valor: app.usuario.contrato),
                        FilaDato(etiqueta: 'Titular', valor: app.usuario.saludoFamilia),
                        const Divider(height: 22, color: AppTema.borde),
                        FilaDato(
                          etiqueta: 'Total a pagar',
                          valor: Formato.moneda(cuenta.saldo),
                          destacado: true,
                          colorValor: AppTema.primario,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text('Método de pago', style: AppTema.seccion),
                  const SizedBox(height: 10),
                  if (metodos.isEmpty)
                    const TarjetaAquaGeo(
                      sombra: false,
                      child: Text(
                        'Agrega un método de pago para continuar.',
                        style: AppTema.suave,
                      ),
                    ),
                  for (var i = 0; i < metodos.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _OpcionMetodo(
                        metodo: metodos[i],
                        activo: i == seleccion,
                        onTap: () => setState(() => _seleccion = i),
                      ),
                    ),
                  BotonSecundario(
                    texto: 'Agregar método de pago',
                    icono: Icons.add_card_rounded,
                    onPressed: () => mostrarHojaAgregarTarjeta(
                      context,
                      onGuardar: (marca, ultimos4) {
                        app.agregarMetodo(marca: marca, ultimos4: ultimos4);
                        setState(() => _seleccion = app.cuenta.metodos.length - 1);
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTema.alertaTinte,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, color: AppTema.alerta),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Por ahora no hay conexión con bancos: el pago queda '
                            'registrado como "Pago realizado en local".',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7A4B00),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
              child: BotonPrimario(
                texto: 'Pagar ${Formato.moneda(cuenta.saldo)}',
                icono: Icons.lock_rounded,
                cargando: _procesando,
                onPressed: (cuenta.hayAdeudo && metodos.isNotEmpty) ? _pagar : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcionMetodo extends StatelessWidget {
  final MetodoPago metodo;
  final bool activo;
  final VoidCallback onTap;

  const _OpcionMetodo({
    required this.metodo,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TarjetaAquaGeo(
      onTap: onTap,
      sombra: false,
      colorBorde: activo ? AppTema.primario : null,
      anchoBorde: activo ? 2 : 1,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppTema.gradienteOscuro,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.credit_card_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metodo.marca,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                Text(metodo.etiqueta, style: AppTema.suave),
              ],
            ),
          ),
          Icon(
            activo ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
            color: activo ? AppTema.primario : AppTema.iconoInactivo,
          ),
        ],
      ),
    );
  }
}
