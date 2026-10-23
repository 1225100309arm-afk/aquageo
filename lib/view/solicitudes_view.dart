import 'package:flutter/material.dart';

import '../controllers/app_scope.dart';
import '../models/solicitud.dart';
import '../theme/app_tema.dart';
import '../utils/formato.dart';
import '../widgets/aviso.dart';
import '../widgets/boton_primario.dart';
import '../widgets/boton_secundario.dart';
import '../widgets/campo_texto_aquageo.dart';
import '../widgets/linea_seguimiento.dart';
import '../widgets/tarjeta_aquageo.dart';

class SolicitudesView extends StatefulWidget {
  const SolicitudesView({super.key});

  @override
  State<SolicitudesView> createState() => _SolicitudesViewState();
}

class _SolicitudesViewState extends State<SolicitudesView> {
  final _clave = GlobalKey<FormState>();
  final _direccion = TextEditingController();
  final _notas = TextEditingController();
  TipoSolicitud _tipo = TipoSolicitud.pipa;

  @override
  void dispose() {
    _direccion.dispose();
    _notas.dispose();
    super.dispose();
  }

  void _enviar() {
    FocusScope.of(context).unfocus();
    if (!(_clave.currentState?.validate() ?? false)) return;
    final s = AppScope.leer(context).enviarSolicitud(
      tipo: _tipo,
      direccion: _direccion.text,
      notas: _notas.text,
    );
    _direccion.clear();
    _notas.clear();
    mostrarAviso(context, 'Solicitud ${s.folio} enviada.');
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final activa = app.cuenta.solicitudActiva;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Solicitudes', style: AppTema.titulo),
          const SizedBox(height: 4),
          const Text('Pide una pipa o una nueva toma de agua.', style: AppTema.suave),
          const SizedBox(height: 18),
          if (activa != null) ...[
            const Text('Seguimiento', style: AppTema.seccion),
            const SizedBox(height: 10),
            TarjetaSeguimiento(solicitud: activa),
            const SizedBox(height: 24),
          ],
          const Text('Nueva solicitud', style: AppTema.seccion),
          const SizedBox(height: 10),
          Form(
            key: _clave,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SegmentedButton<TipoSolicitud>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: TipoSolicitud.pipa,
                      icon: Icon(Icons.local_shipping_outlined),
                      label: Text('Pipa'),
                    ),
                    ButtonSegment(
                      value: TipoSolicitud.toma,
                      icon: Icon(Icons.plumbing_rounded),
                      label: Text('Nueva toma'),
                    ),
                  ],
                  selected: {_tipo},
                  onSelectionChanged: (v) => setState(() => _tipo = v.first),
                ),
                const SizedBox(height: 14),
                CampoTextoAquaGeo(
                  controller: _direccion,
                  etiqueta: 'Dirección',
                  icono: Icons.home_work_outlined,
                  accion: TextInputAction.next,
                  ayuda: 'Zona: ${app.zona.etiqueta}',
                  validador: (v) => (v == null || v.trim().length < 5)
                      ? 'Escribe calle y número'
                      : null,
                ),
                const SizedBox(height: 14),
                CampoTextoAquaGeo(
                  controller: _notas,
                  etiqueta: 'Notas (opcional)',
                  icono: Icons.notes_rounded,
                  lineas: 3,
                ),
                const SizedBox(height: 18),
                BotonPrimario(
                  texto: 'Enviar solicitud',
                  icono: Icons.send_rounded,
                  onPressed: _enviar,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta con la línea de tiempo de la solicitud activa.
class TarjetaSeguimiento extends StatelessWidget {
  final Solicitud solicitud;

  const TarjetaSeguimiento({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.leer(context);
    return TarjetaAquaGeo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      solicitud.tipo.etiqueta,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${solicitud.folio} · ${Formato.fecha(solicitud.fecha)}',
                      style: AppTema.suave,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: solicitud.completada
                      ? AppTema.exitoTinte
                      : AppTema.primarioTinte,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  solicitud.completada ? 'Completada' : 'En proceso',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: solicitud.completada ? AppTema.exito : AppTema.primario,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LineaSeguimiento(
            pasos: solicitud.tipo.pasos,
            completados: solicitud.estado,
          ),
          if (!solicitud.completada) ...[
            const SizedBox(height: 16),
            BotonSecundario(
              texto: 'Avanzar estado (demo)',
              icono: Icons.fast_forward_rounded,
              onPressed: app.avanzarSolicitud,
            ),
          ],
        ],
      ),
    );
  }
}
