import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

class ItemNavegacion {
  final IconData icono;
  final IconData iconoActivo;
  final String etiqueta;

  const ItemNavegacion(this.icono, this.iconoActivo, this.etiqueta);
}

class BarraNavegacionAquaGeo extends StatelessWidget {
  final int indice;
  final ValueChanged<int> onCambio;
  final List<ItemNavegacion> items;

  const BarraNavegacionAquaGeo({
    super.key,
    required this.indice,
    required this.onCambio,
    this.items = itemsUsuario,
  });

  static const List<ItemNavegacion> itemsAdmin = [
    ItemNavegacion(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Panel'),
    ItemNavegacion(Icons.people_outline_rounded, Icons.people_rounded, 'Clientes'),
    ItemNavegacion(Icons.assignment_outlined, Icons.assignment_rounded, 'Solicitudes'),
    ItemNavegacion(Icons.water_damage_outlined, Icons.water_damage_rounded, 'Fugas'),
    ItemNavegacion(Icons.grid_view_outlined, Icons.grid_view_rounded, 'Más'),
  ];

  static const List<ItemNavegacion> itemsUsuario = [
    ItemNavegacion(Icons.home_outlined, Icons.home_rounded, 'Inicio'),
    ItemNavegacion(Icons.credit_card_outlined, Icons.credit_card_rounded, 'Pagos'),
    ItemNavegacion(Icons.description_outlined, Icons.description_rounded, 'Solicitudes'),
    ItemNavegacion(Icons.warning_amber_rounded, Icons.warning_amber_rounded, 'Reportes'),
    ItemNavegacion(Icons.person_outline_rounded, Icons.person_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTema.tarjeta,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(color: Color(0x1A0B3B4F), blurRadius: 24, offset: Offset(0, -6)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _BotonNav(
                    item: items[i],
                    activo: i == indice,
                    onTap: () => onCambio(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonNav extends StatelessWidget {
  final ItemNavegacion item;
  final bool activo;
  final VoidCallback onTap;

  const _BotonNav({
    required this.item,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = activo ? AppTema.primario : AppTema.iconoInactivo;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: activo ? AppTema.primarioTinte : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              activo ? item.iconoActivo : item.icono,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.etiqueta,
            style: TextStyle(
              fontSize: 11,
              fontWeight: activo ? FontWeight.w800 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
