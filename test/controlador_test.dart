import 'package:aquageo/controllers/app_controlador.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sesión', () {
    test('entra con el usuario demo', () {
      final app = AppControlador();
      expect(app.iniciarSesion('10432', 'agua123'), isNull);
      expect(app.sesionActiva, isTrue);
      expect(app.usuario.saludoFamilia, 'Familia Sánchez');
    });

    test('rechaza contraseña incorrecta', () {
      final app = AppControlador();
      expect(app.iniciarSesion('10432', 'mal'), isNotNull);
      expect(app.sesionActiva, isFalse);
    });

    test('cerrar sesión limpia el estado', () {
      final app = AppControlador()..iniciarSesion('10432', 'agua123');
      app.cerrarSesion();
      expect(app.sesionActiva, isFalse);
    });
  });

  group('Registro', () {
    test('crea una cuenta nueva con cuota de contratación', () {
      final app = AppControlador();
      final error = app.registrar(
        numero: '55555',
        familia: 'Torres',
        password: 'secreto1',
        pin: '2468',
        zonaId: app.zonas.first.id,
      );
      expect(error, isNull);
      expect(app.sesionActiva, isTrue);
      expect(app.cuenta.saldo, 150);
    });

    test('no permite un contrato repetido', () {
      final app = AppControlador();
      final error = app.registrar(
        numero: '10432',
        familia: 'Otra',
        password: 'secreto1',
        pin: '1111',
        zonaId: app.zonas.first.id,
      );
      expect(error, isNotNull);
    });

    test('valida de 5 a 10 dígitos', () {
      final app = AppControlador();
      expect(
        app.registrar(
          numero: '123',
          familia: 'X',
          password: 'secreto1',
          pin: '1111',
          zonaId: app.zonas.first.id,
        ),
        isNotNull,
      );
    });
  });

  group('Pagos', () {
    test('el PIN correcto se valida y el incorrecto no', () {
      final app = AppControlador()..iniciarSesion('10432', 'agua123');
      expect(app.validarPin('1234'), isTrue);
      expect(app.validarPin('0000'), isFalse);
    });

    test('pagar deja saldo en cero y guarda el comprobante', () {
      final app = AppControlador()..iniciarSesion('10432', 'agua123');
      final antes = app.cuenta.saldo;
      expect(antes, 486);
      final pago = app.pagar(app.cuenta.metodos.first);
      expect(pago.monto, antes);
      expect(pago.estado, 'Pago realizado en local');
      expect(app.cuenta.saldo, 0);
      expect(app.cuenta.pagos.length, 1);
    });
  });

  group('Solicitudes y reportes', () {
    test('la solicitud avanza hasta completarse', () {
      final app = AppControlador()..iniciarSesion('10432', 'agua123');
      final s = app.enviarSolicitud(
        tipo: app.cuenta.solicitudActiva!.tipo,
        direccion: 'Calle 1 #2',
        notas: '',
      );
      expect(s.completada, isFalse);
      while (!s.completada) {
        app.avanzarSolicitud();
      }
      expect(s.completada, isTrue);
    });

    test('enviar un reporte lo agrega a la lista', () {
      final app = AppControlador()..iniciarSesion('10432', 'agua123');
      app.enviarReporte(
        descripcion: 'Fuga en la banqueta',
        latitud: 21.1,
        longitud: -101.6,
        conFoto: true,
      );
      expect(app.cuenta.reportes.length, 1);
    });
  });
}
