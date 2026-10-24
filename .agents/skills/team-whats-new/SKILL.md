---
name: team-whats-new
description: Resume lo nuevo de Flutter, Dart y las herramientas del workspace (videos oficiales, blogs, releases de SDK, agent-plugins, dart_mcp, marionette, patrol) y dice qué afecta a nuestras apps y a nuestras reglas y skills. Úsala cuando pregunten "¿qué hay de nuevo en Flutter?", "resumen de la semana", "¿salió algo que nos afecte?" o antes de actualizar el workspace.
---

# Qué hay de nuevo (y qué nos afecta)

1. **Actualiza el índice** si `radar_status` muestra más de 1 día sin ingesta:
   `uv run tool/flutter_radar/radar.py ingest`.
2. **Recoge**: `whats_new_flutter(since_days=7)` (o el periodo pedido). Si
   piden paquetes, añade `kinds=["package"]`.
3. **Cruza con el workspace**:
   - Releases del SDK → compara con la versión de cada app
     (`apps/*/pubspec.lock`, `flutter --version`) y revisa
     https://docs.flutter.dev/release/breaking-changes con `developer-knowledge`.
   - Releases de `flutter/agent-plugins`, `dart-lang/ai` (`skills`,
     `dart_mcp_server`), `marionette_mcp`, `patrol` → ¿cambia algo de
     `.agents/skills/`, `.mcp.json` o `tool/setup_ai.sh`?
   - Videos y blogs → ¿contradicen o mejoran alguna regla `team-*`?
4. **Entrega** en este formato:

   ```
   ## Novedades (DD/MM–DD/MM)
   | Fecha | Tipo | Qué | Enlace |
   ## Qué nos afecta
   - <app o archivo>: <qué cambia> → <acción propuesta>
   ## Para ver después
   - <video o post que vale la pena, con por qué>
   ```

5. **No edites** reglas, skills ni apps: propón los cambios. Para las skills
   oficiales, la acción es `tool/setup_ai.sh --update`.
