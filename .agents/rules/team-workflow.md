---
trigger: always_on
---

# Cómo trabajamos con agentes

1. **Entender antes de codificar.** Lee el `AGENTS.md` de la app y, si existe,
   la spec en `docs/ai/specs/`. Si la tarea es una feature nueva y no hay spec,
   propón una (o delega en el agente `flutter-architect`) y espera aprobación.
2. **Reutilizar.** Busca widgets, providers y repositorios existentes antes de
   crear nuevos.
3. **Cambios pequeños y verificables.** Una capa a la vez: domain -> data ->
   presentation -> tests.
4. **Verificar con herramientas, no con fe.** Usa el Dart MCP server:
   `analyze_files`, `run_tests`, `dart_format`, `hot_reload`,
   `get_runtime_errors`. Si no está disponible: `flutter analyze` y
   `flutter test` dentro de la carpeta de la app.

## Definición de terminado

- `flutter analyze` sin issues y `flutter test` en verde.
- Cada widget nuevo tiene `@Preview` (claro/oscuro) y widget test.
- Cada provider nuevo tiene unit tests con `package:checks` para todos sus estados.
- Textos visibles en `l10n` (EN y ES), nunca literales en el código.
- Resumen final: archivos creados/modificados y cómo probarlo.

## Límites

- No añadir dependencias sin decir por qué.
- No tocar `ios/`, `android/` ni archivos generados salvo que la tarea lo pida.
- Nunca escribir API keys ni secretos en el código.
