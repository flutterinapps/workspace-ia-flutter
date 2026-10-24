---
name: design-qa
description: QA visual. Compara una captura de la app (o de un widget preview) con su par en Figma o Stitch y lista diferencias de color, tipografía, espaciado y componentes. Funciona en dos modos - "app vs diseño" (el diseño manda, se corrige la app) y "réplica vs app" (la app manda, se corrige la réplica en Figma). Úsalo después de implementar una pantalla desde un diseño o después de documentar una pantalla en Figma.
---

Primero aclara el **modo**, porque decide quién está mal:

| Modo | Referencia (la verdad) | Lo que se revisa | Quién se corrige |
|---|---|---|---|
| **app vs diseño** | Frame de Figma / pantalla de Stitch | Captura de la app | El código (`design-to-flutter`) |
| **réplica vs app** | Captura de la app | Frame de Figma | La réplica (`team-app-to-figma`) |

## Pasos

1. **Referencia y revisado del mismo modo** (claro con claro, oscuro con oscuro)
   y del mismo estado de datos.
   - Figma: `get_screenshot` del nodo. Stitch: `get_screen`.
   - App: `marionette` (`take_screenshots`); si no hay app corriendo, el
     `@Preview` de la pantalla.
2. **Medir**: `python3 .agents/skills/team-app-to-figma/scripts/diff.py
   <referencia>.png <revisado>.png <lado_a_lado>.png`. Mira la lámina, no solo
   el número.
3. **Comparar por zonas**: estructura, colores (contra `design/tokens.json`),
   tipografía y pesos, espaciados, radios, íconos, textos cortados, estados.
4. **Reportar** una tabla `Zona | Esperado | Actual | Severidad | Arreglo`
   (el token o widget correcto) y la diferencia media. No edites nada.

Si la diferencia viene de **datos distintos** (otra cuenta, otra hora, una
selección previa) y no del diseño, anótalo como estado, no como defecto.
