# Fuentes de diseño por app

| App | Herramienta | Referencia | Spec local |
|---|---|---|---|
| kinetix | Stitch | proyecto `15101966332426023116` (design system "Tactile Velour") | `apps/kinetix/design/DESIGN.md` |

Para Figma, anota el `fileKey` y los `node-id` de las pantallas clave:
`https://figma.com/design/<fileKey>/<nombre>?node-id=<nodeId>`.

Flujo: Stitch (explorar y generar pantallas) -> Figma (fuente de verdad del
design system, opcional) -> skill `sync-design-tokens` -> skill
`design-to-flutter` -> agente `design-qa`.
