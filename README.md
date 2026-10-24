# AquaGeo

App móvil en Flutter para la gestión del servicio de agua potable: consulta de saldo y facturación, pago en línea con PIN, solicitud de pipas y nuevas tomas, reporte de fugas con ubicación, notificaciones y un panel de administración.

---

## 1. Descripción breve

**AquaGeo** conecta a las familias con su organismo operador de agua. Cada familia entra con su **número de contrato** (de 5 a 10 dígitos, único) y una contraseña, y desde su teléfono puede:

- ver su **saldo**, sus facturas y su consumo mensual;
- **pagar en línea** eligiendo un método de pago y confirmando con un **PIN**; el pago queda registrado como *"Pago realizado en local"* (sin conexión a bancos por ahora) y genera un **comprobante**;
- pedir una **pipa** o una **nueva toma** y seguir el avance de la solicitud;
- **reportar una fuga** con ubicación y fotografía (simuladas en esta versión);
- recibir **notificaciones** y avisos del organismo.

El **administrador** supervisa clientes, cobranza, solicitudes y fugas, registra pagos en caja, da de alta zonas y envía avisos.

**Datos:** viven en memoria (`BaseDatosLocal`), por lo que se reinician al cerrar la app. No hay servidor ni API todavía.

---

## 2. Los 3 tipos de usuario y sus dashboards

| Usuario | Cómo entra | Dashboard |
|---|---|---|
| **Cliente (familia)** | Contrato + contraseña (ej. `10432` / `agua123`) | **Inicio**: saludo, saldo, gráfica de consumo, accesos rápidos y actividad reciente |
| **Administrador** | *Acceso administrador* en el login (`admin` / `admin2026`) | **Panel de control**: recaudado, por cobrar, clientes con adeudo, fugas y solicitudes pendientes, cobranza por zona y últimos pagos |
| **Operador / Inspector** | *(por definir)* | *(por definir)* |

> **PENDIENTE:** el tercer tipo de usuario aún no está implementado. Completa esta fila (o quítala) antes de entregar.

### Cliente
- **Pestañas:** Inicio · Pagos · Solicitudes · Reportes · Perfil.
- **Formularios:** pago en línea (con PIN), nueva solicitud, reportar fuga, agregar método de pago, cambiar PIN, registro de cuenta nueva.
- **Listas:** facturas y pagos, mis reportes, notificaciones.

### Administrador
- **Pestañas:** Panel · Clientes · Solicitudes · Fugas · Más.
- **Formularios:** agregar zona, enviar aviso (a todos o por zona), registrar pago en caja.
- **Listas:** clientes (con búsqueda y filtros), solicitudes, reportes de fuga, pagos, zonas.

### Datos de prueba

| Rol | Usuario | Contraseña | PIN |
|---|---|---|---|
| Cliente (con adeudo) | `10432` | `agua123` | `1234` |
| Cliente | `2045871` | `pozo2024` | `4321` |
| Cliente (sin adeudo) | `9900123456` | `agua2026` | `5678` |
| Cliente | `3071188` | `rio12345` | `1111` |
| Cliente | `48210` | `sol45678` | `2222` |
| Administrador | `admin` | `admin2026` | — |

---

## 3. Manejo de estado elegido (y por qué)

**Elegido: `ChangeNotifier` + `InheritedNotifier`** (solo Flutter, sin paquetes externos).

- `AppControlador extends ChangeNotifier` concentra el estado compartido: sesión, pestaña activa, cuenta del cliente y todas las operaciones (iniciar sesión, registrar, pagar, validar PIN, enviar solicitudes y reportes, y las acciones del administrador). Cada vez que algo cambia llama a `notifyListeners()`.
- `AppScope extends InheritedNotifier<AppControlador>` lo entrega a todo el árbol de widgets:
  - `AppScope.of(context)` se usa dentro de `build`, y la pantalla **se redibuja sola** cuando el estado cambia;
  - `AppScope.leer(context)` se usa dentro de botones y callbacks, sin suscribirse a cambios.
- El **estado local de cada pantalla** (campos de formulario, filtros, texto de búsqueda) se queda en `StatefulWidget`, porque no le importa al resto de la app.
- Las pestañas usan `IndexedStack`, así que cada una **conserva su estado** al cambiar entre ellas.

**Por qué esta opción**

1. **Es lo que ya trae Flutter:** no hay dependencias que mantener ni versiones que choquen.
2. **La app es de tamaño mediano** y tiene un solo "dueño" del estado (una sesión a la vez), así que un controlador central es suficiente y fácil de seguir.
3. **La lógica queda fuera de la interfaz:** `AppControlador` se puede probar sin dibujar pantallas (`test/controlador_test.dart` y `test/admin_test.dart`).
4. **Cambiar a otra solución después es sencillo:** si la app crece (varios módulos, datos remotos), el controlador se puede pasar a Provider o Riverpod casi sin tocar las pantallas.

