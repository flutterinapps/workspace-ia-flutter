---
trigger: always_on
---

# Arquitectura del equipo (prioridad sobre `flutter-*.md`)

Si una regla `flutter-*.md` contradice este archivo, gana este archivo. Por
ejemplo: las reglas oficiales prefieren el estado nativo de Flutter; el equipo
usa `provider` como estándar.

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

## Perfil alternativo: Bloc

Solo si la app ya usa `flutter_bloc` (lo dice su `AGENTS.md`):
`presentation/bloc/{feature}_bloc.dart`, `_event.dart`, `_state.dart`.
