---
trigger: model_decision
description: Usar cuando haya que buscar información sobre Flutter o Dart fuera del código del repo - documentación, paquetes, novedades, lo que se dijo en un video o una charla.
---

# Qué fuente consultar para cada pregunta

Antes de responder de memoria sobre Flutter o Dart, consulta la fuente que
corresponde y **cita la URL**. Tu conocimiento puede estar desactualizado; las
fuentes no.

| Pregunta | Fuente | Herramienta |
|---|---|---|
| Cómo funciona una API, un widget, una guía oficial | docs.flutter.dev / dart.dev | MCP `developer-knowledge` (`search_documents`, `get_documents`, `answer_query`) |
| Qué paquete usar, su versión, su código | pub.dev | MCP `dart` (`pub_dev_search`, `read_package_uris`) |
| Cómo hacer una tarea paso a paso | Skills del workspace | `.agents/skills/` |
| Qué hay de nuevo; qué se dijo en un video, un blog o un release; qué cambió en una herramienta (agent-plugins, marionette, patrol, dart_mcp) | flutter-radar | MCP `flutter-radar` (`whats_new_flutter`, `search_flutter`) |
| Qué decidimos en este workspace y por qué | Material propio | `flutter-radar` (`kind: own`) o `docs/ai/` directamente |
| Qué hace el código de este repo | El repo | Dart MCP (`lsp`, `analyze_files`) y lectura directa. **Nunca** el radar |

## Reglas

- Si dos fuentes se contradicen, gana la oficial (`developer-knowledge`) y lo
  dices.
- El radar guarda **resúmenes**, no el contenido completo: para afirmar algo
  concreto de un video o un post, abre la URL o dilo como "según el resumen".
- Si el radar no tiene nada reciente, puede estar desactualizado: revisa
  `radar_status` y sugiere `uv run tool/flutter_radar/radar.py ingest`.
- `developer-knowledge` necesita `GOOGLE_DK_API_KEY`; si no está, dilo y sigue
  con las demás fuentes.
