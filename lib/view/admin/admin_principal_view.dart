import 'package:flutter/material.dart';

import '../../controllers/app_scope.dart';
import '../../widgets/barra_navegacion_aquageo.dart';
import 'admin_clientes_view.dart';
import 'admin_mas_view.dart';
import 'admin_panel_view.dart';
import 'admin_reportes_view.dart';
import 'admin_solicitudes_view.dart';

/// Contenedor del administrador, con su propia barra inferior.
class AdminPrincipalView extends StatelessWidget {
  const AdminPrincipalView({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return PopScope(
      canPop: app.pestana == 0,
      onPopInvokedWithResult: (salio, _) {
        if (!salio) app.irAPestana(0);
      },
      child: Scaffold(
        body: IndexedStack(
          index: app.pestana,
          children: const [
            AdminPanelView(),
            AdminClientesView(),
            AdminSolicitudesView(),
            AdminReportesView(),
            AdminMasView(),
          ],
        ),
        bottomNavigationBar: BarraNavegacionAquaGeo(
          indice: app.pestana,
          onCambio: app.irAPestana,
          items: BarraNavegacionAquaGeo.itemsAdmin,
        ),
      ),
    );
  }
}
