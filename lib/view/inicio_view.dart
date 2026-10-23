import 'package:flutter/material.dart';

import '../controllers/app_scope.dart';
import '../theme/app_tema.dart';
import '../utils/formato.dart';
import '../widgets/acceso_rapido.dart';
import '../widgets/actividad_item.dart';
import '../widgets/boton_icono.dart';
import '../widgets/grafica_consumo.dart';
import '../widgets/tarjeta_aquageo.dart';
import 'notificaciones_view.dart';
import 'pago_linea_view.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final usuario = app.usuario;
    final cuenta = app.cuenta;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          // ---- Encabezado
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: AppTema.gradientePrincipal,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  usuario.inicial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hola,', style: AppTema.suave),
                    Text(usuario.saludoFamilia, style: AppTema.titulo),
                  ],
                ),
              ),
              BotonIcono(
                icono: Icons.notifications_none_rounded,
                aviso: cuenta.noLeidas > 0,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const NotificacionesView()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 62),
            child: Text(
              '${usuario.contrato} · ${app.zona.nombre}',
              style: AppTema.suave,
            ),
          ),
          const SizedBox(height: 20),

          // ---- Saldo
          TarjetaAquaGeo(
            gradiente: AppTema.gradientePrincipal,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.water_drop_rounded, color: Colors.white70, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      cuenta.hayAdeudo ? 'Saldo pendiente' : 'Estás al corriente',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  Formato.moneda(cuenta.saldo),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cuenta.hayAdeudo
                            ? 'Vence el 25 del mes en curso'
                            : 'Sin adeudos. ¡Gracias por tu pago!',
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    if (cuenta.hayAdeudo)
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(builder: (_) => const PagoLineaView()),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                            child: Text(
                              'Pagar ahora',
                              style: TextStyle(
                                color: AppTema.primario,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // ---- Consumo
          const Text('Consumo (últimos meses)', style: AppTema.seccion),
          const SizedBox(height: 10),
          TarjetaAquaGeo(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
            child: GraficaConsumo(datos: cuenta.consumos),
          ),
          const SizedBox(height: 22),

          // ---- Accesos rápidos
          const Text('Accesos rápidos', style: AppTema.seccion),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.0,
            children: [
              AccesoRapido(
                icono: Icons.credit_card_rounded,
                etiqueta: 'Pagar',
                detalle: 'Saldo y facturación',
                color: AppTema.primario,
                tinte: AppTema.primarioTinte,
                onTap: () => app.irAPestana(1),
              ),
              AccesoRapido(
                icono: Icons.local_shipping_outlined,
                etiqueta: 'Solicitar pipa',
                detalle: 'Pipa o nueva toma',
                color: AppTema.azul,
                tinte: AppTema.azulTinte,
                onTap: () => app.irAPestana(2),
              ),
              AccesoRapido(
                icono: Icons.warning_amber_rounded,
                etiqueta: 'Reportar fuga',
                detalle: 'Con ubicación y foto',
                color: AppTema.alerta,
                tinte: AppTema.alertaTinte,
                onTap: () => app.irAPestana(3),
              ),
              AccesoRapido(
                icono: Icons.notifications_active_outlined,
                etiqueta: 'Avisos',
                detalle: cuenta.noLeidas == 0
                    ? 'Todo al día'
                    : '${cuenta.noLeidas} sin leer',
                color: AppTema.violeta,
                tinte: AppTema.violetaTinte,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const NotificacionesView()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ---- Actividad
          const Text('Actividad reciente', style: AppTema.seccion),
          const SizedBox(height: 10),
          if (cuenta.actividad.isEmpty)
            const TarjetaAquaGeo(
              sombra: false,
              child: Text('Aún no hay actividad.', style: AppTema.suave),
            )
          else
            for (final a in cuenta.actividad.take(4))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ActividadItem(actividad: a),
              ),
        ],
      ),
    );
  }
}
