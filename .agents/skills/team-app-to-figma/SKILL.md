---
name: team-app-to-figma
description: Documenta en Figma una app Flutter que no tiene diseño —pantalla por pantalla, en claro y oscuro, con capas editables, tokens como variables y la diferencia medida contra la app viva—. Úsala cuando digan "pasa esta pantalla a Figma", "la app no tiene Figma, empecemos a documentarla", "replica la app en Figma", "haz la versión oscura de esta pantalla" o "la pantalla en Figma ya no es igual a la app". La referencia es la app; lo que se corrige es la réplica. NO la uses para encontrar defectos de la app contra un diseño existente (eso es el agente design-qa) ni para implementar un diseño en código (eso es design-to-flutter).
---

# App → Figma: documentar una app que no tiene diseño

La app viva es la fuente de verdad. Esta skill la lleva a Figma de forma
**medida y repetible**, para que el equipo empiece a tener diseño versionado
sin redibujar a ojo.

Basada en un método probado sobre más de 60 pantallas en producción; aquí está
generalizado para cualquier proyecto Flutter.

## Requisitos

| Qué | Para qué |
|---|---|
| App en **debug** con `marionette_flutter` (`MarionetteBinding` en `kDebugMode`) | Navegar por texto, capturar y leer logs |
| MCP `marionette` y MCP `dart` | Manejar la app e inspeccionar el árbol de widgets (`widget_inspector`) |
| MCP de **Figma** con permiso de escritura | Crear páginas, frames, variables. En Claude Code carga antes la skill `figma-use` del plugin de Figma |
| `apps/<app>/design/tokens.json` | Si no existe, se genera en el paso 2 desde `lib/core/theme/` |
| Python 3 con Pillow (solo para `scripts/diff.py`) | Medir la diferencia por píxel |

## Paso 0 · Inventario (antes de capturar nada)

1. Lista las pantallas desde el router (`MaterialApp.routes`, `GoRouter`,
   `onGenerateRoute`) y las hojas y diálogos que se abren desde cada una.
2. Para cada pantalla, lista sus **estados** (cargando, vacío, datos, error).
   Los que la app no alcanza sin efectos reales (un pago fallido, un error del
   backend) se documentan desde un `@Preview` (skill `flutter-add-widget-preview`),
   **no** forzando la app.
3. Escribe el inventario en `apps/<app>/design/screens.md`:
   `ID | Pantalla | Ruta | Estado | Cómo se llega | Estado en Figma`.
   Pide aprobación del orden antes de seguir.

## Paso 1 · Preparar Figma

- Archivo nuevo o existente (anota el `fileKey` en `design/sources.md`).
- Páginas: `Réplica · Claro`, `Réplica · Oscuro`, `Componentes`, `Descartados`.
- Variables de color y tipografía creadas **desde `tokens.json`**, con modo
  Claro/Oscuro. Los frames usan variables, no colores sueltos.

## Paso 2 · Por cada pantalla del inventario

1. **Llegar a la pantalla** con marionette: por **ruta o texto visible**, nunca
   por coordenadas a ciegas. Espera a que carguen los datos (mínimo 6 s en
   pantallas con red) y comprueba con `get_interactive_elements` que estás donde
   crees.
2. **Capturar en los dos modos**: `scripts/capture_themes.sh <ws_uri> <carpeta> <id>`
   (cambia la apariencia del simulador o emulador, captura con marionette y
   deja la apariencia como estaba).
3. **Leer la estructura**: `widget_inspector` del Dart MCP para el árbol de la
   pantalla (textos reales, jerarquía, qué hace scroll, qué es fijo) y
   `design/components.md` para saber qué widget es qué componente.
4. **Construir el frame editable** en Figma: auto layout que siga la jerarquía
   del árbol, textos reales, colores y tipografías **como variables**, íconos
   como vectores. La captura va como capa de referencia bloqueada y oculta.
5. **Medir**: exporta el frame (`get_screenshot`) y compáralo:
   `python3 scripts/diff.py <captura>.png <figma>.png <lado_a_lado>.png`.
   Meta: diferencia media **< 7**. Mira además la lámina lado a lado: el número
   solo no detecta un texto cortado.
6. **Registrar**: actualiza `screens.md` (estado y diferencia) y, si nació un
   componente nuevo, `design/components.md`.

## Paso 3 · Cierre

Delega en el agente `design-qa` una revisión de la réplica contra la app (mismo
modo, misma pantalla). Lo que él marque como alto se corrige antes de dar la
pantalla por documentada.

## Reglas que no se rompen

- **Nunca** confirmes pagos, envíes formularios, aceptes permisos o
  consentimientos para llegar a una pantalla: usa un `@Preview` de ese estado.
- **No borres** versiones anteriores en Figma: muévelas a `Descartados` con fecha.
- **Datos personales**: si la cuenta de prueba muestra documento, correo,
  teléfono o dirección reales, enmascáralos (`•••`) en el frame y en la captura
  de referencia antes de subir.
- Compara siempre **el mismo modo** (claro con claro).

## Trampas conocidas

| Trampa | Cómo evitarla |
|---|---|
| Navegar durante un `build` (p. ej. un `pop` sin nada que cerrar) tumba la app | Navega por marionette o agenda la navegación; comprueba `canPop()` antes de volver |
| Capturar antes de que lleguen los datos | Espera y verifica con `get_interactive_elements` que el texto esperado ya está |
| Avisos que se van solos (SnackBar, toast) | Documéntalos desde un `@Preview` con el aviso fijo |
| Hojas y diálogos: el velo oscurece lo de abajo | Documenta la hoja como frame propio y el fondo como imagen bloqueada |
| `IndexedStack` / pestañas montadas a la vez | Usa solo el hijo visible del árbol |
| El importador de Figma redondea pesos de fuente (600 → Bold) | Revisa los pesos contra `tokens.json` después de crear el frame |
| `frame.resize()` escala los hijos con restricciones | Usa `resizeWithoutConstraints` |
| Bucles de shell en zsh no separan pares `id ruta` | Los lotes van con `bash` y las URL entre comillas |
| La app no tiene `darkTheme` | La captura oscura sale igual a la clara (diferencia 0): documenta solo Claro y anota en `screens.md` que falta el modo oscuro |
| Un cambio pequeño da un número pequeño (un ícono distinto ≈ 0,02) | El umbral detecta desajustes globales; los locales se ven en la lámina lado a lado |
| Pantallas con scroll más alto que el dispositivo | Captura por pasadas de scroll y une; o documenta arriba y abajo como dos frames |

## Dónde termina

- Deja las pantallas en Figma, medidas y registradas. No cambia código de la app.
- Convertir lo replicado en componentes y variantes es otro paso (no esta skill).
- Conectar el prototipo (navegación entre frames) es otro paso (no esta skill).
