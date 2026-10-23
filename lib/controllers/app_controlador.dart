import 'package:flutter/foundation.dart';

import '../datasources/base_datos_local.dart';
import '../models/actividad.dart';
import '../models/cuenta.dart';
import '../models/metodo_pago.dart';
import '../models/notificacion.dart';
import '../models/pago.dart';
import '../models/reporte_fuga.dart';
import '../models/resumen_admin.dart';
import '../models/solicitud.dart';
import '../models/usuario.dart';
import '../models/zona.dart';

/// Estado global de la app: sesión, pestaña actual y todas las operaciones.
class AppControlador extends ChangeNotifier {
  AppControlador({BaseDatosLocal? baseDatos})
      : _bd = baseDatos ?? BaseDatosLocal();

  final BaseDatosLocal _bd;

  Usuario? _usuario;
  Cuenta? _cuenta;
  int _pestana = 0;
  bool _esAdmin = false;

  int _consecutivoPago = 208451;
  int _consecutivoSolicitud = 1041;
  int _consecutivoReporte = 3020;

  // ---------------------------------------------------------------- lectura

  List<Zona> get zonas => _bd.zonas;
  bool get sesionActiva => _usuario != null;
  Usuario get usuario => _usuario!;
  Cuenta get cuenta => _cuenta!;
  Zona get zona => _bd.zonaPorId(usuario.zonaId);
  int get pestana => _pestana;

  bool existeUsuario(String numero) => _bd.existeUsuario(numero.trim());

  // ----------------------------------------------------------- navegación

  void irAPestana(int indice) {
    if (indice == _pestana) return;
    _pestana = indice;
    notifyListeners();
  }

  // --------------------------------------------------------------- sesión

  /// Devuelve `null` si todo salió bien, o el mensaje de error.
  String? iniciarSesion(String numero, String password) {
    final encontrado = _bd.usuario(numero.trim());
    if (encontrado == null || encontrado.password != password) {
      return 'Número de contrato o contraseña incorrectos.';
    }
    _abrirSesion(encontrado);
    return null;
  }

  /// Da de alta un contrato nuevo y abre sesión. Devuelve el error, si hay.
  String? registrar({
    required String numero,
    required String familia,
    required String password,
    required String pin,
    required String zonaId,
  }) {
    final limpio = numero.trim();
    if (limpio.length < 5 || limpio.length > 10) {
      return 'El número de contrato debe tener de 5 a 10 dígitos.';
    }
    if (_bd.existeUsuario(limpio)) {
      return 'Ese número de contrato ya está registrado.';
    }
    if (pin.length != 4) {
      return 'El PIN debe tener 4 dígitos.';
    }
    final nuevo = Usuario(
      numero: limpio,
      familia: familia.trim(),
      password: password,
      pin: pin,
      zonaId: zonaId,
    );
    _bd.guardarUsuario(nuevo);
    _bd.guardarCuenta(limpio, _bd.crearCuentaNueva());
    _abrirSesion(nuevo);
    return null;
  }

  void cerrarSesion() {
    _usuario = null;
    _cuenta = null;
    _esAdmin = false;
    _pestana = 0;
    notifyListeners();
  }

  void _abrirSesion(Usuario u) {
    _usuario = u;
    _cuenta = _bd.cuenta(u.numero);
    _pestana = 0;
    notifyListeners();
  }

  // ------------------------------------------------------------ seguridad

  bool validarPin(String pin) => usuario.pin == pin;

  String? cambiarPin({required String actual, required String nuevo}) {
    if (!validarPin(actual)) return 'El PIN actual no es correcto.';
    if (nuevo.length != 4) return 'El PIN nuevo debe tener 4 dígitos.';
    _guardarUsuario(usuario.copyWith(pin: nuevo));
    return null;
  }

  void cambiarZona(String zonaId) {
    _guardarUsuario(usuario.copyWith(zonaId: zonaId));
  }

  void _guardarUsuario(Usuario u) {
    _usuario = u;
    _bd.guardarUsuario(u);
    notifyListeners();
  }

  // ---------------------------------------------------------------- pagos

  void agregarMetodo({required String marca, required String ultimos4}) {
    cuenta.metodos.add(MetodoPago(marca: marca, ultimos4: ultimos4));
    notifyListeners();
  }

  /// Registra el pago completo del saldo. No usa ninguna API:
  /// queda como "Pago realizado en local".
  Pago pagar(MetodoPago metodo) => _cobrar(usuario, cuenta, metodo);

