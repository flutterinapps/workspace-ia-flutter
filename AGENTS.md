# Espacio de trabajo IA Flutter

Monorepo de apps Flutter preparado para trabajar con agentes de IA (Claude Code,
Gemini CLI, Antigravity, Codex, Cursor, Copilot). Este archivo es la **fuente
única de reglas**; `CLAUDE.md` y `GEMINI.md` solo lo importan.

## Mapa

| Ruta | Qué hay |
|---|---|
| `WORKSPACE_INDEX.md` | Índice de apps: stack, estado y comandos. Léelo para ubicarte. |
| `apps/<app>/` | Cada app Flutter, con su propio `AGENTS.md` (solo lo que la hace distinta). |
| `.agents/rules/` | Reglas. `team-*` = estándar del equipo (gana en conflicto); `flutter-*` = AI rules oficiales de Flutter. |
| `.agents/skills/` | Skills (formato agentskills.io), se cargan bajo demanda. |
| `.agents/agents/` | Agentes especializados (contexto aislado). |
| `.agents/workflows/` | Flujos repetibles (`new-feature`). |
| `design/` | Fuentes de diseño por app (`sources.md`). Cada app guarda `design/tokens.json`, `components.md` y `screens.md`. |
| `docs/ai/specs/` | Specs de features: se escriben antes del código. |
| `tool/` | `setup_ai.sh`, `new_app.sh`, `index_apps.sh`. |

## Cómo extender el workspace

Todo lo nuevo se crea en la **fuente única** `.agents/`. Nunca escribas
directamente en `.claude/`, `.gemini/`, `.cursor/` ni `.github/`: esas carpetas
son enlaces a `.agents/` (salvo los archivos de configuración propios de cada
herramienta).

| Quiero crear… | Dónde | Formato |
|---|---|---|
| Una regla que aplique siempre o por contexto | `.agents/rules/team-<tema>.md` | Markdown con frontmatter `trigger: always_on` o `trigger: model_decision` + `description:`. Si es `always_on`, añádela también a la lista de abajo y a `CLAUDE.md`/`GEMINI.md`. |
| Una skill (receta paso a paso) | `.agents/skills/<nombre>/SKILL.md` | Frontmatter `name` (igual a la carpeta) y `description` que diga **cuándo** usarla. Ejemplos o scripts en subcarpetas. |
| Un agente especializado | `.agents/agents/<nombre>.md` | Frontmatter `name` y `description`; el cuerpo es su prompt de sistema. Sin campo `tools` para que sirva en Claude y Gemini. |
| Un flujo / comando | `.agents/workflows/<nombre>.md` + `.claude/commands/<nombre>.md` y `.gemini/commands/<nombre>.toml` que lo invoquen | Ver `new-feature` como ejemplo. |
| Un guardarraíl (hook) | Script en `tool/hooks/` + registro en `.claude/settings.json` | Salir con código 2 para que el agente lea el error. |
| Un servidor MCP | `.mcp.json`, `.gemini/settings.json`, `.cursor/mcp.json`, `.vscode/mcp.json` | Secretos solo como variables de entorno (`${VAR}`). |
| Una app | `tool/new_app.sh <nombre>` | Crea `apps/<nombre>/` con su `AGENTS.md`. |
| Contexto de una app | `apps/<app>/AGENTS.md` (máx. ~60 líneas) | Solo lo que la hace distinta. |

Las skills oficiales son las registradas en `.config/dart_skills/skills_config.json`;
no se editan a mano, se actualizan con `tool/setup_ai.sh --update`. Las skills
nuevas del equipo llevan el prefijo `team-` para distinguirlas. Si necesitas
cambiar una oficial, crea una `team-` con tu versión.

## Reglas que aplican siempre

Lee y cumple estos archivos al empezar cualquier tarea:

- `.agents/rules/team-workflow.md` — cómo trabajamos y definición de terminado.
- `.agents/rules/team-architecture.md` — capas, estado y widgets.
- `.agents/rules/team-design-system.md` — nada de diseño hardcodeado.
- `.agents/rules/team-a11y-inclusion.md` — accesibilidad e inclusión.
- `.agents/rules/flutter-code-quality.md`, `flutter-dart-flutter-best-practices.md`,
  `flutter-testing.md`, `flutter-hot-reload.md` — AI rules oficiales.

## Reglas bajo demanda

Léelas solo cuando la tarea lo requiera (la primera línea de cada una dice cuándo):
`flutter-color-scheme-best-practices.md`, `flutter-visual-design-theming.md`,
`flutter-data-flow-handling.md`, `flutter-logging-code-generation.md`,
`flutter-documentation.md`, `flutter-project-structure.md`,
`flutter-interaction-guidelines.md`, `team-ai-features-security.md`,
`team-knowledge-sources.md` (qué fuente consultar sobre Flutter/Dart).

## Comandos

Siempre dentro de la carpeta de la app (`cd apps/<app>`):

```bash
flutter pub get
flutter analyze
flutter test
flutter run                     # simulador iOS o emulador Android
flutter widget-preview start    # previews de widgets
```

Desde la raíz: `tool/setup_ai.sh` (prepara agentes), `tool/new_app.sh <nombre>`
(app nueva), `tool/index_apps.sh` (regenera el índice).

## Herramientas (MCP)

- `dart` (Dart & Flutter MCP): `analyze_files`, `run_tests`, `dart_format`,
  `dart_fix`, `hot_reload`, `get_runtime_errors`, `widget_inspector`, `pub`,
  `pub_dev_search`. Úsalas antes que la terminal.
- `marionette`: manejar la app corriendo como una persona (tocar, escribir,
  hacer scroll, capturar pantalla, leer logs). Requiere `flutter run` y el URI
  del VM service. Ver skill `marionette-flutter-drive-app`.
- `figma` y `stitch`: leer diseños; ver skill `design-to-flutter`.
- `developer-knowledge` (Google): documentación oficial de docs.flutter.dev y
  dart.dev en vivo. Requiere `GOOGLE_DK_API_KEY`.
- `flutter-radar` (local): lo que la documentación no tiene — videos oficiales,
  blogs, releases de SDK y herramientas, paquetes nuevos y material propio.
  `whats_new_flutter`, `search_flutter`. Ver `team-knowledge-sources.md`.

Qué herramienta usar para probar qué: `docs/ai/testing-lanes.md`.

## Idioma

Responde en español. Código, identificadores y commits en inglés.
