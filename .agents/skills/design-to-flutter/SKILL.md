---
name: design-to-flutter
description: Convierte una pantalla o componente de Figma o de Stitch en widgets Flutter que reutilizan el design system de la app (tokens del theme y widgets mapeados en components.md). Úsala cuando compartan un link de Figma, un id de pantalla de Stitch o pidan "implementa este diseño".
---

# Diseño -> Flutter

## 1. Leer el diseño (no adivinar)

- **Figma**: con el MCP de Figma, `get_design_context` y `get_screenshot` del
  nodo. Extrae fileKey y nodeId del link.
- **Stitch**: con el MCP de Stitch, `get_screen` (y `get_project` para el design
  system). El id del proyecto de cada app está en `design/sources.md`.
- Guarda la captura de referencia en `apps/<app>/design/refs/<pantalla>.png`.

## 2. Traducir al vocabulario de la app

- Abre `apps/<app>/design/components.md`: cada componente de diseño ya tiene su
  widget. Reutilízalo; solo crea uno nuevo si no hay equivalente, y entonces
  añádelo a la tabla.
- Cada color, tipografía, radio o espaciado debe existir en
  `apps/<app>/design/tokens.json` y en `lib/core/theme/`. Si falta, ejecuta
  primero `sync-design-tokens`.
- El código del MCP de diseño es una referencia, no código final: adáptalo a
  Flutter, a la arquitectura y a `l10n`.

## 3. Layout responsive

Usa restricciones (`Flex`, `Expanded`, `LayoutBuilder`), no los píxeles
absolutos del frame. Ver skill `flutter-build-responsive-layout`.

## 4. Verificar contra el diseño

- `@Preview` del widget; `hot_reload` si la app corre.
- Delega en el agente `design-qa` la comparación captura de la app vs
  referencia. Itera hasta que no haya diferencias de severidad alta.
