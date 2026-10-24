# De dónde viene cada recurso

| Recurso | Origen | Cómo llegó | Se actualiza con |
|---|---|---|---|
| Reglas `flutter-*` (`.agents/rules/`) | Equipo de Flutter: [AI rules for Flutter](https://docs.flutter.dev/ai/ai-rules) | Copiadas y divididas por tema | A mano, cuando Flutter publique cambios |
| Regla `flutter-hot-reload` | Plugin [flutter/agent-plugins](https://github.com/flutter/agent-plugins) | Copiada de `rules/hot_reload.md` | A mano |
| 10 skills `flutter-*` oficiales | [flutter/agent-plugins](https://github.com/flutter/agent-plugins) | `package:skills` | `tool/setup_ai.sh --update` |
| 13 skills `dart-*` | Equipo de Dart: [dart-lang/skills](https://github.com/dart-lang/skills), incluidas en el plugin de Flutter | `package:skills` | `tool/setup_ai.sh --update` |
| Instalador `package:skills` | [labs.dart.dev](https://pub.dev/packages/skills) | `dart run skills@` | Se descarga la última versión al usarlo |
| Dart & Flutter MCP | Equipo de Dart: [`dart mcp-server`](https://dart.dev/tools/mcp-server) | Viene con el SDK de Dart | Con el SDK |
| Marionette MCP y skill `marionette-flutter-drive-app` | [LeanCode](https://pub.dev/packages/marionette_mcp) | `dart pub global activate` + `package:skills` | `tool/setup_ai.sh --update` |
| Patrol MCP | [LeanCode](https://pub.dev/packages/patrol_mcp) | Documentado, no integrado | — |
| Developer Knowledge MCP | [Google](https://developers.google.com/knowledge/mcp) | Servidor remoto | Lo mantiene Google |
| Figma MCP | [Figma](https://help.figma.com/hc/en-us/articles/32132100833559) | Plugin oficial | Lo mantiene Figma |
| Stitch MCP | Google Stitch | Servidor remoto | Lo mantiene Google |
| Reglas `team-*` | Propias (Lesly Samaritano) | Escritas para este workspace | A mano |
| Skills `flutter-feature-slice`, `flutter-auditor`, `flutter-new-app`, `design-to-flutter`, `sync-design-tokens`, `team-app-to-figma`, `team-whats-new` | Propias | Escritas para este workspace | A mano |
| Agentes `flutter-architect`, `flutter-test-engineer`, `flutter-a11y-auditor`, `design-qa`, `design-documenter` | Propios | Escritos para este workspace | A mano |
| `flutter-radar` y scripts de `tool/` | Propios | Escritos para este workspace | A mano |

## Ideas tomadas de charlas

| Idea en el workspace | Inspirada en |
|---|---|
| `flutter-architect`: spec antes de codificar | Paso `/brainstorm` de Very Good Ventures — Jorge Coca, *Building an AI-assisted workflow enforcing Flutter best practices* |
| Reglas de inclusión (`team-a11y-inclusion`) | Kali (Flutteristas), *Building and maintaining a culture of inclusive app development* |
| `flutter-a11y-auditor` | El agente oficial `@flutter_a11y_agent` de Antigravity |
| Regla `team-ai-features-security` | Charla de Firebase: AI Logic + App Check |
| Carriles de prueba y Marionette | Mateusz Wojtczak (LeanCode), *Automate interactive Flutter tests with marionette_mcp* |
| Arquitectura modular por app | Anna Leushchenko, *LEGO architecture* |

Cuando añadas algo nuevo, agrega su fila aquí con la URL de donde salió.
