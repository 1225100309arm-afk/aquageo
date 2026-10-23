import 'package:flutter/material.dart';

import '../../controllers/app_scope.dart';
import '../../models/usuario.dart';
import '../../theme/app_tema.dart';
import '../../utils/formato.dart';
import '../../widgets/campo_texto_aquageo.dart';
import '../../widgets/chip_estado.dart';
import '../../widgets/filtro_chips.dart';
import '../../widgets/tarjeta_aquageo.dart';
import 'admin_cliente_detalle_view.dart';

class AdminClientesView extends StatefulWidget {
  const AdminClientesView({super.key});

  @override
  State<AdminClientesView> createState() => _AdminClientesViewState();
}

class _AdminClientesViewState extends State<AdminClientesView> {
  final _busqueda = TextEditingController();
  int _filtro = 0; // 0 todos, 1 con adeudo, 2 al corriente

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final texto = _busqueda.text.trim().toLowerCase();

    final lista = <Usuario>[];
    for (final u in app.clientes) {
      final c = app.cuentaDe(u);
      if (_filtro == 1 && !c.hayAdeudo) continue;
      if (_filtro == 2 && c.hayAdeudo) continue;
      if (texto.isNotEmpty &&
          !u.numero.contains(texto) &&
          !u.familia.toLowerCase().contains(texto)) {
        continue;
      }
      lista.add(u);
    }

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Clientes', style: AppTema.titulo),
          const SizedBox(height: 4),
          Text('${app.clientes.length} contratos registrados', style: AppTema.suave),
          const SizedBox(height: 16),
          CampoTextoAquaGeo(
            controller: _busqueda,
            etiqueta: 'Buscar por contrato o familia',
            icono: Icons.search_rounded,
            onCambio: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          FiltroChips(
            opciones: const ['Todos', 'Con adeudo', 'Al corriente'],
            seleccion: _filtro,
            onCambio: (i) => setState(() => _filtro = i),
          ),
          const SizedBox(height: 14),
          if (lista.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text('No hay clientes con esos filtros.', style: AppTema.suave),
              ),
            )
          else
            for (final u in lista)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TarjetaCliente(usuario: u),
              ),
        ],
      ),
    );
  }
}

class _TarjetaCliente extends StatelessWidget {
  final Usuario usuario;

  const _TarjetaCliente({required this.usuario});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cuenta = app.cuentaDe(usuario);
    return TarjetaAquaGeo(
      sombra: false,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => AdminClienteDetalleView(cliente: usuario),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: AppTema.gradientePrincipal,
              shape: BoxShape.circle,
            ),
            child: Text(
              usuario.inicial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuario.saludoFamilia,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  '${usuario.contrato} · ${app.zonaDe(usuario).nombre}',
                  style: AppTema.suave,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formato.moneda(cuenta.saldo),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: cuenta.hayAdeudo ? AppTema.peligro : AppTema.exito,
                ),
              ),
              const SizedBox(height: 4),
              ChipEstado(
                texto: cuenta.hayAdeudo ? 'Con adeudo' : 'Al corriente',
                color: cuenta.hayAdeudo ? AppTema.peligro : AppTema.exito,
                tinte: cuenta.hayAdeudo ? AppTema.peligroTinte : AppTema.exitoTinte,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
