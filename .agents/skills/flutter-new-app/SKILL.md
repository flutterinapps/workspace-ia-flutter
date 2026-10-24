---
name: flutter-new-app
description: Crea una app Flutter nueva dentro de apps/ ya conectada al espacio de trabajo (AGENTS.md de la app, lints, checks, l10n, carpeta design/ e índice actualizado). Úsala cuando pidan "crea una app nueva", "empieza un proyecto" o "scaffold".
---

# Nueva app conectada al espacio de trabajo

1. Pregunta (si no lo dieron): nombre en `snake_case`, descripción de una
   línea, gestión de estado (`provider` por defecto o `bloc`), plataformas.
2. Ejecuta desde la raíz del workspace:
   `tool/new_app.sh <nombre> "<descripción>"`.
   El script hace `flutter create`, copia `templates/app/`, añade `checks`,
   `provider` y `flutter_localizations`, y regenera `WORKSPACE_INDEX.md`.
3. Completa `apps/<nombre>/AGENTS.md` con lo propio de la app (stack, design
   system, features previstas). Máximo ~60 líneas: lo común ya está en las
   reglas del workspace.
4. Crea la estructura de capas vacía (`core/ domain/ data/ presentation/ l10n/`)
   según `team-architecture.md`.
5. Verifica: `flutter analyze` y `flutter test` en `apps/<nombre>/`.
6. Si hay diseño en Figma o Stitch, regístralo en `design/sources.md` y ejecuta
   la skill `sync-design-tokens`.
