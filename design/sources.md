# Fuentes de diseño por app

| App | Herramienta | Referencia | Spec local |
|---|---|---|---|
| kinetix | Stitch | proyecto `15101966332426023116` (design system "Tactile Velour") | `apps/kinetix/design/DESIGN.md` |

Para Figma, anota el `fileKey` y los `node-id` de las pantallas clave:
`https://figma.com/design/<fileKey>/<nombre>?node-id=<nodeId>`.

Dos flujos según de dónde partas:

- **Hay diseño** (Stitch o Figma): skill `sync-design-tokens` → skill
  `design-to-flutter` → agente `design-qa` (modo app vs diseño).
- **No hay diseño, solo la app**: agente `design-documenter` → skill
  `team-app-to-figma` (+ `@Preview` para estados inalcanzables) → agente
  `design-qa` (modo réplica vs app).
