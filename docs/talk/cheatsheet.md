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

## 6. Ciclo cerrado (bonus)

`marionette_mcp` (LeanCode): el agente toca, escribe y captura la app en
ejecución. `MarionetteBinding.ensureInitialized()` solo en `kDebugMode`.

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
