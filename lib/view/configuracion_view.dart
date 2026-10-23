import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/app_scope.dart';
import '../theme/app_tema.dart';
import '../widgets/aviso.dart';
import '../widgets/boton_primario.dart';
import '../widgets/boton_secundario.dart';
import '../widgets/campo_texto_aquageo.dart';
import '../widgets/dialogo_pin.dart';
import '../widgets/hoja_agregar_tarjeta.dart';
import '../widgets/selector_zona.dart';
import '../widgets/tarjeta_aquageo.dart';
import 'notificaciones_view.dart';

/// Pestaña "Perfil": datos del contrato, zona, PIN, métodos de pago y salir.
class ConfiguracionView extends StatelessWidget {
  const ConfiguracionView({super.key});

  Future<void> _cambiarPin(BuildContext context) async {
    final app = AppScope.leer(context);
    final actual = TextEditingController();
    final nuevo = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTema.tarjeta,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (hoja) => Padding(
        padding: EdgeInsets.fromLTRB(
          22, 20, 22, 20 + MediaQuery.of(hoja).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cambiar PIN', style: AppTema.titulo),
            const SizedBox(height: 16),
            CampoTextoAquaGeo(
              controller: actual,
              etiqueta: 'PIN actual',
              icono: Icons.lock_outline_rounded,
              esContrasena: true,
              teclado: TextInputType.number,
              formateadores: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
            ),
            const SizedBox(height: 12),
            CampoTextoAquaGeo(
              controller: nuevo,
              etiqueta: 'PIN nuevo (4 dígitos)',
              icono: Icons.pin_outlined,
              esContrasena: true,
              teclado: TextInputType.number,
              formateadores: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
            ),
            const SizedBox(height: 18),
            BotonPrimario(
              texto: 'Guardar PIN',
              icono: Icons.check_rounded,
              onPressed: () {
                final error = app.cambiarPin(actual: actual.text, nuevo: nuevo.text);
                if (error != null) {
                  mostrarAviso(hoja, error, error: true);
                  return;
                }
                Navigator.of(hoja).pop();
                mostrarAviso(context, 'PIN actualizado.');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _salir(BuildContext context) async {
    final app = AppScope.leer(context);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir de tu cuenta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(d).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(d).pop(true),
            child: const Text(
              'Salir',
              style: TextStyle(color: AppTema.peligro, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
    if (confirmar == true) app.cerrarSesion();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final u = app.usuario;
    final cuenta = app.cuenta;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Perfil y configuración', style: AppTema.titulo),
          const SizedBox(height: 18),
          TarjetaAquaGeo(
            gradiente: AppTema.gradientePrincipal,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    u.inicial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        u.saludoFamilia,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Contrato ${u.contrato}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('Zona de servicio', style: AppTema.seccion),
          const SizedBox(height: 10),
          SelectorZona(
            zonas: app.zonas,
            zonaId: u.zonaId,
            onSeleccion: (z) {
              app.cambiarZona(z.id);
              mostrarAviso(context, 'Zona actualizada: ${z.nombre}.');
            },
          ),
          const SizedBox(height: 22),
          const Text('Métodos de pago', style: AppTema.seccion),
          const SizedBox(height: 10),
          for (final m in cuenta.metodos)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TarjetaAquaGeo(
                sombra: false,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    const Icon(Icons.credit_card_rounded, color: AppTema.primario),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${m.marca}  ${m.etiqueta}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          BotonSecundario(
            texto: 'Agregar método de pago',
            icono: Icons.add_card_rounded,
            onPressed: () => mostrarHojaAgregarTarjeta(
              context,
              onGuardar: (marca, ultimos4) {
                app.agregarMetodo(marca: marca, ultimos4: ultimos4);
                mostrarAviso(context, 'Método agregado.');
              },
            ),
          ),
          const SizedBox(height: 22),
          const Text('Seguridad y avisos', style: AppTema.seccion),
          const SizedBox(height: 10),
          _Opcion(
            icono: Icons.pin_outlined,
            texto: 'Cambiar PIN de pago',
            onTap: () async {
              final ok = await mostrarDialogoPin(
                context,
                validar: app.validarPin,
                titulo: 'Verifica tu identidad',
                subtitulo: 'Ingresa tu PIN actual para cambiarlo.',
              );
              if (ok && context.mounted) await _cambiarPin(context);
            },
          ),
          const SizedBox(height: 10),
          _Opcion(
            icono: Icons.notifications_none_rounded,
            texto: 'Notificaciones',
            detalle: cuenta.noLeidas == 0 ? null : '${cuenta.noLeidas} nuevas',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const NotificacionesView()),
            ),
          ),
          const SizedBox(height: 10),
          _Opcion(
            icono: Icons.logout_rounded,
            texto: 'Cerrar sesión',
            color: AppTema.peligro,
            onTap: () => _salir(context),
          ),
          const SizedBox(height: 22),
          const Center(
            child: Text('AquaGeo · versión 1.0 (demo)', style: AppTema.suave),
          ),
        ],
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  final IconData icono;
  final String texto;
  final String? detalle;
  final Color color;
  final VoidCallback onTap;

  const _Opcion({
    required this.icono,
    required this.texto,
    required this.onTap,
    this.detalle,
    this.color = AppTema.texto,
  });

  @override
  Widget build(BuildContext context) {
    return TarjetaAquaGeo(
      onTap: onTap,
      sombra: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Icon(icono, color: color == AppTema.texto ? AppTema.primario : color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(fontWeight: FontWeight.w800, color: color),
            ),
          ),
          if (detalle != null)
            Text(
              detalle!,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: AppTema.primario,
              ),
            ),
          const Icon(Icons.chevron_right_rounded, color: AppTema.textoSuave),
        ],
      ),
    );
  }
}
