import 'package:flutter/material.dart';

import '../controllers/app_scope.dart';
import '../widgets/barra_navegacion_aquageo.dart';
import 'configuracion_view.dart';
import 'inicio_view.dart';
import 'reportar_fuga_view.dart';
import 'saldo_facturacion_view.dart';
import 'solicitudes_view.dart';

/// Contenedor con la barra inferior. Cada pestaña conserva su estado.
class PrincipalView extends StatelessWidget {
  const PrincipalView({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return PopScope(
      // Desde otra pestaña, "atrás" regresa a Inicio en lugar de salir.
      canPop: app.pestana == 0,
      onPopInvokedWithResult: (salio, _) {
        if (!salio) app.irAPestana(0);
      },
      child: Scaffold(
        body: IndexedStack(
          index: app.pestana,
          children: const [
            InicioView(),
            SaldoFacturacionView(),
            SolicitudesView(),
            ReportarFugaView(),
            ConfiguracionView(),
          ],
        ),
        bottomNavigationBar: BarraNavegacionAquaGeo(
          indice: app.pestana,
          onCambio: app.irAPestana,
        ),
      ),
    );
  }
}
