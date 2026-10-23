import 'package:flutter/material.dart';

import 'controllers/app_controlador.dart';
import 'controllers/app_scope.dart';
import 'theme/app_tema.dart';
import 'view/admin/admin_principal_view.dart';
import 'view/login_view.dart';
import 'view/principal_view.dart';

void main() {
  runApp(const AquaGeoApp());
}

class AquaGeoApp extends StatefulWidget {
  const AquaGeoApp({super.key});

  @override
  State<AquaGeoApp> createState() => _AquaGeoAppState();
}

class _AquaGeoAppState extends State<AquaGeoApp> {
  final AppControlador _controlador = AppControlador();

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controlador: _controlador,
      child: MaterialApp(
        title: 'AquaGeo',
        debugShowCheckedModeBanner: false,
        theme: AppTema.claro,
        home: const _Raiz(),
      ),
    );
  }
}

/// Muestra el login o la app según haya sesión abierta.
class _Raiz extends StatelessWidget {
  const _Raiz();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    if (app.esAdmin) return const AdminPrincipalView();
    return app.sesionActiva ? const PrincipalView() : const LoginView();
  }
}
