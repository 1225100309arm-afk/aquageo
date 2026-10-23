import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/app_scope.dart';
import '../theme/app_tema.dart';
import '../widgets/aviso.dart';
import '../widgets/boton_primario.dart';
import '../widgets/campo_texto_aquageo.dart';
import '../widgets/fondo_ondas.dart';
import '../widgets/logo_aquageo.dart';
import 'admin/admin_login_view.dart';
import 'registro_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _clave = GlobalKey<FormState>();
  final _numero = TextEditingController();
  final _password = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _numero.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    FocusScope.of(context).unfocus();
    if (!(_clave.currentState?.validate() ?? false)) return;
    final app = AppScope.leer(context);
    setState(() => _cargando = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final error = app.iniciarSesion(_numero.text, _password.text);
    if (error != null) {
      setState(() => _cargando = false);
      mostrarAviso(context, error, error: true);
    }
    // Si fue correcto, el controlador cambia la raíz a la pantalla principal.
  }

  void _usarDemo() {
    _numero.text = '10432';
    _password.text = 'agua123';
    mostrarAviso(context, 'Datos de la cuenta demo cargados.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const FondoOndas(
              alto: 270,
              child: Center(child: Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: LogoAquaGeo(tamano: 74),
              )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Form(
                key: _clave,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bienvenido', style: AppTema.titulo),
                    const SizedBox(height: 4),
                    const Text(
                      'Entra con el número de contrato de tu familia.',
                      style: AppTema.suave,
                    ),
                    const SizedBox(height: 22),
                    CampoTextoAquaGeo(
                      controller: _numero,
                      etiqueta: 'Número de contrato',
                      icono: Icons.badge_outlined,
                      teclado: TextInputType.number,
                      accion: TextInputAction.next,
                      ayuda: 'De 5 a 10 dígitos',
                      formateadores: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validador: (v) {
                        final t = (v ?? '').trim();
                        if (t.isEmpty) return 'Escribe tu número de contrato';
                        if (t.length < 5) return 'Debe tener al menos 5 dígitos';
                        return null;
                      },
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
                      texto: 'Iniciar sesión',
                      icono: Icons.login_rounded,
                      cargando: _cargando,
                      onPressed: _entrar,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿Primera vez?', style: AppTema.suave),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const RegistroView(),
                            ),
                          ),
                          child: const Text(
                            'Crear cuenta nueva',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
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
                              'Demo: contrato 10432 · contraseña agua123 · PIN 1234',
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
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const AdminLoginView(),
                          ),
                        ),
                        icon: const Icon(Icons.admin_panel_settings_outlined, size: 19),
                        label: const Text(
                          'Acceso administrador',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
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