  Pago _cobrar(Usuario u, Cuenta c, MetodoPago metodo) {
    final monto = c.saldo;
    assert(monto > 0, 'No hay saldo por pagar');
    _consecutivoPago++;
    final ahora = DateTime.now();
    final pago = Pago(
      folio: 'AGP-$_consecutivoPago',
      fecha: ahora,
      monto: monto,
      metodo: metodo,
      contrato: u.contrato,
    );
    for (final f in c.facturas) {
      f.pagada = true;
    }
    c.pagos.insert(0, pago);
    c.actividad.insert(
      0,
      Actividad(tipo: TipoActividad.pago, titulo: 'Pago recibido', fecha: ahora),
    );
    c.notificaciones.insert(
      0,
      Notificacion(tipo: TipoNotificacion.pago, titulo: 'Pago confirmado', fecha: ahora),
    );
    notifyListeners();
    return pago;
  }

  // ---------------------------------------------------------- solicitudes

  Solicitud enviarSolicitud({
    required TipoSolicitud tipo,
    required String direccion,
    required String notas,
  }) {
    _consecutivoSolicitud++;
    final ahora = DateTime.now();
    final solicitud = Solicitud(
      folio: 'SOL-$_consecutivoSolicitud',
      contrato: usuario.contrato,
      tipo: tipo,
      direccion: direccion.trim(),
      notas: notas.trim(),
      fecha: ahora,
    );
    final c = cuenta;
    c.solicitudActiva = solicitud;
    c.actividad.insert(
      0,
      Actividad(tipo: TipoActividad.solicitud, titulo: '${tipo.etiqueta}: solicitud enviada', fecha: ahora),
    );
    c.notificaciones.insert(
      0,
      Notificacion(tipo: TipoNotificacion.solicitud, titulo: 'Solicitud recibida (${solicitud.folio})', fecha: ahora),
    );
    notifyListeners();
    return solicitud;
  }

  /// Solo para demostración: avanza un paso el seguimiento de la solicitud.
  void avanzarSolicitud() => _avanzar(cuenta);

  void _avanzar(Cuenta c) {
    final s = c.solicitudActiva;
    if (s == null || s.completada) return;
    s.estado++;
    final titulo = switch (s.estado) {
      2 => 'Solicitud en revisión',
      3 => 'Servicio programado',
      _ => 'Servicio completado',
    };
    c.notificaciones.insert(
      0,
      Notificacion(tipo: TipoNotificacion.solicitud, titulo: titulo, fecha: DateTime.now()),
    );
    notifyListeners();
  }

  // -------------------------------------------------------------- reportes

  ReporteFuga enviarReporte({
    required String descripcion,
    required double latitud,
    required double longitud,
    required bool conFoto,
  }) {
    _consecutivoReporte++;
    final ahora = DateTime.now();
    final reporte = ReporteFuga(
      folio: 'REP-$_consecutivoReporte',
      contrato: usuario.contrato,
      descripcion: descripcion.trim(),
      latitud: latitud,
      longitud: longitud,
      conFoto: conFoto,
      fecha: ahora,
    );
    final c = cuenta;
    c.reportes.insert(0, reporte);
    c.actividad.insert(
      0,
      Actividad(tipo: TipoActividad.fuga, titulo: 'Reporte de fuga enviado', fecha: ahora),
    );
    c.notificaciones.insert(
      0,
      Notificacion(tipo: TipoNotificacion.fuga, titulo: 'Reporte de fuga recibido', fecha: ahora),
    );
    notifyListeners();
    return reporte;
  }

  // -------------------------------------------------------- notificaciones

  void marcarLeida(Notificacion notificacion) {
    if (notificacion.leida) return;
    notificacion.leida = true;
    notifyListeners();
  }

  void marcarTodasLeidas() {
    for (final n in cuenta.notificaciones) {
      n.leida = true;
    }
    notifyListeners();
  }

  // ---------------------------------------------------------- administrador

  static const String _adminUsuario = 'admin';
  static const String _adminPassword = 'admin2026';

  bool get esAdmin => _esAdmin;

  /// Devuelve `null` si todo salió bien, o el mensaje de error.
  String? iniciarSesionAdmin(String usuarioAdmin, String password) {
    if (usuarioAdmin.trim().toLowerCase() != _adminUsuario ||
        password != _adminPassword) {
      return 'Usuario o contraseña de administrador incorrectos.';
    }
    _usuario = null;
    _cuenta = null;
    _esAdmin = true;
    _pestana = 0;
    notifyListeners();
    return null;
  }

  List<Usuario> get clientes => _bd.usuarios;

  Cuenta cuentaDe(Usuario cliente) => _bd.cuenta(cliente.numero)!;

  Zona zonaDe(Usuario cliente) => _bd.zonaPorId(cliente.zonaId);

  Usuario? clientePorContrato(String contrato) => _bd.usuarioPorContrato(contrato);

