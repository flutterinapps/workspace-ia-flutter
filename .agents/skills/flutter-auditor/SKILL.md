---
name: flutter-auditor
description: Audita cambios de Flutter antes del merge (rendimiento, arquitectura, ciclo de vida, accesibilidad, inclusión, i18n, seguridad) y devuelve hallazgos priorizados con archivo:línea. Úsala cuando pidan "revisa", "audita", "¿esto está listo para merge?" o al final de /new-feature.
---

# Auditor Flutter: el ingeniero como revisor

La IA acelera el borrador; la responsabilidad del merge sigue siendo humana.
Esta skill hace la primera pasada con criterio de equipo.

## Alcance

Por defecto, el diff actual: `git diff` + archivos nuevos (`git status`).

## Checklist

**Arquitectura**
- [ ] Widgets no importan `data/` ni hacen I/O.
- [ ] `domain/` no importa Flutter.
- [ ] Estados de pantalla con `sealed class` y `switch` exhaustivo.

**Rendimiento**
- [ ] `const` donde se puede; sin `_buildX()` que debería ser widget.
- [ ] `context.watch` solo donde se pinta; `context.read` en callbacks;
      `Selector`/`select` si solo importa un campo.
- [ ] Listas largas con `ListView.builder`/`SliverList`.
- [ ] Sin trabajo pesado ni `Future` creado dentro de `build()`.

**Ciclo de vida**
- [ ] Controllers, subscriptions y listeners liberados en `dispose()`.
- [ ] Sin `BuildContext` usado tras un `await` sin comprobar `mounted`.

**Accesibilidad e inclusión** (detalle: agente `flutter-a11y-auditor`)
- [ ] Targets ≥ 48 dp, `Semantics`/`tooltip` en iconos, contraste AA.
- [ ] Validadores inclusivos; textos en `l10n` EN/ES.

**Diseño**
- [ ] Sin colores, tamaños de fuente o espaciados hardcodeados.

**Seguridad**
- [ ] Sin claves ni secretos; salida de modelos de IA validada.

**Pruebas**
- [ ] Tests del provider en todos los estados; widget test; `@Preview`.
- [ ] `flutter analyze` y `flutter test` en verde (ejecútalos, no supongas).

## Formato de salida

Tabla ordenada por severidad: `Severidad | archivo:línea | Problema | Arreglo`.
Termina con un veredicto: **Listo para merge** o **Requiere cambios** (lista
corta). No edites archivos salvo que te lo pidan.
