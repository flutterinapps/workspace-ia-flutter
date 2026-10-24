# Cheatsheet — Ingeniería de Flutter en la era de la IA

## 1. Instala el plugin oficial (o clona este workspace)

| Agente | Comando |
|---|---|
| Claude Code | `claude plugin marketplace add flutter/agent-plugins` · `claude plugin install dart-flutter@dart-flutter` |
| Cursor | `/add-plugin dart-flutter` |
| Codex | `codex plugin marketplace add flutter/agent-plugins` · `codex plugin add dart-flutter@dart-flutter` |
| Copilot / cualquiera | `npx skills add flutter/agent-plugins --skill '*' --agent universal` |
| Cualquiera (Dart) | `dart run skills@ add https://github.com/flutter/agent-plugins --agent generic --all` |

El plugin **no** carga reglas: cópialas a `AGENTS.md` / `CLAUDE.md` / `GEMINI.md`.

## 1b. Clonar y preparar el workspace

```bash
git clone https://github.com/flutterinapps/workspace-ia-flutter
cd workspace-ia-flutter
./tool/setup_ai.sh        # macOS, Linux, WSL o Git Bash en Windows
```
PowerShell: `powershell -ExecutionPolicy Bypass -File tool\setup_ai.ps1`

## 2. Dart & Flutter MCP server (Dart ≥ 3.9)

```json
{ "mcpServers": { "dart": { "command": "dart",
  "args": ["mcp-server", "--enable=run_tests,dart_format,dart_fix,launch_app,list_devices,get_app_logs"] } } }
```

Herramientas: `analyze_files` · `run_tests` · `dart_format` · `dart_fix` ·
`hot_reload` · `get_runtime_errors` · `widget_inspector` · `pub` · `pub_dev_search` · `lsp`.

## 3. `package:skills`

`dart run skills@ get` (skills de tus dependencias) · `add <git>` · `list` ·
`prune` · `remove` · `create` (para autores de paquetes) · `--agent claude|cursor|copilot|codex|antigravity|generic`.

## 4. Dónde va cada cosa

Siempre → **reglas**. A veces → **skills**. Pesado y aislado → **agentes**.
No puede fallar → **hooks y lints**. Ver el diseño → **MCP de Figma/Stitch**.

## 5. Widget Previews

`@Preview(name:, group:, size:, wrapper:, theme:, brightness:, localizations:)`
· `MultiPreview` · `flutter widget-preview start`.

## 6. Que el agente use tu app: Marionette

```bash
flutter pub add marionette_flutter          # en la app
dart pub global activate marionette_mcp     # una vez
claude mcp add --transport stdio marionette -- marionette_mcp
```
`if (kDebugMode) MarionetteBinding.ensureInitialized();` en `main.dart`, luego
`flutter run` y dale al agente el URI `ws://…/ws`. Herramientas: `get_interactive_elements`
· `tap` · `enter_text` · `scroll_to` · `take_screenshots` · `get_logs` · `hot_reload`.
Skill: `dart run skills@ add https://github.com/leancodepl/marionette_mcp`.

Patrol MCP (`dart pub add --dev patrol_mcp`): corre tests E2E escritos con
Patrol, incluidos diálogos nativos. Ideal para CI.

## 7. Antes del merge (el ingeniero audita)

- [ ] `flutter analyze` 0 issues · `flutter test` verde
- [ ] Sin lógica en `build()` · `const` · `dispose()`
- [ ] Estados vacío / error con acción · `sealed class` + `switch`
- [ ] 48 dp · `Semantics`/`tooltip` · contraste AA · texto al 200%
- [ ] Inputs inclusivos · textos en l10n
- [ ] Sin API keys · App Check en features de IA

## Fuentes

docs.flutter.dev/ai · github.com/flutter/agent-plugins · github.com/dart-lang/skills ·
pub.dev/packages/skills · pub.dev/packages/marionette_mcp · agentskills.io
