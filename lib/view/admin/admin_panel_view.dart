import 'package:flutter/material.dart';

import '../../controllers/app_scope.dart';
import '../../models/resumen_admin.dart';
import '../../theme/app_tema.dart';
import '../../utils/formato.dart';
import '../../widgets/chip_estado.dart';
import '../../widgets/tarjeta_aquageo.dart';
import '../../widgets/tarjeta_kpi.dart';
import 'admin_pagos_view.dart';

class AdminPanelView extends StatelessWidget {
  const AdminPanelView({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final r = app.resumen;
    final pagos = app.todosLosPagos;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  gradient: AppTema.gradienteOscuro,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Panel de control', style: AppTema.titulo),
                    Text('Administrador · AquaGeo', style: AppTema.suave),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ---- Recaudación
          TarjetaAquaGeo(
            gradiente: AppTema.gradienteOscuro,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.account_balance_wallet_rounded,
                        color: Colors.white70, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Recaudado',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  Formato.moneda(r.recaudado),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _DatoClaro(
                        etiqueta: 'Por cobrar',
                        valor: Formato.moneda(r.porCobrar),
                      ),
                    ),
                    Expanded(
                      child: _DatoClaro(
                        etiqueta: 'Clientes',
                        valor: '${r.clientes}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ---- Indicadores
          Row(
            children: [
              Expanded(
                child: TarjetaKpi(
                  icono: Icons.money_off_rounded,
                  valor: '${r.clientesConAdeudo}',
                  etiqueta: 'Clientes con adeudo',
                  color: AppTema.peligro,
                  tinte: AppTema.peligroTinte,
                  onTap: () => app.irAPestana(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TarjetaKpi(
                  icono: Icons.water_damage_rounded,
                  valor: '${r.reportesPendientes}',
                  etiqueta: 'Fugas sin atender',
                  color: AppTema.alerta,
                  tinte: AppTema.alertaTinte,
                  onTap: () => app.irAPestana(3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TarjetaKpi(
                  icono: Icons.assignment_rounded,
                  valor: '${r.solicitudesEnProceso}',
                  etiqueta: 'Solicitudes en proceso',
                  color: AppTema.azul,
                  tinte: AppTema.azulTinte,
                  onTap: () => app.irAPestana(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TarjetaKpi(
                  icono: Icons.receipt_long_rounded,
                  valor: '${r.pagos}',
                  etiqueta: 'Pagos registrados',
                  color: AppTema.exito,
                  tinte: AppTema.exitoTinte,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const AdminPagosView()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ---- Por zona
          const Text('Cobranza por zona', style: AppTema.seccion),
          const SizedBox(height: 10),
          TarjetaAquaGeo(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (var i = 0; i < r.porZona.length; i++) ...[
                  if (i > 0) const SizedBox(height: 16),
                  _FilaZona(resumen: r.porZona[i]),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ---- Últimos pagos
          const Text('Últimos pagos', style: AppTema.seccion),
          const SizedBox(height: 10),
          if (pagos.isEmpty)
            const TarjetaAquaGeo(
              sombra: false,
              child: Text('Aún no hay pagos.', style: AppTema.suave),
            )
          else
            for (final p in pagos.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TarjetaAquaGeo(
                  sombra: false,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppTema.exitoTinte,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: AppTema.exito,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.clientePorContrato(p.contrato)?.saludoFamilia ??
                                  p.contrato,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${p.folio} · ${Formato.fecha(p.fecha)}',
                              style: AppTema.suave,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Formato.moneda(p.monto),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                          if (p.metodo.esEfectivo)
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: ChipEstado(
                                texto: 'En caja',
                                color: AppTema.violeta,
                                tinte: AppTema.violetaTinte,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _DatoClaro extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const _DatoClaro({required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(color: Colors.white60, fontSize: 12.5),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _FilaZona extends StatelessWidget {
  final ResumenZona resumen;

  const _FilaZona({required this.resumen});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                resumen.zona.etiqueta,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ),
            Text('${resumen.clientes} cliente(s)', style: AppTema.suave),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: resumen.avance,
            minHeight: 8,
            backgroundColor: AppTema.gris,
            color: AppTema.primario,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text('Cobrado ${Formato.moneda(resumen.recaudado)}', style: AppTema.suave),
            const Spacer(),
            Text('Pendiente ${Formato.moneda(resumen.porCobrar)}', style: AppTema.suave),
          ],
        ),
      ],
    );
  }
}
