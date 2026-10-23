import '../models/actividad.dart';
import '../models/cuenta.dart';
import '../models/metodo_pago.dart';
import '../models/notificacion.dart';
import '../models/pago.dart';
import '../models/reporte_fuga.dart';
import '../models/solicitud.dart';
import '../models/usuario.dart';
import '../models/zona.dart';

/// "Base de datos" en memoria. Sustituye a una API/BD real por ahora:
/// los datos viven mientras la app está abierta.
class BaseDatosLocal {
  BaseDatosLocal() {
    _sembrar();
  }

  final List<Zona> _zonas = [
    const Zona(id: 'dh-centro', municipio: 'Dolores Hidalgo', nombre: 'Centro', latitud: 21.1561, longitud: -100.9317),
    const Zona(id: 'dh-norte', municipio: 'Dolores Hidalgo', nombre: 'Zona Norte', latitud: 21.1702, longitud: -100.9305),
    const Zona(id: 'dh-sur', municipio: 'Dolores Hidalgo', nombre: 'Zona Sur', latitud: 21.1405, longitud: -100.9330),
    const Zona(id: 'slp-centro', municipio: 'San Luis de la Paz', nombre: 'Centro', latitud: 21.2989, longitud: -100.5157),
    const Zona(id: 'sma-centro', municipio: 'San Miguel de Allende', nombre: 'Centro', latitud: 20.9144, longitud: -100.7452),
    const Zona(id: 'sma-oriente', municipio: 'San Miguel de Allende', nombre: 'Zona Oriente', latitud: 20.9170, longitud: -100.7205),
  ];

  final Map<String, Usuario> _usuarios = {};
  final Map<String, Cuenta> _cuentas = {};

  List<Zona> get zonas => _zonas;

  void agregarZona(Zona zona) => _zonas.add(zona);

  List<Usuario> get usuarios {
    final lista = _usuarios.values.toList();
    lista.sort((a, b) => a.numero.compareTo(b.numero));
    return lista;
  }

  static String _numeroDe(String contrato) =>
      contrato.startsWith('AG-') ? contrato.substring(3) : contrato;

  Usuario? usuarioPorContrato(String contrato) => _usuarios[_numeroDe(contrato)];

  Cuenta? cuentaPorContrato(String contrato) => _cuentas[_numeroDe(contrato)];

  Zona zonaPorId(String id) =>
      _zonas.firstWhere((z) => z.id == id, orElse: () => _zonas.first);

  bool existeUsuario(String numero) => _usuarios.containsKey(numero);

  Usuario? usuario(String numero) => _usuarios[numero];

  Cuenta? cuenta(String numero) => _cuentas[numero];

  void guardarUsuario(Usuario usuario) => _usuarios[usuario.numero] = usuario;

  void guardarCuenta(String numero, Cuenta cuenta) => _cuentas[numero] = cuenta;

  /// Cuenta para un contrato recién dado de alta: sin historial,
  /// con una cuota de contratación pendiente para poder probar el pago.
  Cuenta crearCuentaNueva() {
    final ahora = DateTime.now();
    return Cuenta(
      facturas: [Factura(periodo: 'Cuota de contratación', monto: 150.00)],
      metodos: [const MetodoPago(marca: 'Visa', ultimos4: '4581')],
      notificaciones: [
        Notificacion(
          tipo: TipoNotificacion.recordatorio,
          titulo: 'Bienvenido a AquaGeo',
          fecha: ahora,
        ),
      ],
      actividad: [
        Actividad(
          tipo: TipoActividad.solicitud,
          titulo: 'Contrato dado de alta',
          fecha: ahora,
        ),
      ],
    );
  }

