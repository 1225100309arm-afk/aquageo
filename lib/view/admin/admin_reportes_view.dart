import 'package:flutter/material.dart';

import '../../controllers/app_scope.dart';
import '../../models/reporte_fuga.dart';
import '../../theme/app_tema.dart';
import '../../utils/formato.dart';
import '../../widgets/aviso.dart';
import '../../widgets/boton_secundario.dart';
import '../../widgets/chip_estado.dart';
import '../../widgets/filtro_chips.dart';
import '../../widgets/tarjeta_aquageo.dart';

class AdminReportesView extends StatefulWidget {
  const AdminReportesView({super.key});

  @override
  State<AdminReportesView> createState() => _AdminReportesViewState();
}

class _AdminReportesViewState extends State<AdminReportesView> {
  int _filtro = 0; // 0 pendientes, 1 atendidos, 2 todos

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final todos = app.todosLosReportes;
    final lista = todos.where((r) {
      if (_filtro == 0) return !r.atendido;
      if (_filtro == 1) return r.atendido;
      return true;
    }).toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Reportes de fuga', style: AppTema.titulo),
          const SizedBox(height: 4),
          Text(
            '${todos.where((r) => !r.atendido).length} pendientes de atender',
            style: AppTema.suave,
          ),
          const SizedBox(height: 16),
          FiltroChips(
            opciones: const ['Pendientes', 'Atendidos', 'Todos'],
            seleccion: _filtro,
            onCambio: (i) => setState(() => _filtro = i),
          ),
          const SizedBox(height: 14),
          if (lista.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('No hay reportes aquí.', style: AppTema.suave)),
            )
          else
            for (final r in lista)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TarjetaReporte(reporte: r),
              ),
        ],
      ),
    );
  }
}

class _TarjetaReporte extends StatelessWidget {
  final ReporteFuga reporte;

  const _TarjetaReporte({required this.reporte});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cliente = app.clientePorContrato(reporte.contrato);

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
                  color: reporte.atendido ? AppTema.exitoTinte : AppTema.alertaTinte,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  reporte.atendido
                      ? Icons.check_circle_rounded
                      : Icons.water_damage_rounded,
                  color: reporte.atendido ? AppTema.exito : AppTema.alerta,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reporte.folio,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
                      ),
                    ),
                    Text(Formato.fechaHora(reporte.fecha), style: AppTema.suave),
                  ],
                ),
              ),
              ChipEstado(
                texto: reporte.atendido ? 'Atendido' : 'Pendiente',
                color: reporte.atendido ? AppTema.exito : AppTema.alerta,
                tinte: reporte.atendido ? AppTema.exitoTinte : AppTema.alertaTinte,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(reporte.descripcion, style: AppTema.cuerpo),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.person_outline_rounded,
                  size: 16, color: AppTema.textoSuave),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  cliente == null
                      ? reporte.contrato
                      : '${cliente.saludoFamilia} · ${app.zonaDe(cliente).nombre}',
                  style: AppTema.suave,
                ),
              ),
              if (reporte.conFoto)
                const Icon(Icons.photo_camera_outlined,
                    size: 17, color: AppTema.textoSuave),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: AppTema.textoSuave),
              const SizedBox(width: 4),
              Text(
                '${reporte.latitud.toStringAsFixed(5)}, ${reporte.longitud.toStringAsFixed(5)}',
                style: AppTema.suave,
              ),
            ],
          ),
          if (!reporte.atendido) ...[
            const SizedBox(height: 14),
            BotonSecundario(
              texto: 'Marcar como atendido',
              icono: Icons.task_alt_rounded,
              onPressed: () {
                app.marcarReporteAtendido(reporte);
                mostrarAviso(context, 'Reporte ${reporte.folio} atendido.');
              },
            ),
          ],
        ],
      ),
    );
  }
}
