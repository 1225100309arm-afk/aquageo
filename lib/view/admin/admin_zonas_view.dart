import 'package:flutter/material.dart';

import '../../controllers/app_scope.dart';
import '../../theme/app_tema.dart';
import '../../utils/formato.dart';
import '../../widgets/aviso.dart';
import '../../widgets/boton_primario.dart';
import '../../widgets/campo_texto_aquageo.dart';
import '../../widgets/encabezado_pantalla.dart';
import '../../widgets/tarjeta_aquageo.dart';

class AdminZonasView extends StatelessWidget {
  const AdminZonasView({super.key});

  void _agregar(BuildContext context) {
    final app = AppScope.leer(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTema.tarjeta,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (hoja) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(hoja).viewInsets.bottom),
        child: _FormularioZona(
          onGuardar: (municipio, nombre, lat, lon) {
            final error = app.crearZona(
              municipio: municipio,
              nombre: nombre,
              latitud: lat,
              longitud: lon,
            );
            if (error != null) {
              mostrarAviso(context, error, error: true);
              return;
            }
            Navigator.of(hoja).pop();
            mostrarAviso(context, 'Zona "$nombre" agregada.');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final resumen = app.resumen;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: EncabezadoPantalla(
                titulo: 'Zonas de servicio',
                subtitulo: '${app.zonas.length} zonas dadas de alta',
                onAtras: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                children: [
                  for (final z in resumen.porZona)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TarjetaAquaGeo(
                        sombra: false,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppTema.primarioTinte,
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: AppTema.primario,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    z.zona.etiqueta,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    '${z.clientes} cliente(s) · '
                                    '${z.zona.latitud.toStringAsFixed(4)}, '
                                    '${z.zona.longitud.toStringAsFixed(4)}',
                                    style: AppTema.suave,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              Formato.moneda(z.porCobrar),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: z.porCobrar > 0
                                    ? AppTema.peligro
                                    : AppTema.exito,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
              child: BotonPrimario(
                texto: 'Agregar zona',
                icono: Icons.add_location_alt_outlined,
                onPressed: () => _agregar(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormularioZona extends StatefulWidget {
  final void Function(String municipio, String nombre, double lat, double lon)
      onGuardar;

  const _FormularioZona({required this.onGuardar});

  @override
  State<_FormularioZona> createState() => _FormularioZonaState();
}

class _FormularioZonaState extends State<_FormularioZona> {
  final _clave = GlobalKey<FormState>();
  final _municipio = TextEditingController();
  final _nombre = TextEditingController();
  final _lat = TextEditingController();
  final _lon = TextEditingController();

  @override
  void dispose() {
    _municipio.dispose();
    _nombre.dispose();
    _lat.dispose();
    _lon.dispose();
    super.dispose();
  }

  String? _numero(String? v, double min, double max) {
    final n = double.tryParse((v ?? '').trim());
    if (n == null) return 'Número inválido';
    if (n < min || n > max) return 'Fuera de rango';
    return null;
  }

  void _guardar() {
    if (!(_clave.currentState?.validate() ?? false)) return;
    widget.onGuardar(
      _municipio.text,
      _nombre.text,
      double.parse(_lat.text.trim()),
      double.parse(_lon.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
        child: Form(
          key: _clave,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nueva zona', style: AppTema.titulo),
              const SizedBox(height: 4),
              const Text(
                'Los clientes podrán elegirla al darse de alta.',
                style: AppTema.suave,
              ),
              const SizedBox(height: 16),
              CampoTextoAquaGeo(
                controller: _municipio,
                etiqueta: 'Municipio',
                icono: Icons.location_city_rounded,
                accion: TextInputAction.next,
                validador: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Escribe el municipio' : null,
              ),
              const SizedBox(height: 12),
              CampoTextoAquaGeo(
                controller: _nombre,
                etiqueta: 'Nombre de la zona',
                icono: Icons.place_outlined,
                accion: TextInputAction.next,
                validador: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Escribe el nombre' : null,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CampoTextoAquaGeo(
                      controller: _lat,
                      etiqueta: 'Latitud',
                      teclado: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      accion: TextInputAction.next,
                      validador: (v) => _numero(v, -90, 90),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CampoTextoAquaGeo(
                      controller: _lon,
                      etiqueta: 'Longitud',
                      teclado: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      validador: (v) => _numero(v, -180, 180),
                      onEnviado: (_) => _guardar(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              BotonPrimario(
                texto: 'Guardar zona',
                icono: Icons.check_rounded,
                onPressed: _guardar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
