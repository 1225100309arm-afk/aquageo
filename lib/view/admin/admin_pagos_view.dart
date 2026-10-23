import 'package:flutter/material.dart';

import '../../controllers/app_scope.dart';
import '../../theme/app_tema.dart';
import '../../utils/formato.dart';
import '../../widgets/chip_estado.dart';
import '../../widgets/encabezado_pantalla.dart';
import '../../widgets/tarjeta_aquageo.dart';
import '../comprobante_view.dart';

class AdminPagosView extends StatelessWidget {
  const AdminPagosView({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final pagos = app.todosLosPagos;
    final total = app.resumen.recaudado;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            EncabezadoPantalla(
              titulo: 'Pagos',
              subtitulo: '${pagos.length} movimientos',
              onAtras: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 18),
            TarjetaAquaGeo(
              gradiente: AppTema.gradienteOscuro,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total recaudado',
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    Formato.moneda(total),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (pagos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('Aún no hay pagos.', style: AppTema.suave)),
              )
            else
              for (final p in pagos)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TarjetaAquaGeo(
                    sombra: false,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ComprobanteView(pago: p),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long_rounded, color: AppTema.primario),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                app.clientePorContrato(p.contrato)?.saludoFamilia ??
                                    p.contrato,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                              Text(
                                '${p.folio} · ${Formato.fecha(p.fecha)}',
                                style: AppTema.suave,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Formato.moneda(p.monto),
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 3),
                            ChipEstado(
                              texto: p.metodo.esEfectivo ? 'En caja' : p.metodo.marca,
                              color: p.metodo.esEfectivo
                                  ? AppTema.violeta
                                  : AppTema.primario,
                              tinte: p.metodo.esEfectivo
                                  ? AppTema.violetaTinte
                                  : AppTema.primarioTinte,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
