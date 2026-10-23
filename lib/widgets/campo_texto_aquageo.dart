import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_tema.dart';

/// Campo de texto con el estilo de la app. Para contraseñas agrega el "ojo".
class CampoTextoAquaGeo extends StatefulWidget {
  final TextEditingController controller;
  final String etiqueta;
  final IconData? icono;
  final bool esContrasena;
  final TextInputType? teclado;
  final List<TextInputFormatter>? formateadores;
  final String? Function(String?)? validador;
  final int lineas;
  final TextInputAction? accion;
  final ValueChanged<String>? onEnviado;
  final String? ayuda;
  final ValueChanged<String>? onCambio;

  const CampoTextoAquaGeo({
    super.key,
    required this.controller,
    required this.etiqueta,
    this.icono,
    this.esContrasena = false,
    this.teclado,
    this.formateadores,
    this.validador,
    this.lineas = 1,
    this.accion,
    this.onEnviado,
    this.ayuda,
    this.onCambio,
  });

  @override
  State<CampoTextoAquaGeo> createState() => _CampoTextoAquaGeoState();
}

class _CampoTextoAquaGeoState extends State<CampoTextoAquaGeo> {
  late bool _oculto = widget.esContrasena;

  OutlineInputBorder _borde(Color color, [double ancho = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: ancho),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _oculto,
      keyboardType: widget.teclado,
      inputFormatters: widget.formateadores,
      validator: widget.validador,
      maxLines: widget.esContrasena ? 1 : widget.lineas,
      textInputAction: widget.accion,
      onFieldSubmitted: widget.onEnviado,
      onChanged: widget.onCambio,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppTema.texto,
      ),
      decoration: InputDecoration(
        labelText: widget.etiqueta,
        helperText: widget.ayuda,
        filled: true,
        fillColor: AppTema.tarjeta,
        labelStyle: const TextStyle(color: AppTema.textoSuave),
        prefixIcon: widget.icono == null ? null : Icon(widget.icono, size: 21),
        prefixIconColor: AppTema.textoSuave,
        suffixIcon: widget.esContrasena
            ? IconButton(
                onPressed: () => setState(() => _oculto = !_oculto),
                icon: Icon(
                  _oculto
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 21,
                ),
              )
            : null,
        suffixIconColor: AppTema.textoSuave,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        border: _borde(AppTema.borde),
        enabledBorder: _borde(AppTema.borde),
        focusedBorder: _borde(AppTema.primario, 1.8),
        errorBorder: _borde(AppTema.peligro),
        focusedErrorBorder: _borde(AppTema.peligro, 1.8),
      ),
    );
  }
}
