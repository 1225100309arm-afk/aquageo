import 'package:flutter/material.dart';

import '../../controllers/app_scope.dart';
import '../../theme/app_tema.dart';
import '../../widgets/aviso.dart';
import '../../widgets/boton_primario.dart';
import '../../widgets/campo_texto_aquageo.dart';
import '../../widgets/encabezado_pantalla.dart';
import '../../widgets/filtro_chips.dart';

class AdminAvisosView extends StatefulWidget {
  const AdminAvisosView({super.key});

  @override
  State<AdminAvisosView> createState() => _AdminAvisosViewState();
}

class _AdminAvisosViewState extends State<AdminAvisosView> {
  final _clave = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  int _destino = 0; // 0 = todas las zonas, i>0 = zona i-1

  @override
  void dispose() {
    _titulo.dispose();
    super.dispose();
  }

  void _enviar() {
    FocusScope.of(context).unfocus();
    if (!(_clave.currentState?.validate() ?? false)) return;
    final app = AppScope.leer(context);
    final zonaId = _destino == 0 ? null : app.zonas[_destino - 1].id;
    final n = app.enviarAviso(titulo: _titulo.text, zonaId: zonaId);
    _titulo.clear();
    mostrarAviso(context, 'Aviso enviado a $n cliente(s).');
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final opciones = <String>[
      'Todas las zonas',
      for (final z in app.zonas) z.etiqueta,
    ];
    final destino = _destino.clamp(0, opciones.length - 1);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            EncabezadoPantalla(
              titulo: 'Enviar aviso',
              subtitulo: 'Les llegará en Notificaciones.',
              onAtras: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 22),
            const Text('Destino', style: AppTema.seccion),
            const SizedBox(height: 10),
            FiltroChips(
              opciones: opciones,
              seleccion: destino,
              onCambio: (i) => setState(() => _destino = i),
            ),
            const SizedBox(height: 22),
            Form(
              key: _clave,
              child: CampoTextoAquaGeo(
                controller: _titulo,
                etiqueta: 'Mensaje del aviso',
                icono: Icons.campaign_outlined,
                lineas: 3,
                ayuda: 'Ej.: Corte de agua el sábado de 9:00 a 14:00',
                validador: (v) => (v == null || v.trim().length < 5)
                    ? 'Escribe el mensaje (mínimo 5 letras)'
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            BotonPrimario(
              texto: 'Enviar aviso',
              icono: Icons.send_rounded,
              onPressed: _enviar,
            ),
          ],
        ),
      ),
    );
  }
}
