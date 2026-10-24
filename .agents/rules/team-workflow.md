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
- Cambios en pantalla o funcionalidad que se pueda recorrer: ofrece probarlos en el
  simulador con `marionette` y decide la persona. Si no se probó, dilo en el resumen.
- Resumen final: archivos creados/modificados y cómo probarlo.

## Commits

Siguen [Conventional Commits 1.0.0](https://www.conventionalcommits.org/es/v1.0.0/):
`<tipo>(<alcance opcional>): <descripción>`, en inglés, en imperativo y sin punto final.

- Tipos: `feat` (función nueva), `fix` (corrección), `docs`, `refactor`, `test`,
  `perf`, `style`, `build`, `ci`, `chore`.
- Alcance: la app o la parte del workspace, p. ej. `feat(kinetix): add wishlist screen`,
  `docs(rules): explain every rule`.
- Cambio que rompe compatibilidad: `!` tras el tipo (`feat(kinetix)!: …`) o un pie
  `BREAKING CHANGE: …`.
- Un commit por cambio lógico. Si la app define otro idioma o formato en su
  `AGENTS.md`, manda la app.

## Límites

- No añadir dependencias sin decir por qué.
- No tocar `ios/`, `android/` ni archivos generados salvo que la tarea lo pida.
- Nunca escribir API keys ni secretos en el código.
