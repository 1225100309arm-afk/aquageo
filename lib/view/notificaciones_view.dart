import 'package:flutter/material.dart';

import '../controllers/app_scope.dart';
import '../theme/app_tema.dart';
import '../widgets/boton_icono.dart';
import '../widgets/notificacion_item.dart';

class NotificacionesView extends StatelessWidget {
  const NotificacionesView({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final lista = app.cuenta.notificaciones;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  BotonIcono(
                    icono: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(child: Text('Notificaciones', style: AppTema.titulo)),
                  if (app.cuenta.noLeidas > 0)
                    TextButton(
                      onPressed: app.marcarTodasLeidas,
                      child: const Text(
                        'Marcar leídas',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: lista.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_off_outlined,
                              size: 48, color: AppTema.iconoInactivo),
                          SizedBox(height: 10),
                          Text('Sin notificaciones', style: AppTema.suave),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      itemCount: lista.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => NotificacionItem(
                        notificacion: lista[i],
                        onTap: () => app.marcarLeida(lista[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