**Contras:** no hay separación por módulos (un solo controlador crece), y no hay persistencia: al conectar un servidor habría que separar la capa de datos (`datasources/`) y manejar estados de carga y error.

---

## 4. Cómo ejecutar la app

**Requisitos:** Flutter SDK instalado (el proyecto usa Dart `^3.13.2`; revisa con `flutter doctor`) y un emulador de Android, un teléfono con depuración USB, Windows de escritorio o Chrome.

```bash
# 1. Entra a la carpeta del proyecto (la que tiene pubspec.yaml)
cd aquageo

# 2. Descarga dependencias
flutter pub get

# 3. (Opcional) abre el emulador
flutter emulators
flutter emulators --launch medium_phone

# 4. Corre la app
flutter devices
flutter run
# o en un destino concreto:
flutter run -d windows
flutter run -d chrome

# 5. Pruebas automáticas
flutter test
```

**Estructura de carpetas**

```
lib/
  main.dart                   arranque (login o app según la sesión)
  theme/                      colores, degradados y estilos
  models/                     Usuario, Zona, Cuenta, Pago, Solicitud...
  datasources/                base de datos local en memoria
  controllers/                AppControlador y AppScope (estado)
  view/                       pantallas del cliente
  view/admin/                 pantallas del administrador
  widgets/                    componentes reutilizables
  utils/                      formatos de moneda y fecha
test/                         pruebas del controlador, login y administrador
```

**Limitaciones de esta versión:** datos en memoria (se pierden al cerrar), pago sin conexión a bancos, y GPS, cámara y PDF simulados.

---

## 5. Capturas de pantalla

### 1. Splashscreen

> ⚠️ Pendiente: la app todavía no tiene splashscreen.

### 2. Autenticación

**Login con validación visible** (campo vacío, contrato de menos de 5 dígitos y credenciales incorrectas):

<img src="docs/capturas/02_login_vacio.png" alt="Login" width="240"> <img src="docs/capturas/02_login_validacion_contrato.png" alt="Validación del contrato" width="240"> <img src="docs/capturas/02_login_credenciales_incorrectas.png" alt="Credenciales incorrectas" width="240">

**Acceso administrador:**

<img src="docs/capturas/04_acceso_administrador.png" alt="Acceso administrador" width="240">

**Registro:**

> ⚠️ Pendiente: captura de *Crear cuenta nueva* (y selección de rol, que aún no existe).

### 3. Dashboards (uno por usuario)

**Administrador: Panel de control**

<img src="docs/capturas/04_dashboard_admin.png" alt="Dashboard administrador" width="240">

**Cliente: Inicio**

<img src="docs/capturas/05_dashboard_cliente.png" alt="Dashboard cliente" width="240">

**Operador / Invitado**

> ⚠️ Pendiente: tercer rol sin implementar.

### 4. Listas

**Lista principal con datos dinámicos** (clientes del administrador):

<img src="docs/capturas/07_lista_clientes.png" alt="Lista de clientes" width="240">

**Lista secundaria o detalle** (saldo y facturas de un contrato):

<img src="docs/capturas/08_saldo_facturacion.png" alt="Saldo y facturación" width="240"> <img src="docs/capturas/15_solicitudes_seguimiento.png" alt="Seguimiento de solicitudes" width="240">

**Estado vacío** ("No hay clientes con esos filtros"):

<img src="docs/capturas/09_estado_vacio.png" alt="Estado vacío" width="240">

### 5. Formularios específicos por rol

**Cliente:** nueva solicitud, reportar fuga y pago en línea.

<img src="docs/capturas/10_form_solicitud.png" alt="Nueva solicitud" width="240"> <img src="docs/capturas/10_form_reporte_fuga.png" alt="Reportar fuga" width="240"> <img src="docs/capturas/14_flujo_pago.png" alt="Pago en línea" width="240">

**Configuración del cliente** (zona, métodos de pago, PIN):

<img src="docs/capturas/16_perfil.png" alt="Perfil" width="240"> <img src="docs/capturas/16_perfil_zona.png" alt="Zona de servicio" width="240">

**Administrador:** agregar zona / enviar aviso.

> ⚠️ Pendiente: captura del formulario del administrador (*Más → Zonas → Agregar zona*).

**Operador:** ⚠️ Pendiente (tercer rol).

### 6. Evidencia funcional

**App corriendo en el equipo** (Android Studio + emulador):

<img src="docs/capturas/13_dispositivo.jpg" alt="Dispositivo" width="700">

**Flujo completo:** login → inicio → saldo y facturación → pagar en línea → pago exitoso.

<img src="docs/capturas/02_login_vacio.png" alt="1. Login" width="200"> <img src="docs/capturas/05_dashboard_cliente.png" alt="2. Inicio" width="200"> <img src="docs/capturas/08_saldo_facturacion.png" alt="3. Facturación" width="200"> <img src="docs/capturas/14_flujo_pago.png" alt="4. Pagar en línea" width="200"> <img src="docs/capturas/14_flujo_pago_exitoso.png" alt="5. Pago exitoso" width="200">