  List<Pago> get todosLosPagos {
    final lista = <Pago>[
      for (final u in clientes) ...cuentaDe(u).pagos,
    ];
    lista.sort((a, b) => b.fecha.compareTo(a.fecha));
    return lista;
  }

  List<ReporteFuga> get todosLosReportes {
    final lista = <ReporteFuga>[
      for (final u in clientes) ...cuentaDe(u).reportes,
    ];
    lista.sort((a, b) {
      if (a.atendido != b.atendido) return a.atendido ? 1 : -1;
      return b.fecha.compareTo(a.fecha);
    });
    return lista;
  }

  List<Solicitud> get todasLasSolicitudes {
    final lista = <Solicitud>[];
    for (final u in clientes) {
      final s = cuentaDe(u).solicitudActiva;
      if (s != null) lista.add(s);
    }
    lista.sort((a, b) {
      if (a.completada != b.completada) return a.completada ? 1 : -1;
      return b.fecha.compareTo(a.fecha);
    });
    return lista;
  }

  ResumenAdmin get resumen {
    var porCobrar = 0.0;
    var recaudado = 0.0;
    var pagos = 0;
    var conAdeudo = 0;
    final porZona = <ResumenZona>[];

    for (final z in zonas) {
      var n = 0;
      var zonaPorCobrar = 0.0;
      var zonaRecaudado = 0.0;
      for (final u in clientes) {
        if (u.zonaId != z.id) continue;
        final c = cuentaDe(u);
        n++;
        zonaPorCobrar += c.saldo;
        for (final p in c.pagos) {
          zonaRecaudado += p.monto;
        }
      }
      porZona.add(ResumenZona(
        zona: z,
        clientes: n,
        porCobrar: zonaPorCobrar,
        recaudado: zonaRecaudado,
      ));
    }

    for (final u in clientes) {
      final c = cuentaDe(u);
      porCobrar += c.saldo;
      if (c.hayAdeudo) conAdeudo++;
      pagos += c.pagos.length;
      for (final p in c.pagos) {
        recaudado += p.monto;
      }
    }

    return ResumenAdmin(
      clientes: clientes.length,
      clientesConAdeudo: conAdeudo,
      porCobrar: porCobrar,
      recaudado: recaudado,
      pagos: pagos,
      reportesPendientes: todosLosReportes.where((r) => !r.atendido).length,
      solicitudesEnProceso: todasLasSolicitudes.where((s) => !s.completada).length,
      porZona: porZona,
    );
  }

  /// El cliente paga en ventanilla: el administrador registra el pago.
  Pago? registrarPagoEnCaja(Usuario cliente) {
    final c = cuentaDe(cliente);
    if (!c.hayAdeudo) return null;
    return _cobrar(cliente, c, MetodoPago.efectivo);
  }

  void avanzarSolicitudDe(String contrato) {
    final c = _bd.cuentaPorContrato(contrato);
    if (c != null) _avanzar(c);
  }

  void marcarReporteAtendido(ReporteFuga reporte) {
    if (reporte.atendido) return;
    reporte.atendido = true;
    _bd.cuentaPorContrato(reporte.contrato)?.notificaciones.insert(
          0,
          Notificacion(
            tipo: TipoNotificacion.fuga,
            titulo: 'Tu reporte ${reporte.folio} fue atendido',
            fecha: DateTime.now(),
          ),
        );
    notifyListeners();
  }

  String? crearZona({
    required String municipio,
    required String nombre,
    required double latitud,
    required double longitud,
  }) {
    final m = municipio.trim();
    final n = nombre.trim();
    if (m.isEmpty || n.isEmpty) return 'Escribe el municipio y el nombre de la zona.';
    final repetida = zonas.any(
      (z) =>
          z.municipio.toLowerCase() == m.toLowerCase() &&
          z.nombre.toLowerCase() == n.toLowerCase(),
    );
    if (repetida) return 'Esa zona ya existe.';
    final limpio = '$m-$n'.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    _bd.agregarZona(Zona(
      id: 'z${zonas.length + 1}-$limpio',
      municipio: m,
      nombre: n,
      latitud: latitud,
      longitud: longitud,
    ));
    notifyListeners();
    return null;
  }

  /// Manda un aviso a todos los clientes o solo a los de una zona.
  /// Devuelve cuántos clientes lo recibieron.
  int enviarAviso({required String titulo, String? zonaId}) {
    var enviados = 0;
    final ahora = DateTime.now();
    for (final u in clientes) {
      if (zonaId != null && u.zonaId != zonaId) continue;
      cuentaDe(u).notificaciones.insert(
            0,
            Notificacion(
              tipo: TipoNotificacion.recordatorio,
              titulo: titulo.trim(),
              fecha: ahora,
            ),
          );
      enviados++;
    }
    notifyListeners();
    return enviados;
  }
}
