import 'package:flutter/widgets.dart';

import 'app_controlador.dart';

/// Entrega el [AppControlador] a todo el árbol de widgets (sin paquetes extra).
class AppScope extends InheritedNotifier<AppControlador> {
  const AppScope({
    super.key,
    required AppControlador controlador,
    required super.child,
  }) : super(notifier: controlador);

  /// Para usar dentro de `build`: la pantalla se redibuja cuando algo cambia.
  static AppControlador of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No se encontró AppScope en el árbol de widgets');
    return scope!.notifier!;
  }

  /// Para usar dentro de callbacks (botones): no suscribe a cambios.
  static AppControlador leer(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No se encontró AppScope en el árbol de widgets');
    return scope!.notifier!;
  }
}
