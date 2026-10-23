import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_tema.dart';

/// Pide el PIN de 4 dígitos con teclado propio.
/// Devuelve `true` solo si [validar] aceptó el PIN.
Future<bool> mostrarDialogoPin(
  BuildContext context, {
  required bool Function(String pin) validar,
  String titulo = 'Confirma con tu PIN',
  String subtitulo = 'Ingresa tu PIN de 4 dígitos para continuar.',
}) async {
  final resultado = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: AppTema.tarjeta,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => _HojaPin(validar: validar, titulo: titulo, subtitulo: subtitulo),
  );
  return resultado ?? false;
}

class _HojaPin extends StatefulWidget {
  final bool Function(String) validar;
  final String titulo;
  final String subtitulo;

  const _HojaPin({
    required this.validar,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  State<_HojaPin> createState() => _HojaPinState();
}

class _HojaPinState extends State<_HojaPin> with SingleTickerProviderStateMixin {
  String _pin = '';
  bool _error = false;
  int _intentos = 0;

  late final AnimationController _sacudida = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );

  @override
  void dispose() {
    _sacudida.dispose();
    super.dispose();
  }

  void _tecla(String d) {
    if (_pin.length >= 4) return;
    HapticFeedback.selectionClick();
    setState(() {
      _pin += d;
      _error = false;
    });
    if (_pin.length == 4) _comprobar();
  }

  void _borrar() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = false;
    });
  }

  Future<void> _comprobar() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    if (widget.validar(_pin)) {
      Navigator.of(context).pop(true);
      return;
    }
    _intentos++;
    HapticFeedback.heavyImpact();
    setState(() {
      _error = true;
      _pin = '';
    });
    _sacudida.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppTema.borde,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                gradient: AppTema.gradientePrincipal,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 14),
            Text(widget.titulo, style: AppTema.titulo),
            const SizedBox(height: 4),
            Text(
              widget.subtitulo,
              textAlign: TextAlign.center,
              style: AppTema.suave,
            ),
            const SizedBox(height: 22),
            AnimatedBuilder(
              animation: _sacudida,
              builder: (context, hijo) {
                final dx = (1 - _sacudida.value) *
                    12 *
                    ((_sacudida.value * 10).floor().isEven ? 1 : -1);
                return Transform.translate(offset: Offset(dx, 0), child: hijo);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 4; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < _pin.length
                            ? (_error ? AppTema.peligro : AppTema.primario)
                            : Colors.transparent,
                        border: Border.all(
                          color: _error
                              ? AppTema.peligro
                              : (i < _pin.length ? AppTema.primario : AppTema.borde),
                          width: 2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  _error ? 'PIN incorrecto. Intenta de nuevo.' : '',
                  style: const TextStyle(
                    color: AppTema.peligro,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            for (final fila in const [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final d in fila) _Tecla(texto: d, onTap: () => _tecla(d)),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Tecla(
                    icono: Icons.close_rounded,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                  _Tecla(texto: '0', onTap: () => _tecla('0')),
                  _Tecla(icono: Icons.backspace_outlined, onTap: _borrar),
                ],
              ),
            ),
            if (_intentos >= 3)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Demo: el PIN de la cuenta de prueba es 1234.',
                  style: AppTema.suave,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tecla extends StatelessWidget {
  final String? texto;
  final IconData? icono;
  final VoidCallback onTap;

  const _Tecla({this.texto, this.icono, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: AppTema.fondo,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 68,
            height: 68,
            child: Center(
              child: texto != null
                  ? Text(
                      texto!,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppTema.texto,
                      ),
                    )
                  : Icon(icono, color: AppTema.textoSuave, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
