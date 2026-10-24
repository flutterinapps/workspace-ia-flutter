---
name: flutter-feature-slice
description: Genera una feature completa de Flutter siguiendo la arquitectura del equipo (contrato de repositorio, implementación, provider con estados sellados, pantalla, l10n, widget preview y tests con package:checks). Úsala cuando pidan "crea la feature X", "añade la pantalla X con sus estados" o al ejecutar /new-feature.
---

# Feature slice

Construye una feature de punta a punta, capa por capa, y no la des por terminada
hasta que el analizador y los tests estén en verde.

## Entradas

- App destino (`apps/<app>/`) y nombre de la feature en `snake_case`.
- Spec en `docs/ai/specs/<app>-<feature>.md`. Si no existe, escríbela primero
  (objetivo, estados, datos, casos borde, criterios de aceptación) y pide
  aprobación antes de seguir.

## Checklist (cópiala y márcala mientras avanzas)

- [ ] 1. **Explorar**: lee `apps/<app>/AGENTS.md`, los providers y widgets
      existentes. Lista lo que vas a reutilizar.
- [ ] 2. **Domain**: `lib/domain/repositories/<feature>_repository.dart`
      (abstract, tipos de dominio, sin Flutter).
- [ ] 3. **Data**: datasource mock en `lib/data/datasources/` con latencia
      simulada y forma de forzar error; `lib/data/repositories_impl/<feature>_repository_impl.dart`.
- [ ] 4. **Estado**: `lib/presentation/providers/<feature>_provider.dart`
      con `sealed class <Feature>State` → `Loading | Empty | Data | Error`.
      Repositorio inyectado por constructor.
- [ ] 5. **UI**: `lib/presentation/screens/<feature>_screen.dart` con `switch`
      exhaustivo sobre el estado; reutiliza `presentation/widgets/`; nada de
      lógica en `build()`; estados vacío y error con acción.
- [ ] 6. **l10n**: claves nuevas en `app_en.arb` y `app_es.arb`;
      `flutter gen-l10n`.
- [ ] 7. **Cableado**: provider en el `MultiProvider` y ruta en `main.dart`;
      punto de entrada visible (botón/ícono) en la pantalla que corresponda.
- [ ] 8. **Preview**: `@Preview` de la pantalla en cada estado (usa la skill
      `flutter-add-widget-preview`), claro y oscuro.
- [ ] 9. **Tests**: unit tests del provider (todos los estados y transiciones)
      con `package:checks`; widget test de la pantalla (vacío y con datos).
- [ ] 10. **Verificar**: `dart_format`, `analyze_files`, `run_tests` (Dart MCP)
      o `flutter analyze && flutter test`. Si hay app corriendo, `hot_reload`
      y `get_runtime_errors`.
- [ ] 11. **Resumen**: archivos creados/modificados, decisiones y cómo probarlo.

## Plantilla de estado

```dart
sealed class WishlistState {
  const WishlistState();
}

final class WishlistLoading extends WishlistState {
  const WishlistLoading();
}

final class WishlistEmpty extends WishlistState {
  const WishlistEmpty();
}

final class WishlistData extends WishlistState {
  const WishlistData(this.items);
  final List<Product> items;
}

final class WishlistError extends WishlistState {
  const WishlistError(this.message);
  final String message;
}
```

## Plantilla de test con checks

```dart
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

test('emits Empty when repository has no items', () async {
  final provider = WishlistProvider(FakeWishlistRepository(items: []));
  await provider.load();
  check(provider.state).isA<WishlistEmpty>();
});
```

## Errores comunes

- Crear un widget que ya existe con otro nombre: busca primero.
- Strings literales en la UI: todo va a `l10n`.
- Olvidar `notifyListeners()` tras cambiar de estado, o llamarlo después de
  `dispose()` (guarda un flag `_disposed`).
