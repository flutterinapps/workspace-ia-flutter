---
description: Crea una feature nueva de principio a fin con el flujo del equipo (spec -> código -> pruebas -> probar en la app -> auditoría).
---

Argumentos: `<app> <feature> [descripción o link de diseño]`.

1. **Spec**: delega en el agente `flutter-architect`. Muestra la spec y espera
   mi aprobación (salta este paso solo si ya existe `docs/ai/specs/<app>-<feature>.md`).
2. **Diseño** (si hay link de Figma o Stitch): skill `design-to-flutter`.
3. **Código**: skill `flutter-feature-slice` sobre `apps/<app>/`.
4. **Pruebas**: agente `flutter-test-engineer`.
5. **Probar en la app** (solo si el cambio toca pantallas o hay una
   funcionalidad que se pueda recorrer): **pregúntame** "¿La pruebo en el
   simulador?" y espera mi respuesta; no lo hagas por tu cuenta, cuesta tiempo
   y créditos. Si digo que sí: abre la app en un simulador (enciéndelo si no
   hay uno), recorre con `marionette` el flujo de la spec tomando capturas y
   repite con el texto al máximo. Los estados que no se pueden provocar en la
   app (por ejemplo, el error con datos mock) revísalos en las `@Preview` y
   dilo. Si digo que no, o no puedes abrir el simulador, déjalo como
   pendiente en el cierre: nunca lo des por probado.
6. **Auditoría**: skill `flutter-auditor` y agente `flutter-a11y-auditor`.
7. **Cierre**: resumen con archivos, resultado de `flutter analyze` y
   `flutter test`, hallazgos pendientes, si se probó en el simulador (y qué estados no) y cómo verlo.
