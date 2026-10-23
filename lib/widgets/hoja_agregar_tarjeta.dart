import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_tema.dart';
import 'boton_primario.dart';
import 'campo_texto_aquageo.dart';

/// Hoja para agregar un método de pago. Solo se guardan la marca y los
/// últimos 4 dígitos (no se pide el número completo de la tarjeta).
Future<void> mostrarHojaAgregarTarjeta(
  BuildContext context, {
  required void Function(String marca, String ultimos4) onGuardar,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTema.tarjeta,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (hojaContext) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(hojaContext).viewInsets.bottom),
      child: _FormularioTarjeta(
        onGuardar: (marca, ultimos4) {
          onGuardar(marca, ultimos4);
          Navigator.of(hojaContext).pop();
        },
      ),
    ),
  );
}

class _FormularioTarjeta extends StatefulWidget {
  final void Function(String marca, String ultimos4) onGuardar;

  const _FormularioTarjeta({required this.onGuardar});

  @override
  State<_FormularioTarjeta> createState() => _FormularioTarjetaState();
}

class _FormularioTarjetaState extends State<_FormularioTarjeta> {
  static const _marcas = ['Visa', 'Mastercard', 'Débito'];

  final _clave = GlobalKey<FormState>();
  final _ultimos = TextEditingController();
  String _marca = 'Visa';

  @override
  void dispose() {
    _ultimos.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_clave.currentState?.validate() ?? false) {
      widget.onGuardar(_marca, _ultimos.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 18),
        child: Form(
          key: _clave,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppTema.borde,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Agregar método de pago', style: AppTema.titulo),
              const SizedBox(height: 4),
              const Text(
                'Solo guardamos los últimos 4 dígitos. Sin conexión a bancos por ahora.',
                style: AppTema.suave,
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                children: [
                  for (final m in _marcas)
                    ChoiceChip(
                      label: Text(m),
                      selected: _marca == m,
                      onSelected: (_) => setState(() => _marca = m),
                      selectedColor: AppTema.primarioTinte,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _marca == m ? AppTema.primario : AppTema.textoSuave,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              CampoTextoAquaGeo(
                controller: _ultimos,
                etiqueta: 'Últimos 4 dígitos',
                icono: Icons.credit_card_rounded,
                teclado: TextInputType.number,
                formateadores: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validador: (v) =>
                    (v == null || v.length != 4) ? 'Escribe los 4 dígitos' : null,
                onEnviado: (_) => _guardar(),
              ),
              const SizedBox(height: 18),
              BotonPrimario(
                texto: 'Guardar método',
                icono: Icons.add_card_rounded,
                onPressed: _guardar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