  void _sembrar() {
    final ahora = DateTime.now();

    // Usuario de prueba: contrato 10432 / contraseña agua123 / PIN 1234
    guardarUsuario(const Usuario(
      numero: '10432',
      familia: 'Sánchez',
      password: 'agua123',
      pin: '1234',
      zonaId: 'dh-centro',
    ));
    guardarCuenta(
      '10432',
      Cuenta(
        consumos: [
          const ConsumoMes('Abr', 340),
          const ConsumoMes('May', 420),
          const ConsumoMes('Jun', 290),
          const ConsumoMes('Jul', 512),
          const ConsumoMes('Ago', 398),
          const ConsumoMes('Sep', 486),
        ],
        facturas: [
          Factura(periodo: 'Septiembre', monto: 486.00),
          Factura(periodo: 'Agosto', monto: 398.00, pagada: true),
          Factura(periodo: 'Julio', monto: 512.00, pagada: true),
        ],
        metodos: [const MetodoPago(marca: 'Visa', ultimos4: '4581')],
        notificaciones: [
          Notificacion(tipo: TipoNotificacion.fuga, titulo: 'Reporte de fuga recibido', fecha: ahora.subtract(const Duration(hours: 3))),
          Notificacion(tipo: TipoNotificacion.solicitud, titulo: 'Pipa programada', fecha: ahora.subtract(const Duration(hours: 9))),
          Notificacion(tipo: TipoNotificacion.pago, titulo: 'Pago confirmado', fecha: ahora.subtract(const Duration(days: 30)), leida: true),
          Notificacion(tipo: TipoNotificacion.lectura, titulo: 'Nueva lectura', fecha: ahora.subtract(const Duration(days: 33)), leida: true),
          Notificacion(tipo: TipoNotificacion.recordatorio, titulo: 'Recordatorio de pago', fecha: ahora.subtract(const Duration(days: 36)), leida: true),
        ],
        actividad: [
          Actividad(tipo: TipoActividad.lectura, titulo: 'Nueva lectura registrada', fecha: ahora.subtract(const Duration(days: 2))),
          Actividad(tipo: TipoActividad.pago, titulo: 'Pago recibido', fecha: ahora.subtract(const Duration(days: 30))),
        ],
        solicitudActiva: Solicitud(
          folio: 'SOL-1041',
          contrato: 'AG-10432',
          tipo: TipoSolicitud.pipa,
          direccion: 'Calle Hidalgo 24, Centro',
          notas: '',
          fecha: ahora.subtract(const Duration(days: 1)),
          estado: 2,
        ),
      ),
    );

    // Contrato de 7 dígitos: contraseña pozo2024 / PIN 4321
    guardarUsuario(const Usuario(
      numero: '2045871',
      familia: 'Ramírez',
      password: 'pozo2024',
      pin: '4321',
      zonaId: 'sma-centro',
    ));
    guardarCuenta(
      '2045871',
      Cuenta(
        consumos: [
          const ConsumoMes('Abr', 210),
          const ConsumoMes('May', 260),
          const ConsumoMes('Jun', 240),
          const ConsumoMes('Jul', 330),
          const ConsumoMes('Ago', 300),
          const ConsumoMes('Sep', 352.5),
        ],
        facturas: [
          Factura(periodo: 'Septiembre', monto: 352.50),
          Factura(periodo: 'Agosto', monto: 300.00, pagada: true),
        ],
        metodos: [const MetodoPago(marca: 'Mastercard', ultimos4: '9920')],
        notificaciones: [
          Notificacion(tipo: TipoNotificacion.recordatorio, titulo: 'Recordatorio de pago', fecha: ahora.subtract(const Duration(days: 1))),
        ],
        actividad: [
          Actividad(tipo: TipoActividad.lectura, titulo: 'Nueva lectura registrada', fecha: ahora.subtract(const Duration(days: 3))),
        ],
      ),
    );

    // Contrato de 10 dígitos, sin adeudo: contraseña agua2026 / PIN 5678
    guardarUsuario(const Usuario(
      numero: '9900123456',
      familia: 'Gutiérrez',
      password: 'agua2026',
      pin: '5678',
      zonaId: 'slp-centro',
    ));
    guardarCuenta(
      '9900123456',
      Cuenta(
        consumos: [
          const ConsumoMes('Abr', 180),
          const ConsumoMes('May', 200),
          const ConsumoMes('Jun', 190),
          const ConsumoMes('Jul', 260),
          const ConsumoMes('Ago', 240),
          const ConsumoMes('Sep', 230),
        ],
        facturas: [
          Factura(periodo: 'Septiembre', monto: 230.00, pagada: true),
          Factura(periodo: 'Agosto', monto: 240.00, pagada: true),
        ],
        metodos: [const MetodoPago(marca: 'Visa', ultimos4: '1177')],
        notificaciones: [
          Notificacion(tipo: TipoNotificacion.pago, titulo: 'Pago confirmado', fecha: ahora.subtract(const Duration(days: 5)), leida: true),
        ],
        actividad: [
          Actividad(tipo: TipoActividad.pago, titulo: 'Pago recibido', fecha: ahora.subtract(const Duration(days: 5))),
        ],
      ),
    );

    // Contrato 2045871: solicitud de nueva toma en proceso
    cuenta('2045871')!.solicitudActiva = Solicitud(
      folio: 'SOL-1038',
      contrato: 'AG-2045871',
      tipo: TipoSolicitud.toma,
      direccion: 'Callejón del Río 7, Centro',
      notas: 'Casa nueva, sin toma.',
      fecha: ahora.subtract(const Duration(days: 4)),
    );

    // Dos contratos más para que el administrador tenga qué revisar
    guardarUsuario(const Usuario(
      numero: '3071188',
      familia: 'Hernández',
      password: 'rio12345',
      pin: '1111',
      zonaId: 'dh-norte',
    ));
    guardarCuenta(
      '3071188',
      _cuentaBasica(
        const [260, 280, 300, 310, 275, 275],
        [
          Factura(periodo: 'Septiembre', monto: 275.00),
          Factura(periodo: 'Agosto', monto: 260.00),
        ],
        const MetodoPago(marca: 'Visa', ultimos4: '3302'),
      ),
    );
    guardarUsuario(const Usuario(
      numero: '48210',
      familia: 'Morales',
      password: 'sol45678',
      pin: '2222',
      zonaId: 'sma-oriente',
    ));
    guardarCuenta(
      '48210',
      _cuentaBasica(
        const [150, 170, 160, 190, 180, 310],
        [Factura(periodo: 'Septiembre', monto: 310.00, pagada: true)],
        const MetodoPago(marca: 'Mastercard', ultimos4: '6015'),
      ),
    );

    // Pagos anteriores (historial que ve el administrador)
    const visa = MetodoPago(marca: 'Visa', ultimos4: '4581');
    cuenta('10432')!.pagos.add(Pago(
      folio: 'AGP-208440',
      fecha: ahora.subtract(const Duration(days: 30)),
      monto: 398,
      metodo: visa,
      contrato: 'AG-10432',
    ));
    cuenta('2045871')!.pagos.add(Pago(
      folio: 'AGP-208441',
      fecha: ahora.subtract(const Duration(days: 31)),
      monto: 300,
      metodo: const MetodoPago(marca: 'Mastercard', ultimos4: '9920'),
      contrato: 'AG-2045871',
    ));
    cuenta('9900123456')!.pagos.add(Pago(
      folio: 'AGP-208442',
      fecha: ahora.subtract(const Duration(days: 5)),
      monto: 230,
      metodo: const MetodoPago(marca: 'Visa', ultimos4: '1177'),
      contrato: 'AG-9900123456',
    ));
    cuenta('48210')!.pagos.add(Pago(
      folio: 'AGP-208443',
      fecha: ahora.subtract(const Duration(days: 2)),
      monto: 310,
      metodo: const MetodoPago(marca: 'Mastercard', ultimos4: '6015'),
      contrato: 'AG-48210',
    ));

    // Reportes de fuga
    cuenta('10432')!.reportes.add(ReporteFuga(
      folio: 'REP-3018',
      contrato: 'AG-10432',
      descripcion: 'Fuga en la banqueta frente al número 24.',
      latitud: 21.1563,
      longitud: -100.9312,
      conFoto: true,
      fecha: ahora.subtract(const Duration(hours: 3)),
    ));
    cuenta('2045871')!.reportes.add(ReporteFuga(
      folio: 'REP-3019',
      contrato: 'AG-2045871',
      descripcion: 'Tubería rota en la esquina de la plaza.',
      latitud: 20.9150,
      longitud: -100.7440,
      conFoto: false,
      fecha: ahora.subtract(const Duration(days: 4)),
      atendido: true,
    ));
  }

  Cuenta _cuentaBasica(
    List<double> consumos,
    List<Factura> facturas,
    MetodoPago metodo,
  ) {
    const meses = ['Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep'];
    return Cuenta(
      consumos: [
        for (var i = 0; i < consumos.length; i++) ConsumoMes(meses[i], consumos[i]),
      ],
      facturas: facturas,
      metodos: [metodo],
      notificaciones: [
        Notificacion(
          tipo: TipoNotificacion.recordatorio,
          titulo: 'Recordatorio de pago',
          fecha: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      actividad: [
        Actividad(
          tipo: TipoActividad.lectura,
          titulo: 'Nueva lectura registrada',
          fecha: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    );
  }
}
