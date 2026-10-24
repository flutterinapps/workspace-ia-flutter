# Adaptar y mejorar el workspace

El workspace es un punto de partida, no un estándar cerrado. Cada proyecto lo
ajusta a su medida sin romper lo común.

## 1. Adaptarlo a un proyecto

| Quiero… | Cómo |
|---|---|
| Traer una app que ya existe | Cópiala o muévela a `apps/<app>/` **con su propio repo git**. El workspace la ignora (`/apps/*` en `.gitignore`) pero ella hereda reglas, skills, agentes, MCP y hooks. |
| Empezar una app nueva | `tool/new_app.sh <nombre> "<descripción>"` |
| Que una app use otra arquitectura | En su `AGENTS.md`, declara el perfil: **Capas** (por defecto), **MVVM oficial** o **Bloc** (ver `team-architecture.md`). El agente respeta el perfil de cada app. |
| Que una app tenga una regla propia | Escríbela en el `AGENTS.md` de la app: lo de la app manda sobre lo común en lo que contradiga. |
| Que **todas** las apps cambien una regla | Edita la regla `team-*` en `.agents/rules/`. |
| Cambiar el diseño de una app | `apps/<app>/design/tokens.json` + skill `sync-design-tokens`. |

Ejemplo real: `kinetix` usa el perfil Capas; una app que sigue la guía oficial
de Flutter declara MVVM oficial y conserva `ui/features/<f>/view_models`.

## 2. Mejorarlo con lo nuevo que sale

```
flutter-radar detecta algo        (un video, un release, un post)
        ↓
skill team-whats-new              "¿qué hay de nuevo y qué nos afecta?"
        ↓
tú decides si aplica              (no todo lo que sale es para tu proyecto)
        ↓
cambias la pieza en .agents/      regla, skill o agente — nunca en .claude/
        ↓
pruebas en una app y haces commit
```

Ejemplos de "un video sugirió algo":

- **Una práctica que debe cumplirse siempre** (p. ej. "usa `checks` en vez de
  `expect`") → una línea en la regla `team-*` que corresponda.
- **Una receta de varios pasos** (p. ej. "cómo agregar un previewer por estado")
  → una skill nueva `.agents/skills/team-<nombre>/SKILL.md`.
- **Una revisión especializada** (p. ej. "auditar rendimiento de listas") → un
  agente nuevo en `.agents/agents/`.
- **Una herramienta** (p. ej. un MCP nuevo) → `.mcp.json` y los demás archivos
  de configuración de agentes, con secretos como variables de entorno.

Anota de dónde salió la idea (URL del video o post) en el propio archivo y en
`docs/ai/origen-de-los-recursos.md`.

## 3. Mantener al día lo oficial

- Skills oficiales de Flutter, Dart y Marionette: `tool/setup_ai.sh --update`,
  revisa `git status` y haz commit. **No las edites a mano**: si necesitas otra
  versión, crea una `team-*`.
- Skills que no quieres: añade su nombre a `.agents/skills-exclude.txt`.
- Índice de novedades: `uv run tool/flutter_radar/radar.py ingest`; fuentes en
  `tool/flutter_radar/sources.toml` (añade el canal o blog que sigues).

## 4. Comprobar que el cambio funciona

1. Abre el agente en la raíz y pregunta: "¿qué reglas, skills, agentes y MCP
   cargaste de esta carpeta?".
2. Pídele una tarea que use lo nuevo y revisa que lo aplique.
3. `flutter analyze` y `flutter test` en la app de prueba.
