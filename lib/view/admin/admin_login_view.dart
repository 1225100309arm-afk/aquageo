import 'package:flutter/material.dart';

import '../../controllers/app_scope.dart';
import '../../theme/app_tema.dart';
import '../../widgets/aviso.dart';
import '../../widgets/boton_icono.dart';
import '../../widgets/boton_primario.dart';
import '../../widgets/campo_texto_aquageo.dart';
import '../../widgets/fondo_ondas.dart';
import '../../widgets/logo_aquageo.dart';

class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView> {
  final _clave = GlobalKey<FormState>();
  final _usuario = TextEditingController();
  final _password = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _usuario.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    FocusScope.of(context).unfocus();
    if (!(_clave.currentState?.validate() ?? false)) return;
    final app = AppScope.leer(context);
    final navegador = Navigator.of(context);
    setState(() => _cargando = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final error = app.iniciarSesionAdmin(_usuario.text, _password.text);
    if (error != null) {
      setState(() => _cargando = false);
      mostrarAviso(context, error, error: true);
      return;
    }
    // La sesión de administrador ya está abierta: se cierra esta pantalla.
    navegador.popUntil((ruta) => ruta.isFirst);
  }

  void _usarDemo() {
    _usuario.text = 'admin';
    _password.text = 'admin2026';
    mostrarAviso(context, 'Datos del administrador demo cargados.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FondoOndas(
              alto: 280,
              gradiente: AppTema.gradienteOscuro,
              child: SafeArea(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: BotonIcono(
                          icono: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LogoAquaGeo(tamano: 64),
                            SizedBox(height: 8),
                            Text(
                              'Panel de administración',
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Form(
                key: _clave,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Acceso administrador', style: AppTema.titulo),
                    const SizedBox(height: 4),
                    const Text(
                      'Solo personal autorizado del organismo operador.',
                      style: AppTema.suave,
                    ),
                    const SizedBox(height: 22),
                    CampoTextoAquaGeo(
                      controller: _usuario,
                      etiqueta: 'Usuario',
                      icono: Icons.admin_panel_settings_outlined,
                      accion: TextInputAction.next,
                      validador: (v) => (v == null || v.trim().isEmpty)
                          ? 'Escribe tu usuario'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    CampoTextoAquaGeo(
                      controller: _password,
                      etiqueta: 'Contraseña',
                      icono: Icons.lock_outline_rounded,
                      esContrasena: true,
                      accion: TextInputAction.done,
                      onEnviado: (_) => _entrar(),
                      validador: (v) =>
                          (v == null || v.isEmpty) ? 'Escribe tu contraseña' : null,
                    ),
                    const SizedBox(height: 22),
                    BotonPrimario(
                      texto: 'Entrar al panel',
                      icono: Icons.login_rounded,
                      oscuro: true,
                      cargando: _cargando,
                      onPressed: _entrar,
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTema.primarioTinte,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, color: AppTema.primario),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Demo: usuario admin · contraseña admin2026',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppTema.primarioOscuro,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _usarDemo,
                            child: const Text(
                              'Usar',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
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
