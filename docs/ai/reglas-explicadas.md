# Las reglas, explicadas

Una **regla** es una instrucción que el agente debe cumplir. Viven en
`.agents/rules/`. Hay dos tipos según cuándo entran:

- **Siempre** (`trigger: always_on`): el agente las lee al empezar cada sesión.
  Por eso son cortas: ocupan espacio en su memoria de trabajo.
- **Bajo demanda** (`trigger: model_decision`): el agente solo ve la línea
  `description` y abre la regla cuando la tarea la necesita.

Quién gana si dos reglas chocan: el `AGENTS.md` de la app → las reglas `team-*`
→ las reglas `flutter-*`.

## De dónde salió cada una

| Regla | Origen | Cuándo | Qué dice, en una línea |
|---|---|---|---|
| `team-workflow` | Escrita para este workspace | Siempre | Entender antes de codificar, una capa a la vez, verificar con herramientas y qué significa "terminado" |
| `team-architecture` | Escrita para este workspace a partir del estándar de arquitectura de Lesly (capas + Provider) | Siempre | Capas, estados explícitos, nada de lógica en `build()`, y los perfiles por app (Capas, MVVM oficial, Bloc) |
| `team-design-system` | Escrita para este workspace | Siempre | La IA no inventa colores ni tamaños: salen del theme y de `design/tokens.json` |
| `team-a11y-inclusion` | Escrita para este workspace, inspirada en la charla de Flutteristas sobre inclusión | Siempre | Botones de 48 dp, etiquetas para lectores de pantalla, contraste, formularios que aceptan cualquier nombre, textos traducidos |
| `team-usage-report` | Escrita para este workspace a pedido de Lesly | Siempre | Al final de cada trabajo, la IA lista qué reglas bajo demanda, skills, agentes, herramientas y comandos usó, o dice que no usó ninguno |
| `team-ai-features-security` | Escrita para este workspace, inspirada en la charla de Firebase AI Logic + App Check | Bajo demanda | Nunca poner claves de IA en la app; App Check y límites por usuario |
| `team-knowledge-sources` | Escrita para este workspace | Bajo demanda | Qué fuente consultar: docs oficiales, pub.dev, skills o flutter-radar |
| `flutter-code-quality` | Oficial de Flutter ([AI rules](https://docs.flutter.dev/ai/ai-rules)) | Siempre | Nombres claros, funciones cortas, manejar errores, líneas de 80 caracteres |
| `flutter-dart-flutter-best-practices` | Oficial de Flutter | Siempre | Buenas prácticas de Dart y Flutter: null safety, `const`, widgets pequeños, listas con `builder` |
| `flutter-testing` | Oficial de Flutter | Siempre | Qué tipo de test usar y preferir `package:checks` |
| `flutter-hot-reload` | Oficial del plugin `flutter/agent-plugins` | Al editar `.dart` | Después de editar, hacer hot reload con el Dart MCP |
| `flutter-interaction-guidelines` | Oficial de Flutter | Bajo demanda | Cómo explicar y qué herramientas de formato y análisis usar |
| `flutter-project-structure` | Oficial de Flutter | Bajo demanda | Estructura de proyecto, gestión de paquetes y estado |
| `flutter-color-scheme-best-practices` | Oficial de Flutter | Bajo demanda | Theme, Material 3, contraste, tipografía, layouts sin desbordes |
| `flutter-visual-design-theming` | Oficial de Flutter | Bajo demanda | Diseño visual, theme e imágenes |
| `flutter-data-flow-handling` | Oficial de Flutter | Bajo demanda | Modelos, JSON, repositorios y rutas |
| `flutter-logging-code-generation` | Oficial de Flutter | Bajo demanda | Logging y generación de código |
| `flutter-documentation` | Oficial de Flutter | Bajo demanda | Cómo escribir comentarios de documentación |

Las `flutter-*` son el documento oficial *AI rules for Flutter* dividido por
tema; ya estaban en Kinetix. Las `team-*` son una **propuesta**: léelas y
cámbialas para que digan exactamente cómo trabajas tú.

## Cómo comprobar que una regla funciona

1. Pregunta al agente: "¿qué reglas tienes cargadas?". Deben aparecer las de
   "Siempre".
2. Pídele algo que la regla prohíba, por ejemplo: "pon este botón de color
   `Color(0xFFFF0000)`". Con `team-design-system`, debería negarse y usar el
   theme.
3. Si no la cumple, la regla está mal escrita o es demasiado larga: hazla más
   corta y concreta.
