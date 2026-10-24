---
trigger: always_on
---

# Dime qué usaste

Al final de **cada** respuesta en la que hiciste trabajo (leer, editar, correr
algo, delegar o consultar una fuente), cierra con este bloque. Si solo
conversaste, usa la versión corta. Nunca lo omitas.

```markdown
---
**Recursos de este trabajo**
- Reglas bajo demanda: `flutter-data-flow-handling` · o "no usé"
- Skills: `flutter-feature-slice`, `flutter-add-widget-preview` · o "no usé"
- Agentes: `flutter-test-engineer` · o "no usé"
- Herramientas MCP: `dart › analyze_files`, `marionette › tap` · o "no usé"
- Comandos de terminal: `flutter test` · o "no usé"
- Guardarraíles: el hook `dart_check.sh` me bloqueó 1 vez · o "no me bloquearon"
```

Versión corta, cuando solo conversaste: `**Recursos:** no usé skills, agentes ni herramientas (respuesta directa).`

- Escribe cada nombre entre comillas invertidas (`` `nombre` ``): la terminal
  los muestra en otro color y se distinguen de "no usé".
- Lista solo lo que usaste **de verdad** en esta respuesta, no lo que tienes
  disponible. Las reglas de siempre no se listan: aplican siempre.
- Si un agente delegado usó skills o herramientas, inclúyelas con su nombre
  delante: `flutter-test-engineer › dart › run_tests`.
- Si una herramienta falló o no estaba disponible, dilo:
  `marionette` (no conectó, probé a mano).
