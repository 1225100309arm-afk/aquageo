import 'package:flutter/material.dart';

import '../controllers/app_scope.dart';
import '../theme/app_tema.dart';
import '../utils/formato.dart';
import '../widgets/boton_primario.dart';
import '../widgets/grafica_consumo.dart';
import '../widgets/tarjeta_aquageo.dart';
import 'comprobante_view.dart';
import 'pago_linea_view.dart';

class SaldoFacturacionView extends StatelessWidget {
  const SaldoFacturacionView({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cuenta = app.cuenta;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Saldo y facturación', style: AppTema.titulo),
          const SizedBox(height: 4),
          Text('Contrato ${app.usuario.contrato}', style: AppTema.suave),
          const SizedBox(height: 18),
          TarjetaAquaGeo(
            gradiente: cuenta.hayAdeudo
                ? AppTema.gradientePrincipal
                : AppTema.gradienteExito,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cuenta.hayAdeudo ? 'Total a pagar' : 'Sin adeudos',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  Formato.moneda(cuenta.saldo),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          BotonPrimario(
            texto: cuenta.hayAdeudo ? 'Pagar en línea' : 'Nada por pagar',
            icono: Icons.payments_rounded,
            onPressed: cuenta.hayAdeudo
                ? () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const PagoLineaView()),
                    )
                : null,
          ),
          const SizedBox(height: 24),
          const Text('Consumo mensual', style: AppTema.seccion),
          const SizedBox(height: 10),
          TarjetaAquaGeo(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
            child: GraficaConsumo(datos: cuenta.consumos),
          ),
          const SizedBox(height: 24),
          const Text('Facturas', style: AppTema.seccion),
          const SizedBox(height: 10),
          for (final f in cuenta.facturas)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TarjetaAquaGeo(
                sombra: false,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: f.pagada ? AppTema.exitoTinte : AppTema.alertaTinte,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        f.pagada ? Icons.check_rounded : Icons.schedule_rounded,
                        color: f.pagada ? AppTema.exito : AppTema.alerta,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.periodo,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            f.pagada ? 'Pagada' : 'Pendiente',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: f.pagada ? AppTema.exito : AppTema.alerta,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Formato.moneda(f.monto),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (cuenta.pagos.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text('Pagos realizados', style: AppTema.seccion),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long_rounded, color: AppTema.primario),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.folio,
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            Text(Formato.fechaHora(p.fecha), style: AppTema.suave),
                          ],
                        ),
                      ),
                      Text(
                        Formato.moneda(p.monto),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppTema.textoSuave),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
