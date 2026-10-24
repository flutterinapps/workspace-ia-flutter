---
description: Crea una feature nueva de principio a fin con el flujo del equipo (spec -> código -> pruebas -> auditoría).
---

Argumentos: `<app> <feature> [descripción o link de diseño]`.

1. **Spec**: delega en el agente `flutter-architect`. Muestra la spec y espera
   mi aprobación (salta este paso solo si ya existe `docs/ai/specs/<app>-<feature>.md`).
2. **Diseño** (si hay link de Figma o Stitch): skill `design-to-flutter`.
3. **Código**: skill `flutter-feature-slice` sobre `apps/<app>/`.
4. **Pruebas**: agente `flutter-test-engineer`.
5. **Auditoría**: skill `flutter-auditor` y agente `flutter-a11y-auditor`.
6. **Cierre**: resumen con archivos, resultado de `flutter analyze` y
   `flutter test`, hallazgos pendientes y cómo verlo en el simulador.
