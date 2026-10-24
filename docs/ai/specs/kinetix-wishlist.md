# Spec — Kinetix · Wishlist

## Objetivo

Que la persona guarde productos con ♥ y los vea en una pantalla propia, con los
estados de carga, vacío, datos y error bien resueltos. Hoy `WishlistProvider`
guarda favoritos en memoria sin repositorio, sin estados y sin pantalla.

Fuera de alcance: sincronizar con backend, compartir la lista, notificaciones
de precio.

## Estados de la pantalla

| Estado | Cuándo | UI |
|---|---|---|
| `WishlistLoading` | Al abrir, mientras el repositorio responde | Indicador centrado |
| `WishlistEmpty` | Sin favoritos | Icono, título, texto y botón "Explorar catálogo" |
| `WishlistData(items)` | ≥1 favorito | Grid 2 columnas con `KinetixProductCard` (♥ activo) |
| `WishlistError(message)` | El repositorio falla | Mensaje y botón "Reintentar" |

Transiciones: `Loading -> Empty | Data | Error`; quitar el último favorito en
`Data` -> `Empty`; "Reintentar" -> `Loading`.

## Contrato

```dart
abstract class WishlistRepository {
  Future<List<Product>> getFavorites();
  Future<void> addFavorite(Product product);
  Future<void> removeFavorite(String productId);
}
```

Provider: `WishlistProvider(WishlistRepository)` expone `state`, `load()`,
`isFavorite(id)` y `toggleFavorite(product)` (optimista: actualiza la UI y
revierte si el repositorio falla). Mantiene la API que ya usan catálogo y
detalle.

## Archivos

- domain: `repositories/wishlist_repository.dart`
- data: `datasources/mock_wishlist_local_datasource.dart`,
  `repositories_impl/wishlist_repository_impl.dart`
- presentation: `providers/wishlist_state.dart`, `providers/wishlist_provider.dart`
  (reescrito), `screens/wishlist_screen.dart`, `screens/wishlist_screen.previews.dart`;
  `widgets/kinetix_app_bar.dart` (botón ♥ con contador)
- `main.dart`: inyección del repositorio y ruta `/wishlist`
- l10n: claves `wishlist*` y `retry` en EN/ES

## Casos borde e inclusión

- Botón ♥ del app bar con `tooltip`/`Semantics` y área ≥ 48 dp.
- Contador del badge legible con texto al 200%.
- Error del repositorio al quitar un favorito: se revierte y no se pierde el producto.
- `notifyListeners()` nunca después de `dispose()`.

## Criterios de aceptación

- Unit tests del provider (checks): Loading->Empty, Loading->Data,
  Loading->Error, toggle añade/quita, quitar el último -> Empty, rollback ante error.
- Widget tests: vacío muestra "Explorar catálogo"; con datos muestra las cards;
  error muestra "Reintentar".
- `@Preview` de los 4 estados en EN y ES.
- `flutter analyze` 0 issues, `flutter test` en verde.
