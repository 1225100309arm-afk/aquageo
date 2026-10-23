import 'package:flutter/material.dart';

import '../../controllers/app_scope.dart';
import '../../theme/app_tema.dart';
import '../../widgets/tarjeta_aquageo.dart';
import 'admin_avisos_view.dart';
import 'admin_pagos_view.dart';
import 'admin_zonas_view.dart';

class AdminMasView extends StatelessWidget {
  const AdminMasView({super.key});

  void _abrir(BuildContext context, Widget pantalla) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => pantalla));
  }

  Future<void> _salir(BuildContext context) async {
    final app = AppScope.leer(context);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Cerrar sesión'),
        content: const Text('¿Salir del panel de administración?'),
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
    final r = app.resumen;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Más opciones', style: AppTema.titulo),
          const SizedBox(height: 18),
          _Opcion(
            icono: Icons.receipt_long_rounded,
            color: AppTema.exito,
            tinte: AppTema.exitoTinte,
            texto: 'Pagos',
            detalle: '${r.pagos} registrados',
            onTap: () => _abrir(context, const AdminPagosView()),
          ),
          const SizedBox(height: 10),
          _Opcion(
            icono: Icons.map_outlined,
            color: AppTema.primario,
            tinte: AppTema.primarioTinte,
            texto: 'Zonas de servicio',
            detalle: '${app.zonas.length} zonas',
            onTap: () => _abrir(context, const AdminZonasView()),
          ),
          const SizedBox(height: 10),
          _Opcion(
            icono: Icons.campaign_outlined,
            color: AppTema.violeta,
            tinte: AppTema.violetaTinte,
            texto: 'Enviar aviso a clientes',
            onTap: () => _abrir(context, const AdminAvisosView()),
          ),
          const SizedBox(height: 10),
          _Opcion(
            icono: Icons.logout_rounded,
            color: AppTema.peligro,
            tinte: AppTema.peligroTinte,
            texto: 'Cerrar sesión',
            onTap: () => _salir(context),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text('AquaGeo Admin · versión 1.0 (demo)', style: AppTema.suave),
          ),
        ],
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  final IconData icono;
  final Color color;
  final Color tinte;
  final String texto;
  final String? detalle;
  final VoidCallback onTap;

  const _Opcion({
    required this.icono,
    required this.color,
    required this.tinte,
    required this.texto,
    required this.onTap,
    this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    return TarjetaAquaGeo(
      onTap: onTap,
      sombra: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tinte,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icono, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(texto, style: const TextStyle(fontWeight: FontWeight.w800)),
                if (detalle != null) Text(detalle!, style: AppTema.suave),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppTema.textoSuave),
        ],
      ),
    );
  }
}
