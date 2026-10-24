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

<img width="456" height="1042" alt="Captura de pantalla 2026-10-23 131550" src="https://github.com/user-attachments/assets/189337fc-9e49-4131-87de-fce6cd2e59a5" />

| **Administrador** | *Acceso administrador* en el login (`admin` / `admin2026`) | **Panel de control**: recaudado, por cobrar, clientes con adeudo, fugas y solicitudes pendientes, cobranza por zona y últimos pagos |

<img width="475" height="1042" alt="Captura de pantalla 2026-10-23 132141" src="https://github.com/user-attachments/assets/08841072-47a3-4dae-b830-172c4a7325a7" />

| **Operador / Inspector** | *(por definir)* | *(por definir)* |

> **PENDIENTE:** el tercer tipo de usuario aún no está implementado. Completa esta fila (o quítala) antes de entregar.

### Cliente
- **Pestañas:** Inicio · Pagos · Solicitudes · Reportes · Perfil.
- **Formularios:** pago en línea (con PIN), nueva solicitud, reportar fuga, agregar método de pago, cambiar PIN, registro de cuenta nueva.
- **Listas:** facturas y pagos, mis reportes, notificaciones.
<img width="470" height="995" alt="Captura de pantalla 2026-10-23 131912" src="https://github.com/user-attachments/assets/3968f3ab-4852-4cc4-b687-c083359c307f" />
<img width="438" height="976" alt="Captura de pantalla 2026-10-23 200309" src="https://github.com/user-attachments/assets/9518b8ad-0a3d-4aa9-a00e-b6ff0323ea15" />
<img width="485" height="938" alt="Captura de pantalla 2026-10-23 200400" src="https://github.com/user-attachments/assets/113c0c49-f6e5-40e2-abb9-80c68518151a" />



### Administrador
- **Pestañas:** Panel · Clientes · Solicitudes · Fugas · Más.
- **Formularios:** agregar zona, enviar aviso (a todos o por zona), registrar pago en caja.
- **Listas:** clientes (con búsqueda y filtros), solicitudes, reportes de fuga, pagos, zonas.

<img width="487" height="1037" alt="Captura de pantalla 2026-10-23 132152" src="https://github.com/user-attachments/assets/3bef33ec-314e-44a2-ac54-d5a105cdeb5c" />
<img width="452" height="1045" alt="Captura de pantalla 2026-10-23 132204" src="https://github.com/user-attachments/assets/9c1c83dd-7107-4fa4-82d7-936407968fa4" />



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
