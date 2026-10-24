# Cómo funciona por dentro

Un **arnés** (*agent harness*) es todo lo que rodea al modelo de IA y lo
convierte en un agente que actúa: el programa que lo ejecuta y la
configuración que ese programa carga. Tiene dos capas:

| Capa | Qué es | Quién la hace |
|---|---|---|
| **El motor** | Claude Code, Gemini CLI, Antigravity: el bucle, las herramientas, los permisos | Anthropic, Google… |
| **La configuración** | Este workspace: reglas, recetas (skills), especialistas (agentes), herramientas (MCP) y controles (hooks) | Tú |

El motor sin configuración es un agente genérico. Con este workspace, es un
agente que trabaja como tú.

## Qué pasa cuando le pides algo

Ejemplo: abres `claude` en la raíz del workspace y escribes *"crea la pantalla
de favoritos de Kinetix"*.

```
1. ARRANQUE (antes de que escribas nada)
   El motor lee el workspace:
   - CLAUDE.md → AGENTS.md → las reglas de siempre (.agents/rules/)
   - la lista de skills (solo nombre y descripción) y de agentes
   - .mcp.json → conecta las herramientas: Dart, Marionette, flutter-radar…
   - .claude/settings.json → registra el hook de formato y análisis

2. ENVÍO AL MODELO
   tu pedido + tus reglas + la lista de skills y herramientas.
   El modelo solo recibe texto: no puede tocar tu computadora.

3. EL MODELO DECIDE
   "Primero quiero usar la skill flutter-feature-slice"
   "Quiero leer wishlist_provider.dart"
   "Quiero llamar a analyze_files"

4. EL MOTOR EJECUTA                  ← aquí trabaja el arnés
   lee el archivo / corre la herramienta / te pide permiso
   y le devuelve el resultado al modelo.

5. SE REPITE (el bucle)              3 → 4 → 3 → 4… hasta terminar
   Cada vez que edita un .dart, el hook formatea y analiza solo.
   Si hay un error, el modelo lo ve y lo corrige.

6. RESPUESTA FINAL
   Te entrega el resultado; la decisión de publicarlo es tuya.
```

En una frase: **el modelo piensa, el arnés hace y tu carpeta decide cómo.**

## Compruébalo tú

| Paso | Cómo verlo |
|---|---|
| 1 | Pregunta al agente: "¿qué reglas, skills, agentes y herramientas MCP tienes cargados?" |
| 3–4 | Pide "analiza apps/kinetix con analyze_files": verás la llamada a la herramienta y su resultado |
| 5 | Pide un cambio en un `.dart` con un error a propósito: el hook lo detecta y el agente lo corrige |
