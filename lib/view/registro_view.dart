import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/app_scope.dart';
import '../theme/app_tema.dart';
import '../widgets/aviso.dart';
import '../widgets/boton_icono.dart';
import '../widgets/boton_primario.dart';
import '../widgets/campo_texto_aquageo.dart';
import '../widgets/selector_zona.dart';

class RegistroView extends StatefulWidget {
  const RegistroView({super.key});

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  final _clave = GlobalKey<FormState>();
  final _numero = TextEditingController();
  final _familia = TextEditingController();
  final _password = TextEditingController();
  final _confirmar = TextEditingController();
  final _pin = TextEditingController();
  String? _zonaId;
  bool _zonaFalta = false;
  bool _cargando = false;

  @override
  void dispose() {
    _numero.dispose();
    _familia.dispose();
    _password.dispose();
    _confirmar.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    FocusScope.of(context).unfocus();
    final valido = _clave.currentState?.validate() ?? false;
    setState(() => _zonaFalta = _zonaId == null);
    if (!valido || _zonaId == null) return;

    final app = AppScope.leer(context);
    final navegador = Navigator.of(context);
    setState(() => _cargando = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final error = app.registrar(
      numero: _numero.text,
      familia: _familia.text,
      password: _password.text,
      pin: _pin.text,
      zonaId: _zonaId!,
    );
    if (error != null) {
      setState(() => _cargando = false);
      mostrarAviso(context, error, error: true);
      return;
    }
    // La sesión ya está abierta: se cierra el registro y se ve la pantalla principal.
    navegador.popUntil((ruta) => ruta.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Form(
            key: _clave,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BotonIcono(
                      icono: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(child: Text('Alta de contrato', style: AppTema.titulo)),
                  ],
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 60),
                  child: Text(
                    'Crea la cuenta de tu familia en AquaGeo.',
                    style: AppTema.suave,
                  ),
                ),
                const SizedBox(height: 22),
                CampoTextoAquaGeo(
                  controller: _numero,
                  etiqueta: 'Número de contrato (será tu usuario)',
                  icono: Icons.badge_outlined,
                  teclado: TextInputType.number,
                  accion: TextInputAction.next,
                  ayuda: 'Único, de 5 a 10 dígitos',
                  formateadores: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validador: (v) {
                    final t = (v ?? '').trim();
                    if (t.length < 5 || t.length > 10) {
                      return 'Debe tener de 5 a 10 dígitos';
                    }
                    if (app.existeUsuario(t)) {
                      return 'Ese número ya está registrado';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                CampoTextoAquaGeo(
                  controller: _familia,
                  etiqueta: 'Apellido de la familia',
                  icono: Icons.family_restroom_rounded,
                  accion: TextInputAction.next,
                  validador: (v) => (v == null || v.trim().length < 2)
                      ? 'Escribe el apellido'
                      : null,
                ),
                const SizedBox(height: 14),
                SelectorZona(
                  zonas: app.zonas,
                  zonaId: _zonaId,
                  error: _zonaFalta ? 'Selecciona tu zona para darte de alta' : null,
                  onSeleccion: (z) => setState(() {
                    _zonaId = z.id;
                    _zonaFalta = false;
                  }),
                ),
                const SizedBox(height: 14),
                CampoTextoAquaGeo(
                  controller: _password,
                  etiqueta: 'Contraseña',
                  icono: Icons.lock_outline_rounded,
                  esContrasena: true,
                  accion: TextInputAction.next,
                  validador: (v) => (v == null || v.length < 6)
                      ? 'Mínimo 6 caracteres'
                      : null,
                ),
                const SizedBox(height: 14),
                CampoTextoAquaGeo(
                  controller: _confirmar,
                  etiqueta: 'Confirmar contraseña',
                  icono: Icons.lock_reset_rounded,
                  esContrasena: true,
                  accion: TextInputAction.next,
                  validador: (v) =>
                      v != _password.text ? 'Las contraseñas no coinciden' : null,
                ),
                const SizedBox(height: 14),
                CampoTextoAquaGeo(
                  controller: _pin,
                  etiqueta: 'PIN para pagar (4 dígitos)',
                  icono: Icons.pin_outlined,
                  esContrasena: true,
                  teclado: TextInputType.number,
                  ayuda: 'Se te pedirá cada vez que pagues',
                  formateadores: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validador: (v) =>
                      (v == null || v.length != 4) ? 'Debe tener 4 dígitos' : null,
                  onEnviado: (_) => _registrar(),
                ),
                const SizedBox(height: 24),
                BotonPrimario(
                  texto: 'Crear cuenta',
                  icono: Icons.how_to_reg_rounded,
                  cargando: _cargando,
                  onPressed: _registrar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
