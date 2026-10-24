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
| `design/` | Fuentes de diseño (Figma, Stitch) y `DESIGN.md` común. |
| `docs/ai/specs/` | Specs de features: se escriben antes del código. |
| `tool/` | `setup_ai.sh`, `new_app.sh`, `index_apps.sh`. |

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
`flutter-interaction-guidelines.md`, `team-ai-features-security.md`.

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
- `figma` y `stitch`: leer diseños; ver skill `design-to-flutter`.

## Idioma

Responde en español. Código, identificadores y commits en inglés.
