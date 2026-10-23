import 'package:flutter/material.dart';

import '../theme/app_tema.dart';

/// Tarjeta base: blanca, bordes redondeados y sombra suave.
/// Si recibe [gradiente] se pinta como tarjeta destacada (sin borde).
class TarjetaAquaGeo extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Gradient? gradiente;
  final Color? colorBorde;
  final double anchoBorde;
  final bool sombra;

  const TarjetaAquaGeo({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.gradiente,
    this.colorBorde,
    this.anchoBorde = 1,
    this.sombra = true,
  });

  @override
  Widget build(BuildContext context) {
    final radio = BorderRadius.circular(20);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: gradiente == null ? AppTema.tarjeta : null,
        gradient: gradiente,
        borderRadius: radio,
        border: gradiente == null
            ? Border.all(color: colorBorde ?? AppTema.borde, width: anchoBorde)
            : null,
        boxShadow: sombra ? AppTema.sombraSuave : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
