# Arquitectura y flujos

## Vision general

El proyecto se divide en dos capas principales:

- Flutter: presenta pantallas, widgets y estado para el turista.
- Spring Boot: expone endpoints REST, valida reglas de negocio y persiste en PostgreSQL.

La integracion actual se mantiene por medio de los endpoints `/api/...` ya existentes.

## Frontend

### Capas principales

- `lib/core`: configuracion, cliente HTTP, manejo de errores y almacenamiento del token.
- `lib/data/models`: modelos que adaptan las respuestas del backend para la UI.
- `lib/data/services`: consumo de endpoints REST.
- `lib/presentation/providers`: estado de pantallas y coordinacion de carga/error/exito.
- `lib/presentation/screens`: flujo visual del usuario.
- `lib/presentation/widgets`: piezas visuales reutilizables.

### Regla de imagenes

Las imagenes de lugares y favoritos pasan por `ImagenTuristica`, que:

- usa URL remota cuando existe;
- muestra placeholder si la URL es `null`;
- muestra placeholder si la URL llega vacia;
- muestra placeholder si falla la descarga;
- evita romper layouts en tarjetas, detalle y guardados.

## Backend

### Capas principales

- `config`: propiedades y configuracion transversal.
- `security`: JWT, filtros y reglas de acceso.
- `exception`: manejo global de errores para respuestas consistentes.
- `module/*/controller`: endpoints REST por dominio.
- `module/*/service`: logica de negocio.
- `module/*/repository`: acceso a datos.
- `module/*/entity`: representacion persistente en PostgreSQL.
- `module/*/dto`: contratos internos de entrada y salida.

## Flujos clave

### 1. Registro de usuario

- Entrada: formulario Flutter en `RegisterScreen`.
- Endpoint: `POST /api/auth/register`.
- Proceso frontend: `AuthProvider.registrarUsuario` guarda el token y actualiza el usuario.
- Proceso backend: `AuthService.registrar` valida correo, crea usuario y genera JWT.
- Salida: `AuthResponse` con `accessToken` y perfil del usuario.

### 2. Inicio de sesion

- Entrada: formulario Flutter en `LoginScreen`.
- Endpoint: `POST /api/auth/login`.
- Proceso frontend: `AuthProvider.iniciarSesion` persiste JWT en `AlmacenamientoToken`.
- Proceso backend: `AuthService.iniciarSesion` valida credenciales y genera JWT.
- Salida: sesion autenticada disponible para favoritos, perfil e itinerarios.

### 3. Carga de lugares

- Entrada: Home, Discover y detalle de lugar.
- Endpoints: `GET /api/places` y `GET /api/places/{id}`.
- Proceso frontend: `PlaceProvider.cargarLugares` y `PlaceProvider.cargarDetalleLugar`.
- Proceso backend: `PlaceService.obtenerTodos` aplica filtros y distancia opcional.
- Salida: catalogo de lugares listo para tarjetas, listados y detalle.

### 4. Carga de eventos

- Entrada: Home y Discover cuando la categoria es eventos.
- Endpoint: `GET /api/events`.
- Proceso frontend: `EventProvider.cargarEventos`.
- Proceso backend: `EventService.obtenerTodos` filtra por ciudad, categoria y fecha.
- Salida: agenda consumida por `EventCard`.

### 5. Carga de consejos de seguridad

- Entrada: Home y `SafetyScreen`.
- Endpoint: `GET /api/safety-tips`.
- Proceso frontend: `SafetyProvider.cargarConsejos`.
- Proceso backend: `SafetyTipService.obtenerTodos`.
- Salida: consejos listos para banners y listados por categoria.

### 6. Carga de planes de membresia

- Entrada: flujos de monetizacion y visibilidad comercial.
- Endpoint: `GET /api/membership-plans`.
- Proceso frontend: `MembershipProvider.cargarPlanesMembresia`.
- Proceso backend: `MembershipPlanService.obtenerTodos`.
- Salida: planes comerciales listos para tarjetas y comparacion.

### 7. Generacion de itinerario

- Entrada: parametros del usuario en `TripPlannerScreen`.
- Endpoint: `POST /api/itineraries/generate`.
- Proceso frontend: `ItineraryProvider.generarPlan`.
- Proceso backend: `ItineraryService.generar` mezcla lugares, eventos y consejos.
- Salida: itinerario no persistido, listo para mostrar en `GeneratedPlanScreen`.

### 8. Guardado de favoritos

- Entrada: tarjetas y detalle de lugar.
- Endpoints: `POST /api/favorites`, `DELETE /api/favorites/{id}`, `GET /api/favorites`.
- Proceso frontend: `FavoritesProvider.alternarFavorito`.
- Proceso backend: `FavoriteService.crear` y `FavoriteService.eliminar`.
- Salida: lista sincronizada de favoritos del usuario autenticado.

### 9. Guardado de itinerarios

- Entrada: boton "Guardar itinerario" en `GeneratedPlanScreen`.
- Endpoints: `POST /api/itineraries`, `GET /api/itineraries`, `GET /api/itineraries/{id}`.
- Proceso frontend: `ItineraryProvider.guardarPlanActual`, `cargarPlanesGuardados` y `cargarPlan`.
- Proceso backend: `ItineraryService.guardar`, `obtenerMios` y `obtenerPorId`.
- Salida: itinerario persistido y visible en guardados.

### 10. Flujo futuro de negocios y visibilidad comercial

- Entrada: promocion comercial y registro de negocios.
- Endpoint principal: `/api/businesses`.
- Proceso frontend actual: la ruta ya existe y sirve como punto de extension.
- Proceso backend: `BusinessService` permite crear, consultar y actualizar negocios.
- Rol de negocio: base para futuras funciones de publicacion, visibilidad y monetizacion.

## Areas que conviene estudiar primero

- `AuthProvider` + `AuthService` + `AuthController`
- `PlaceProvider` + `PlaceService` + `PlaceController`
- `ItineraryProvider` + `ItineraryService` + `ItineraryController`
- `FavoritesProvider` + `FavoriteService` + `FavoriteController`
