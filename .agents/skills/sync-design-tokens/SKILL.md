---
name: sync-design-tokens
description: Sincroniza los tokens de diseño (colores, tipografía, radios, espaciados) entre el diseño y el código, en los dos sentidos - de Figma variables o Stitch hacia apps/<app>/design/tokens.json y el theme de Flutter, o del theme existente hacia tokens.json cuando la app no tiene diseño. Incluye un test que lo valida. Úsala cuando cambie el design system, antes de implementar pantallas nuevas o antes de documentar en Figma una app sin diseño.
---

# Sincronizar tokens de diseño

Primero decide el sentido:

- **Diseño → código** (hay Figma o Stitch): pasos 1 a 5.
- **Código → tokens** (la app no tiene diseño): lee `lib/core/theme/`
  (`ColorScheme`, `TextTheme`, `ThemeExtension`, constantes de color y
  espaciado), escribe `apps/<app>/design/tokens.json` con el formato del paso 2
  y salta al paso 4 para el test. No cambies el theme.

1. **Leer la fuente**
   - Figma: `get_variable_defs` del archivo (fileKey en `design/sources.md`).
   - Stitch: `get_project` / `list_design_systems` del proyecto.
2. **Escribir `apps/<app>/design/tokens.json`** con este formato:
   ```json
   {
     "color": { "primary": "#9e3756", "on-primary": "#ffffff" },
     "font": { "headline": "Montserrat", "body": "Inter" },
     "radius": { "card": 20, "button": 16 },
     "space": { "xs": 4, "sm": 8, "md": 16, "lg": 24 }
   }
   ```
   Muestra el diff de tokens antes de seguir.
3. **Actualizar el theme** en `lib/core/theme/`: colores a `ColorScheme`
   (Material 3), tipografía a `TextTheme`, lo que no encaje en Material a un
   `ThemeExtension`. No renombres tokens existentes sin migrar sus usos.
4. **Test**: `test/core/theme/tokens_test.dart` carga `tokens.json` y comprueba
   con `checks` que cada color del JSON coincide con el `ColorScheme`.
5. Verifica con `flutter analyze` y `flutter test`.
