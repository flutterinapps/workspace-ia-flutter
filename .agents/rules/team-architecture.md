---
trigger: always_on
---

# Arquitectura del equipo (prioridad sobre `flutter-*.md`)

Si una regla `flutter-*.md` **o una skill oficial** (por ejemplo
`flutter-apply-architecture-best-practices`) contradice este archivo, gana este
archivo. Por ejemplo: las reglas oficiales prefieren el estado nativo de
Flutter; el equipo usa `provider` como estándar.

## Capas (Clean Architecture)

```
lib/
  core/          theme, constants, utils, errores compartidos
  domain/        models (inmutables), enums, repositories (abstract)
  data/          datasources (remote/local/mock), repositories_impl
  presentation/  providers (ChangeNotifier), screens, widgets reutilizables
  l10n/          arb EN/ES
```

Flujo obligatorio: `Widget -> Provider -> Repository (abstract) -> RepositoryImpl -> DataSource`.

- `domain` no importa Flutter ni `data`. Los contratos devuelven tipos de dominio.
- `presentation` depende solo de contratos de `domain`; la implementación se
  inyecta en `main.dart` (inyección por constructor + `MultiProvider`).
- Un widget nunca llama a un datasource, a HTTP ni a almacenamiento.

## Estado

- Un `ChangeNotifier` por feature en `presentation/providers/`.
- Estados de pantalla explícitos con `sealed class`:
  `XLoading`, `XEmpty`, `XData`, `XError`. La UI hace `switch` exhaustivo.
- Nada de lógica en `build()`: solo lectura de estado y composición de widgets.
- Todo `TextEditingController`, `AnimationController`, `StreamSubscription` o
  listener se libera en `dispose()`.

## Widgets

- Componentes reutilizables en `presentation/widgets/` con prefijo de la app
  (`kinetix_button.dart`). Antes de crear uno, busca si ya existe.
- `const` siempre que se pueda; widgets pequeños en clases, no en métodos
  `_buildX()`.
- Layout por restricciones (`Flex`, `Expanded`, `LayoutBuilder`), nunca tamaños
  fijos de pantalla.

## Perfiles: cada app elige el suyo

Este archivo describe el **perfil por defecto**. Cada app declara en su
`AGENTS.md` qué perfil usa, y el agente lo respeta (no migra una app a otro
perfil sin que se lo pidan):

| Perfil | Cuándo | Estructura |
|---|---|---|
| **Capas** (por defecto) | Apps nuevas sin preferencia | La de este archivo: `domain/ data/ presentation/` |
| **MVVM oficial** | El cliente o el proyecto sigue la guía de Flutter | Tal cual `flutter-apply-architecture-best-practices`: `ui/features/<f>/{view_models,views}`, `data/{services,repositories}`, `domain/` |
| **Bloc** | La app ya usa `flutter_bloc` | `presentation/bloc/{feature}_bloc.dart`, `_event.dart`, `_state.dart` |

En todos los perfiles aplican igual: estados explícitos, nada de lógica en
`build()`, `dispose()`, tests con `checks`, `@Preview`, l10n y accesibilidad.

## Equivalencias con `flutter-apply-architecture-best-practices` (perfil Capas)

La skill oficial y este estándar coinciden en lo esencial (capas separadas,
`ChangeNotifier`, repositorio como fuente única, inyección por constructor,
casos de uso solo si hacen falta). Cuando la uses, traduce así:

| Skill oficial dice | En este equipo |
|---|---|
| `ui/features/<f>/view_models/` y `views/` | `presentation/providers/` y `presentation/screens/` |
| `ui/core/` | `presentation/widgets/` y `core/theme/` |
| ViewModel | Provider (`ChangeNotifier`); mismo rol |
| `data/services/` | `data/datasources/` |
| Repositorio concreto en `data/repositories/` | Contrato **abstracto** en `domain/repositories/` + implementación en `data/repositories_impl/` |
| Estado con `isLoading` y campos nulos | `sealed class` `Loading/Empty/Data/Error` con `switch` exhaustivo |
| `try/finally` sin capturar el error | Todo error termina en un estado `Error` visible con acción |
| Modelos con `freezed` o `built_value` | Clases inmutables con `equatable`; no se añade generación de código sin decidirlo |
| `ListenableBuilder` con el ViewModel por constructor | `context.watch`/`select` con `MultiProvider`; la vista pura recibe estado y callbacks (ver `WishlistView` en la rama `favoritos-3-con-errores`) |
| Paso 8: tests del ViewModel y repositorio | Lo mismo **más** widget test, `@Preview` y `package:checks` |

