---
trigger: always_on
---

# Design system: el agente no inventa diseño

- Colores, tipografía, radios y espaciados salen del theme de la app
  (`lib/core/theme/`) o de un `ThemeExtension`. Prohibido `Color(0x...)`,
  `TextStyle(fontSize: ...)` o márgenes mágicos dentro de pantallas.
- La fuente de verdad del diseño de cada app está en `apps/<app>/design/`:
  `tokens.json` (valores) y `components.md` (componente de diseño -> widget).
- Si el diseño viene de Figma o Stitch, usa sus MCP para leer la pantalla y
  reutiliza los widgets mapeados en `components.md` antes de crear nuevos.
- Si falta un token, añádelo al theme (y a `tokens.json`), no lo escribas inline.
