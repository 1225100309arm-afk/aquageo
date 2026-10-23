import 'package:flutter/material.dart';

import '../models/zona.dart';
import '../theme/app_tema.dart';
import 'tarjeta_aquageo.dart';

/// Campo que abre una hoja inferior para elegir la zona de servicio.
class SelectorZona extends StatelessWidget {
  final List<Zona> zonas;
  final String? zonaId;
  final ValueChanged<Zona> onSeleccion;
  final String? error;

  const SelectorZona({
    super.key,
    required this.zonas,
    required this.zonaId,
    required this.onSeleccion,
    this.error,
  });

  Zona? get _actual {
    for (final z in zonas) {
      if (z.id == zonaId) return z;
    }
    return null;
  }

  Future<void> _abrir(BuildContext context) async {
    final elegida = await showModalBottomSheet<Zona>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTema.tarjeta,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (hojaContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTema.borde,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Selecciona tu zona', style: AppTema.titulo),
              const SizedBox(height: 4),
              const Text('Define dónde se da de alta tu servicio.', style: AppTema.suave),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  children: [
                    for (final z in zonas)
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTema.primarioTinte,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: AppTema.primario,
                            size: 21,
                          ),
                        ),
                        title: Text(
                          z.nombre,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(z.municipio),
                        trailing: z.id == zonaId
                            ? const Icon(Icons.check_circle_rounded, color: AppTema.primario)
                            : null,
                        onTap: () => Navigator.of(hojaContext).pop(z),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    if (elegida != null) onSeleccion(elegida);
  }

  @override
  Widget build(BuildContext context) {
    final actual = _actual;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TarjetaAquaGeo(
          onTap: () => _abrir(context),
          sombra: false,
          colorBorde: error != null ? AppTema.peligro : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.location_city_rounded, color: AppTema.primario),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Zona de servicio', style: AppTema.suave),
                    const SizedBox(height: 2),
                    Text(
                      actual?.etiqueta ?? 'Selecciona tu zona',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: actual == null ? AppTema.textoSuave : AppTema.texto,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.expand_more_rounded, color: AppTema.textoSuave),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 14),
            child: Text(
              error!,
              style: const TextStyle(fontSize: 12, color: AppTema.peligro),
            ),
          ),
      ],
    );
  }
}
