import 'package:flutter/material.dart';

import '../../controllers/app_scope.dart';
import '../../models/usuario.dart';
import '../../theme/app_tema.dart';
import '../../utils/formato.dart';
import '../../widgets/aviso.dart';
import '../../widgets/boton_icono.dart';
import '../../widgets/boton_primario.dart';
import '../../widgets/chip_estado.dart';
import '../../widgets/dialogo_pago_exitoso.dart';
import '../../widgets/fila_dato.dart';
import '../../widgets/tarjeta_aquageo.dart';
import '../comprobante_view.dart';

class AdminClienteDetalleView extends StatelessWidget {
  final Usuario cliente;

  const AdminClienteDetalleView({super.key, required this.cliente});

  Future<void> _cobrarEnCaja(BuildContext context) async {
    final app = AppScope.leer(context);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Registrar pago en caja'),
        content: Text(
          'Se registrará el pago de ${Formato.moneda(app.cuentaDe(cliente).saldo)} '
          'de ${cliente.saludoFamilia} como efectivo recibido en ventanilla.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(d).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(d).pop(true),
            child: const Text(
              'Registrar',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
    if (confirmar != true || !context.mounted) return;
    final pago = app.registrarPagoEnCaja(cliente);
    if (pago == null) {
      mostrarAviso(context, 'Este cliente no tiene adeudo.', error: true);
      return;
    }
    final ver = await mostrarDialogoPagoExitoso(context, pago);
    if (ver && context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => ComprobanteView(pago: pago)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cuenta = app.cuentaDe(cliente);
    final zona = app.zonaDe(cliente);

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
                  const Expanded(child: Text('Detalle del cliente', style: AppTema.titulo)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                children: [
                  TarjetaAquaGeo(
                    gradiente: AppTema.gradientePrincipal,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cliente.inicial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cliente.saludoFamilia,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Contrato ${cliente.contrato}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TarjetaAquaGeo(
                    child: Column(
                      children: [
                        FilaDato(etiqueta: 'Zona', valor: zona.etiqueta),
                        FilaDato(
                          etiqueta: 'Saldo pendiente',
                          valor: Formato.moneda(cuenta.saldo),
                          destacado: true,
                          colorValor:
                              cuenta.hayAdeudo ? AppTema.peligro : AppTema.exito,
                        ),
                        FilaDato(
                          etiqueta: 'Pagos registrados',
                          valor: '${cuenta.pagos.length}',
                        ),
                        FilaDato(
                          etiqueta: 'Reportes de fuga',
                          valor: '${cuenta.reportes.length}',
                        ),
                        FilaDato(
                          etiqueta: 'Solicitud activa',
                          valor: cuenta.solicitudActiva?.folio ?? 'Ninguna',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  BotonPrimario(
                    texto: cuenta.hayAdeudo ? 'Registrar pago en caja' : 'Sin adeudo',
                    icono: Icons.point_of_sale_rounded,
                    oscuro: true,
                    onPressed: cuenta.hayAdeudo ? () => _cobrarEnCaja(context) : null,
                  ),
                  const SizedBox(height: 24),
                  const Text('Facturas', style: AppTema.seccion),
                  const SizedBox(height: 10),
                  for (final f in cuenta.facturas)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TarjetaAquaGeo(
                        sombra: false,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                f.periodo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ChipEstado(
                              texto: f.pagada ? 'Pagada' : 'Pendiente',
                              color: f.pagada ? AppTema.exito : AppTema.alerta,
                              tinte: f.pagada
                                  ? AppTema.exitoTinte
                                  : AppTema.alertaTinte,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              Formato.moneda(f.monto),
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (cuenta.pagos.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Text('Pagos', style: AppTema.seccion),
                    const SizedBox(height: 10),
                    for (final p in cuenta.pagos)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TarjetaAquaGeo(
                          sombra: false,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => ComprobanteView(pago: p),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.receipt_long_rounded,
                                  color: AppTema.primario),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.folio,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      '${Formato.fecha(p.fecha)} · ${p.metodo.descripcion}',
                                      style: AppTema.suave,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                Formato.moneda(p.monto),
                                style: const TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
