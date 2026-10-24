# Carriles de prueba con agentes

Cuatro formas de que un agente pruebe una app Flutter. No compiten: cada una
contesta una pregunta distinta.

| Carril | Pregunta que contesta | Necesita | Build | Herramienta |
|---|---|---|---|---|
| **1. Desarrollo** | ¿El código está bien y qué pasa por dentro? | Código fuente + app en debug | debug | Dart MCP (`analyze_files`, `run_tests`, `hot_reload`, `get_runtime_errors`, `widget_inspector`) |
| **2. Exploración** | ¿Funciona cuando lo uso como persona? | Código fuente + `marionette_flutter` en `main.dart` | debug / profile | `marionette_mcp` (`get_interactive_elements`, `tap`, `enter_text`, `scroll_to`, `take_screenshots`, `get_logs`) |
| **3. Regresión E2E** | ¿Sigue funcionando todo lo que ya funcionaba? | Tests de Patrol escritos y configuración nativa | debug / release | `patrol_mcp` (`run`, `devices`, `screenshot`, `native-tree`) |
| **4. Certificación caja negra** | ¿El binario que vamos a publicar hace lo que dice la spec? | Solo el APK + dispositivo real | release | `adb`, `uiautomator`, `screencap`, `logcat` (una skill de certificación sobre el APK) |

## Cuándo usar cada uno

- Mientras desarrollas una feature: **1** siempre; **2** para ver la pantalla
  funcionando (el agente toca, captura y verifica sin que tú lo hagas).
- Antes de un merge: **1** + tests unitarios y de widget + **2** como smoke test.
- Antes de una release: **3** en CI y **4** sobre el binario final.

## Diferencias que importan

- **Marionette vs Patrol**: Marionette es *interactivo* (el agente decide en
  vivo qué tocar, ideal para explorar y reproducir bugs). Patrol ejecuta tests
  *escritos* (repetibles, para CI) y además maneja diálogos nativos (permisos,
  notificaciones) que Marionette no ve.
- **Marionette vs certificación de caja negra**: Marionette necesita el código y un build
  de debug; ve widgets de Flutter. La certificación trabaja sobre el APK de
  release sin código; ve la capa nativa de Android (`uiautomator`). Por eso
  la certificación de caja negra es lo único válido para certificar lo que se publica.
- **Marionette vs Dart MCP**: el Dart MCP inspecciona (árbol de widgets,
  errores) y puede manejar la UI con Flutter Driver, que exige instrumentar la
  app. Marionette solo interactúa, con un cambio mínimo en `main.dart`.

## Estado en este workspace

| Carril | Estado |
|---|---|
| 1. Dart MCP | Configurado para todos los agentes (`.mcp.json`, etc.) |
| 2. Marionette | Integrado en Kinetix (debug) + MCP + skill `marionette-flutter-drive-app` |
| 3. Patrol | No integrado: requiere configurar targets nativos en iOS (Xcode) y Android (instrumentation runner). Siguiente paso recomendado. |
| 4. Certificación | No incluida en este workspace: se agrega como skill propia del proyecto cuando haga falta (certificar el APK, validar contra la spec, evidencia visual, QA). |

## Cómo conectar Marionette

1. `cd apps/kinetix && flutter run` (simulador o dispositivo).
2. Copia el URI del VM service que imprime, p. ej.
   `http://127.0.0.1:51630/AbC=/` → `ws://127.0.0.1:51630/AbC=/ws`.
3. Al agente: *"Conéctate con marionette a ws://… y toca el corazón del primer producto."*

Kinetix usa `GestureDetector` y widgets de Material, que Marionette reconoce sin
configuración. Si un widget propio no aparece en `get_interactive_elements`,
registra su tipo con `MarionetteConfiguration(isInteractiveElement: …)`.
