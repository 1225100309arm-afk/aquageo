import 'package:aquageo/controllers/app_controlador.dart';
import 'package:aquageo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Administrador', () {
    test('entra con admin / admin2026 y rechaza otras claves', () {
      final app = AppControlador();
      expect(app.iniciarSesionAdmin('admin', 'mala'), isNotNull);
      expect(app.esAdmin, isFalse);
      expect(app.iniciarSesionAdmin('admin', 'admin2026'), isNull);
      expect(app.esAdmin, isTrue);
      app.cerrarSesion();
      expect(app.esAdmin, isFalse);
    });

    test('el resumen suma clientes, adeudos y pagos', () {
      final app = AppControlador()..iniciarSesionAdmin('admin', 'admin2026');
      final r = app.resumen;
      expect(r.clientes, 5);
      expect(r.clientesConAdeudo, 3);
      expect(r.porCobrar, 486 + 352.5 + 275 + 260);
      expect(r.pagos, 4);
      expect(r.recaudado, 398 + 300 + 230 + 310);
    });

    test('registrar pago en caja deja al cliente sin adeudo', () {
      final app = AppControlador()..iniciarSesionAdmin('admin', 'admin2026');
      final cliente = app.clientes.firstWhere((u) => u.numero == '10432');
      final pago = app.registrarPagoEnCaja(cliente);
      expect(pago, isNotNull);
      expect(pago!.metodo.esEfectivo, isTrue);
      expect(app.cuentaDe(cliente).saldo, 0);
      expect(app.registrarPagoEnCaja(cliente), isNull);
    });

    test('atender un reporte avisa al cliente', () {
      final app = AppControlador()..iniciarSesionAdmin('admin', 'admin2026');
      final antes = app.resumen.reportesPendientes;
      final reporte = app.todosLosReportes.firstWhere((r) => !r.atendido);
      app.marcarReporteAtendido(reporte);
      expect(app.resumen.reportesPendientes, antes - 1);
    });

    test('crear zona valida repetidas y la agrega', () {
      final app = AppControlador()..iniciarSesionAdmin('admin', 'admin2026');
      final total = app.zonas.length;
      expect(
        app.crearZona(municipio: 'Dolores Hidalgo', nombre: 'Centro', latitud: 21, longitud: -100),
        isNotNull,
      );
      expect(
        app.crearZona(municipio: 'Dolores Hidalgo', nombre: 'Zona Poniente', latitud: 21.15, longitud: -100.95),
        isNull,
      );
      expect(app.zonas.length, total + 1);
    });

    test('enviar aviso por zona llega solo a esa zona', () {
      final app = AppControlador()..iniciarSesionAdmin('admin', 'admin2026');
      expect(app.enviarAviso(titulo: 'Corte programado', zonaId: 'dh-centro'), 1);
      expect(app.enviarAviso(titulo: 'Aviso general'), 5);
    });

    test('avanzar solicitud de un cliente la completa', () {
      final app = AppControlador()..iniciarSesionAdmin('admin', 'admin2026');
      final s = app.todasLasSolicitudes.firstWhere((x) => !x.completada);
      while (!s.completada) {
        app.avanzarSolicitudDe(s.contrato);
      }
      expect(s.completada, isTrue);
    });
  });

  testWidgets('acceso administrador desde el login abre el panel', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AquaGeoApp());
    await tester.ensureVisible(find.text('Acceso administrador'));
    await tester.tap(find.text('Acceso administrador'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'admin');
    await tester.enterText(find.byType(TextFormField).at(1), 'admin2026');
    await tester.tap(find.text('Entrar al panel'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Panel de control'), findsOneWidget);
    expect(find.text('Recaudado'), findsOneWidget);
  });
}
