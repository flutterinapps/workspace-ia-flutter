# Guion de la demo — Kinetix · Wishlist (15:32–15:50)

Rama de partida: `main` (= `step-0-workspace`). Simulador iOS abierto y
`flutter run` corriendo en `apps/kinetix` **antes** de empezar.

## 0. Preparación (la noche anterior)

```bash
cd workspace-ia-flutter && git checkout main && tool/setup_ai.sh
cd apps/kinetix && flutter precache --ios && flutter build ios --simulator
open -a Simulator && flutter run      # deja la app abierta
```

- [ ] `claude` abre sin pedir login. `gemini` con sesión iniciada
      (`GOOGLE_CLOUD_PROJECT` exportado) si lo vas a mostrar.
- [ ] Modo avión probado: todo lo de abajo salvo el modelo funciona offline.
- [ ] Ramas: `git branch` muestra `step-0-workspace`, `step-1-domain`,
      `step-2-ui`, `final`.

## 1. "¿Qué cargaste?" (3 min)

En la raíz del workspace: `claude`

> ¿Qué reglas, skills, agentes y herramientas MCP tienes cargados?

Qué señalar: las 8 reglas de siempre (no las 16), las skills solo por nombre,
los 4 agentes, el MCP `dart`. *"Esto no lo escribí en el prompt: lo trae el
espacio de trabajo."*

## 2. Spec antes que código (3 min)

> /new-feature kinetix wishlist "pantalla de favoritos con estados loading, vacío, datos y error"

El agente `flutter-architect` escribe `docs/ai/specs/kinetix-wishlist.md`.
Léela en voz alta 20 segundos: estados, contrato, casos borde, criterios.
Apruébala: *"Aprobada, sigue."*

## 3. Generación por capas (5 min)

Mientras trabaja, señala en pantalla:
- domain → data → provider → pantalla (una capa a la vez, regla `team-workflow`);
- el **hook** formatea y analiza cada `.dart` que toca (si hay un error, el
  agente lo ve y lo corrige solo);
- reutiliza `KinetixProductCard`, `KinetixButton`, `KinetixAppBar` (`design/components.md`).

## 4. Verificación cerrada (5 min)

- `hot_reload` vía MCP → en el simulador aparece el ♥ en el app bar. Toca ♥ en
  2 productos y abre Favoritos.
- `run_tests` vía MCP. **Momento probable**: el widget test de la pantalla
  descubre un overflow en `KinetixProductCard` con tarjetas estrechas (bug real
  de la app). El agente usa `flutter-fix-layout-issues` y lo arregla. *"El test
  encontró un bug que ningún humano había visto."*
- `flutter widget-preview start` → los 4 estados en EN y ES sin correr la app.

## 5. Auditoría (2 min)

> Audita el cambio con flutter-auditor y flutter-a11y-auditor.

Señala: tooltip y 48 dp del botón ♥, rollback optimista, `dispose`, y un
hallazgo honesto que quede pendiente (p. ej. el color de la estrella
hardcodeado en `KinetixProductCard`). *"La IA hace el borrador; el merge es mío."*

## Plan B

| Si… | Haz… |
|---|---|
| El modelo tarda o se va por las ramas | `git stash && git checkout step-1-domain` (o `step-2-ui`, `final`) y explica el diff |
| No hay red | Muestra `final`: `flutter run`, previews y `flutter test` funcionan offline |
| El simulador no arranca | `flutter test` + `flutter widget-preview start` |
| Falla el MCP | Los mismos pasos con `flutter analyze` y `flutter test` en la terminal |

## Extras si sobra tiempo

- `tool/new_app.sh demo_app` → una app nueva nace con reglas, lints, checks e
  índice (bórrala después).
- Skill `dart-migrate-to-checks-package` sobre `test/domain/cart_test.dart`.
- Stitch: *"Lee el design system del proyecto Stitch de Kinetix y compáralo con
  `design/tokens.json`"* (requiere `STITCH_API_KEY`).
