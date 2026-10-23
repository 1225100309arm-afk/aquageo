# AquaGeo · versión 1 (cliente + administrador)

App Flutter para el servicio de agua potable. Todas las pantallas del instrumento
(Login, Inicio, Saldo y facturación, Pago en línea, Comprobante, Solicitudes,
Reportar fuga, Notificaciones) son navegables, con ida y vuelta, más Registro
y Configuración.

## Cuentas de prueba

| Contrato (usuario) | Contraseña | PIN  | Familia   | Saldo     |
|--------------------|------------|------|-----------|-----------|
| `10432`            | `agua123`  | 1234 | Sánchez   | $486.00   |
| `2045871`          | `pozo2024` | 4321 | Ramírez   | $352.50   |
| `9900123456`       | `agua2026` | 5678 | Gutiérrez | sin adeudo|

También puedes crear una cuenta con **Crear cuenta nueva** (contrato de 5 a 10
dígitos, único; zona; contraseña; PIN de 4 dígitos).

## Administrador

En el login, botón **Acceso administrador** → usuario `admin` · contraseña `admin2026`.

| Pestaña | Qué hace |
|---|---|
| Panel | Recaudado, por cobrar, clientes con adeudo, fugas y solicitudes pendientes, cobranza por zona, últimos pagos |
| Clientes | Búsqueda por contrato/familia, filtro con adeudo/al corriente, detalle y **registrar pago en caja** |
| Solicitudes | Todas las pipas/tomas; completar el siguiente paso (le llega aviso al cliente) |
| Fugas | Reportes pendientes/atendidos; **marcar como atendido** (avisa al cliente) |
| Más | Pagos de todos los clientes, alta de **zonas**, **avisos** por zona o generales, cerrar sesión |

Clientes de prueba extra: `3071188 / rio12345` (Hernández) y `48210 / sol45678` (Morales).

## Estructura

```
lib/
  main.dart                  arranque y raíz (login o app según la sesión)
  theme/app_tema.dart        colores, degradados, sombras, estilos de texto
  models/                    Usuario, Zona, Cuenta, Pago, Solicitud, ...
  datasources/
    base_datos_local.dart    "base de datos" en memoria (zonas, usuarios, cuentas)
  controllers/
    app_controlador.dart     lógica: sesión, pagos, PIN, solicitudes, reportes
    app_scope.dart           entrega el controlador a las pantallas
  view/                      pantallas del cliente (login, registro, inicio, ...)
  view/admin/                pantallas del administrador
  widgets/                   componentes reutilizables (tarjetas, botones, PIN, ...)
  utils/formato.dart         moneda y fechas
test/                        pruebas del controlador, login y administrador
```

## Flujos

- **Login**: contrato + contraseña. Botón "Usar" carga la cuenta demo.
- **Registro**: contrato único, apellido, zona de servicio, contraseña y PIN.
- **Zona**: se elige al registrarse y se cambia en *Perfil → Zona de servicio*.
- **Pago**: Pagos → Pagar en línea → elegir método → **PIN** → ventana
  *¡Pago exitoso!* ("Pago realizado en local") → Comprobante.
- **Solicitudes**: pipa o nueva toma, con línea de seguimiento
  (el botón "Avanzar estado (demo)" simula el avance).
- **Reportar fuga**: ubicación, foto y descripción.
- **Perfil**: zona, métodos de pago, cambiar PIN, notificaciones, cerrar sesión.

## Limitaciones de esta versión

- Los datos viven en memoria: al cerrar la app se pierden (no hay servidor ni API).
- El pago **no** se conecta a ningún banco; se registra como pago realizado en local.
- La ubicación (GPS), la cámara y la descarga de PDF están **simuladas**.
- Solo se guardan marca y últimos 4 dígitos de las tarjetas.
- El acceso de administrador es una cuenta fija de demostración (no hay roles reales ni servidor).

## Ejecutar

```
flutter pub get
flutter run
flutter test
```
