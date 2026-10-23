import 'package:flutter/material.dart';

import '../controllers/app_scope.dart';
import '../theme/app_tema.dart';
import '../utils/formato.dart';
import '../widgets/aviso.dart';
import '../widgets/borde_discontinuo.dart';
import '../widgets/boton_primario.dart';
import '../widgets/boton_secundario.dart';
import '../widgets/campo_texto_aquageo.dart';
import '../widgets/mapa_simulado.dart';
import '../widgets/tarjeta_aquageo.dart';

class ReportarFugaView extends StatefulWidget {
  const ReportarFugaView({super.key});

  @override
  State<ReportarFugaView> createState() => _ReportarFugaViewState();
}

class _ReportarFugaViewState extends State<ReportarFugaView> {
  final _clave = GlobalKey<FormState>();
  final _descripcion = TextEditingController();
  double? _lat;
  double? _lon;
  bool _conFoto = false;

  @override
  void dispose() {
    _descripcion.dispose();
    super.dispose();
  }

  /// Simula el GPS: usa el centro de la zona del usuario con una pequeña variación.
  void _ubicar() {
    final z = AppScope.leer(context).zona;
    final ahora = DateTime.now().millisecond / 1000;
    setState(() {
      _lat = z.latitud + (ahora - 0.5) * 0.004;
      _lon = z.longitud + (0.5 - ahora) * 0.004;
    });
  }

  void _enviar() {
    FocusScope.of(context).unfocus();
    if (_lat == null || _lon == null) {
      mostrarAviso(context, 'Primero marca la ubicación de la fuga.', error: true);
      return;
    }
    if (!(_clave.currentState?.validate() ?? false)) return;
    final r = AppScope.leer(context).enviarReporte(
      descripcion: _descripcion.text,
      latitud: _lat!,
      longitud: _lon!,
      conFoto: _conFoto,
    );
    setState(() {
      _lat = null;
      _lon = null;
      _conFoto = false;
    });
    _descripcion.clear();
    mostrarAviso(context, 'Reporte ${r.folio} enviado. ¡Gracias!');
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final reportes = app.cuenta.reportes;
    final hayUbicacion = _lat != null && _lon != null;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Reportar fuga', style: AppTema.titulo),
          const SizedBox(height: 4),
          Text('Zona: ${app.zona.etiqueta}', style: AppTema.suave),
          const SizedBox(height: 18),
          MapaSimulado(
            conUbicacion: hayUbicacion,
            leyenda: hayUbicacion
                ? '${_lat!.toStringAsFixed(5)}, ${_lon!.toStringAsFixed(5)}'
                : 'Aún sin ubicación',
          ),
          const SizedBox(height: 10),
          BotonSecundario(
            texto: hayUbicacion ? 'Actualizar ubicación' : 'Usar mi ubicación',
            icono: Icons.my_location_rounded,
            onPressed: _ubicar,
          ),
          const SizedBox(height: 18),
          BordeDiscontinuo(
            color: _conFoto ? AppTema.exito : AppTema.primarioClaro,
            child: Material(
              color: _conFoto ? AppTema.exitoTinte : AppTema.primarioTinte,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => setState(() => _conFoto = !_conFoto),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Column(
                    children: [
                      Icon(
                        _conFoto
                            ? Icons.check_circle_rounded
                            : Icons.add_a_photo_outlined,
                        size: 32,
                        color: _conFoto ? AppTema.exito : AppTema.primario,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _conFoto ? 'Foto adjunta (simulada)' : 'Adjuntar fotografía',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: _conFoto ? AppTema.exito : AppTema.primario,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _conFoto ? 'Toca para quitarla' : 'Toca para simular la cámara',
                        style: AppTema.suave,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Form(
            key: _clave,
            child: CampoTextoAquaGeo(
              controller: _descripcion,
              etiqueta: 'Descripción de la fuga',
              icono: Icons.edit_note_rounded,
              lineas: 3,
              validador: (v) => (v == null || v.trim().length < 5)
                  ? 'Cuéntanos qué está pasando'
                  : null,
            ),
          ),
          const SizedBox(height: 18),
          BotonPrimario(
            texto: 'Enviar reporte',
            icono: Icons.send_rounded,
            oscuro: false,
            onPressed: _enviar,
          ),
          if (reportes.isNotEmpty) ...[
            const SizedBox(height: 26),
            const Text('Mis reportes', style: AppTema.seccion),
            const SizedBox(height: 10),
            for (final r in reportes)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TarjetaAquaGeo(
                  sombra: false,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppTema.alertaTinte,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: AppTema.alerta,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.folio,
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            Text(
                              r.descripcion,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTema.suave,
                            ),
                            Text(Formato.fechaHora(r.fecha), style: AppTema.suave),
                          ],
                        ),
                      ),
                      if (r.conFoto)
                        const Icon(Icons.photo_camera_outlined,
                            color: AppTema.textoSuave, size: 20),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
