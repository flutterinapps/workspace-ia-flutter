# Guion de la demo — Kinetix

Rama de partida: `main`. Simulador iOS abierto y
`flutter run` corriendo en `apps/kinetix` **antes** de empezar.

## 0. Preparación (la noche anterior)

```bash
cd workspace-ia-flutter && git checkout main && tool/setup_ai.sh
cd apps/kinetix && flutter precache --ios && flutter build ios --simulator
open -a Simulator && flutter run      # deja la app abierta
```

- [ ] `claude` abre sin pedir login y sin errores de MCP (si sale el de GitHub, apágalo con `/mcp`). `gemini` con sesión iniciada
      (`GOOGLE_CLOUD_PROJECT` exportado) si lo vas a mostrar.
- [ ] Modo avión probado: todo lo de abajo salvo el modelo funciona offline.
- [ ] Ramas: `git branch -a` muestra `vistos-1-plan-y-datos`, `vistos-2-pantalla`,
      `vistos-3-terminado`, `precio-terminado` y `favoritos-3-con-errores`.

## 1. "¿Qué aprendiste?" (3 min)

En la raíz del workspace: `claude`

> ¿Qué reglas, skills, agentes y herramientas MCP cargaste de esta carpeta?

Escribe la pregunta completa. Solo "¿qué aprendiste?" se entiende como "¿qué
recuerdas de sesiones anteriores?" y la IA responde que no tiene memoria.

Qué señalar: las 9 reglas de siempre (no las 18), las skills solo por nombre,
los 4 agentes, el MCP `dart`. *"Esto no lo escribí en el prompt: lo trae el
espacio de trabajo."*

## 2. Spec antes que código (3 min)

Elige la ruta según los créditos de IA:

- **Con créditos — Vistos recientemente** (flujo completo):
  > /new-feature kinetix recently-viewed "fila de productos vistos recientemente en el catálogo: guarda los últimos productos que el usuario abrió y los muestra arriba, con estados de cargando, vacío, datos y error"

  Plan B: ramas `vistos-1-plan-y-datos` → `vistos-2-pantalla` → `vistos-3-terminado`.
- **Con pocos créditos — Ordenar por precio** (cambio pequeño):
  > /new-feature kinetix sort-by-price "ordenar el catálogo por precio: relevancia, menor a mayor y mayor a menor"

  Plan B: rama `precio-terminado`.

El agente `flutter-architect` escribe la spec en `docs/ai/specs/`.
Si la IA menciona la rama `favoritos-3-con-errores`: ahí está la lista de favoritos, un ejemplo con errores reales que
la IA encontró al revisarla. Es un buen momento para mostrar que la IA audita código existente.
Léela en voz alta 20 segundos: estados, contrato, casos borde, criterios.
Apruébala: *"Aprobada, sigue."*

## 3. Generación por capas (5 min)

Mientras trabaja, señala en pantalla:
- domain → data → provider → pantalla (una capa a la vez, regla `team-workflow`);
- el **hook** formatea y analiza cada `.dart` que toca (si hay un error, el
  agente lo ve y lo corrige solo);
- reutiliza `KinetixProductCard`, `KinetixButton`, `KinetixAppBar` (`design/components.md`).

## 4. Verificación cerrada (5 min)

- `hot_reload` vía MCP → en el simulador aparece el ♥ en el app bar.
- **Marionette** (el agente usa la app): copia el URI del VM service que imprime
  `flutter run` (`http://…/` → `ws://…/ws`) y pide:
  > Conéctate con marionette a ws://… , toca el corazón de los dos primeros
  > productos, abre Favoritos y haz una captura.
  El agente lista los elementos, toca, navega y te devuelve la captura.
  Hallazgo real para señalar: los botones ♥ de las tarjetas miden 37×37 y el
  selector de idioma 35×32, por debajo de los 48 dp de `team-a11y-inclusion.md`.
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
| Marionette no conecta | Revisa que el URI termine en `/ws` y que la app sea debug; si no, tócalo tú en el simulador |
| El modelo tarda o se va por las ramas | `git stash && git checkout vistos-1-plan-y-datos` (o `vistos-2-pantalla`, `vistos-3-terminado`; o `precio-terminado`) y luego `flutter pub get` (regenera los textos l10n); explica el diff |
| No hay red | Muestra `vistos-3-terminado`: `flutter run`, previews y `flutter test` funcionan offline |
| El simulador no arranca | `flutter test` + `flutter widget-preview start` |
| Falla el MCP | Los mismos pasos con `flutter analyze` y `flutter test` en la terminal |

## Extras si sobra tiempo

- `tool/new_app.sh demo_app` → una app nueva nace con reglas, lints, checks e
  índice (bórrala después).
- Skill `dart-migrate-to-checks-package` sobre `test/domain/cart_test.dart`.
- Stitch: *"Lee el design system del proyecto Stitch de Kinetix y compáralo con
  `design/tokens.json`"* (requiere `STITCH_API_KEY`).
