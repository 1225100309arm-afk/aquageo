import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

/// Botón grande con degradado. [oscuro] lo pinta en azul marino.
class BotonPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icono;
  final bool oscuro;
  final bool cargando;

  const BotonPrimario({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
    this.oscuro = false,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    final activo = onPressed != null && !cargando;
    final radio = BorderRadius.circular(16);
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: activo
            ? (oscuro ? AppTema.gradienteOscuro : AppTema.gradientePrincipal)
            : null,
        color: activo ? null : AppTema.gris,
        borderRadius: radio,
        boxShadow: activo && !oscuro ? AppTema.sombraBoton : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radio,
        child: InkWell(
          borderRadius: radio,
          onTap: activo ? onPressed : null,
          child: Center(
            child: cargando
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: AppTema.textoSuave,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icono != null) ...[
                        Icon(
                          icono,
                          size: 20,
                          color: activo ? Colors.white : AppTema.textoSuave,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        texto,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: activo ? Colors.white : AppTema.textoSuave,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
