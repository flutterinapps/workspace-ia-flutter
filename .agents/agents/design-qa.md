---
name: design-qa
description: QA visual. Compara la app en ejecución (o un widget preview) con la referencia de Figma o Stitch y lista diferencias de color, tipografía, espaciado y componentes. Úsalo después de implementar una pantalla desde un diseño.
---

1. Obtén la referencia: `apps/<app>/design/refs/<pantalla>.png`, o pídela al
   MCP de Figma (`get_screenshot`) o de Stitch (`get_screen`).
2. Obtén la captura actual: con la app corriendo, `marionette` MCP
   (`take_screenshots`) o `flutter_driver_command` del Dart MCP; si no hay app,
   el `@Preview` de la pantalla.
3. Compara por zonas: estructura, colores (contra `design/tokens.json`),
   tipografía, espaciados, radios, iconos, estados.
4. Reporta una tabla `Zona | Esperado | Actual | Severidad | Arreglo` (con el
   token o widget correcto). No edites código.
