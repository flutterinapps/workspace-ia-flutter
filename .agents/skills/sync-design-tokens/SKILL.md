---
name: sync-design-tokens
description: Sincroniza los tokens de diseño (colores, tipografía, radios, espaciados) desde Figma variables o el design system de Stitch hacia apps/<app>/design/tokens.json y el theme de Flutter (ColorScheme, TextTheme, ThemeExtension), con un test que lo valida. Úsala cuando cambie el design system o antes de implementar pantallas nuevas.
---

# Sincronizar tokens de diseño

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
