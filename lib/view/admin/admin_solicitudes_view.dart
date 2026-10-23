import 'package:flutter/material.dart';

import '../../controllers/app_scope.dart';
import '../../models/solicitud.dart';
import '../../theme/app_tema.dart';
import '../../utils/formato.dart';
import '../../widgets/aviso.dart';
import '../../widgets/boton_secundario.dart';
import '../../widgets/chip_estado.dart';
import '../../widgets/tarjeta_aquageo.dart';

class AdminSolicitudesView extends StatelessWidget {
  const AdminSolicitudesView({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final lista = app.todasLasSolicitudes;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Solicitudes', style: AppTema.titulo),
          const SizedBox(height: 4),
          const Text('Pipas y nuevas tomas de todos los clientes.', style: AppTema.suave),
          const SizedBox(height: 18),
          if (lista.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('No hay solicitudes.', style: AppTema.suave)),
            )
          else
            for (final s in lista)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TarjetaSolicitud(solicitud: s),
              ),
        ],
      ),
    );
  }
}

class _TarjetaSolicitud extends StatelessWidget {
  final Solicitud solicitud;

  const _TarjetaSolicitud({required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cliente = app.clientePorContrato(solicitud.contrato);
    final pasos = solicitud.tipo.pasos;
    final hechos = solicitud.estado.clamp(0, pasos.length);
    final ultimo = pasos[(hechos - 1).clamp(0, pasos.length - 1)];

    return TarjetaAquaGeo(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTema.azulTinte,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  solicitud.tipo == TipoSolicitud.pipa
                      ? Icons.local_shipping_outlined
                      : Icons.plumbing_rounded,
                  color: AppTema.azul,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      solicitud.tipo.etiqueta,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
                      ),
                    ),
                    Text(
                      '${solicitud.folio} · ${Formato.fecha(solicitud.fecha)}',
                      style: AppTema.suave,
                    ),
                  ],
                ),
              ),
              ChipEstado(
                texto: solicitud.completada ? 'Completada' : ultimo,
                color: solicitud.completada ? AppTema.exito : AppTema.primario,
                tinte: solicitud.completada
                    ? AppTema.exitoTinte
                    : AppTema.primarioTinte,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            cliente == null
                ? solicitud.contrato
                : '${cliente.saludoFamilia} · ${solicitud.contrato}',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
          ),
          const SizedBox(height: 2),
          Text(solicitud.direccion, style: AppTema.suave),
          if (solicitud.notas.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text('Notas: ${solicitud.notas}', style: AppTema.suave),
          ],
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: hechos / pasos.length,
              minHeight: 8,
              backgroundColor: AppTema.gris,
              color: solicitud.completada ? AppTema.exito : AppTema.primario,
            ),
          ),
          if (!solicitud.completada) ...[
            const SizedBox(height: 14),
            BotonSecundario(
              texto: 'Completar paso: ${pasos[hechos]}',
              icono: Icons.fast_forward_rounded,
              onPressed: () {
                app.avanzarSolicitudDe(solicitud.contrato);
                mostrarAviso(context, 'Solicitud ${solicitud.folio} actualizada.');
              },
            ),
          ],
        ],
      ),
    );
  }
}
