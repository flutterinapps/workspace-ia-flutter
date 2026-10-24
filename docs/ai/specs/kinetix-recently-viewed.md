# Spec — Kinetix · Vistos recientemente

## Objetivo

Que la persona vuelva rápido a lo que ya miró: una fila "Vistos recientemente"
arriba del catálogo con los últimos productos que abrió, del más nuevo al más
antiguo.

Fuera de alcance: guardar entre sesiones (por ahora vive en memoria), sincronizar
con un backend, borrar el historial.

## Reglas

- Se registra un producto cada vez que se abre su detalle desde el catálogo.
- Sin duplicados: si se vuelve a abrir uno que ya está, pasa al primer lugar.
- Máximo 8 productos; al llegar al límite se descarta el más antiguo.

## Estados de la fila

| Estado | Cuándo | UI |
|---|---|---|
| `RecentlyViewedLoading` | Al abrir el catálogo, mientras responde el repositorio | Indicador pequeño |
| `RecentlyViewedEmpty` | Todavía no se abrió ningún producto | Texto: "Los productos que abras aparecerán aquí." |
| `RecentlyViewedData(items)` | Hay al menos uno | Fila horizontal de tarjetas compactas |
| `RecentlyViewedError` | Falla el repositorio | Mensaje traducido y botón "Reintentar" (nunca el texto técnico del error) |

## Contrato

```dart
abstract class RecentlyViewedRepository {
  Future<List<Product>> getRecent();
  Future<void> add(Product product);
}
```

`RecentlyViewedRepositoryImpl` aplica las reglas (sin duplicados, máximo 8).
`RecentlyViewedProvider(RecentlyViewedRepository)` expone `state`, `load()` y
`add(product)`; si `add` falla, la fila queda como estaba.

## Archivos

- domain: `repositories/recently_viewed_repository.dart`
- data: `datasources/mock_recently_viewed_local_datasource.dart`,
  `repositories_impl/recently_viewed_repository_impl.dart`
- presentation: `providers/recently_viewed_state.dart`,
  `providers/recently_viewed_provider.dart`,
  `widgets/kinetix_mini_product_card.dart`,
  `widgets/kinetix_recently_viewed_section.dart` (+ previews)
- `catalog_home_screen.dart`: la sección arriba de "Destacados" y el registro al
  abrir un producto; `main.dart`: inyección del repositorio.
- l10n EN/ES: `recentlyViewed`, `recentlyViewedEmpty`, `recentlyViewedError`, `retry`.

## Casos borde e inclusión

- Tarjeta compacta con área táctil ≥ 48 dp y `Semantics` con nombre y precio.
- La fila aguanta texto al 200 % (altura flexible, título de 2 líneas con elipsis).
- Imagen que no carga: ícono de respaldo, como en la tarjeta del catálogo.

## Criterios de aceptación

- Unit tests (checks) del repositorio: orden, sin duplicados, máximo 8.
- Unit tests del provider: Loading→Empty, Loading→Data, Loading→Error, `add`
  pone el producto primero, `add` que falla no cambia la fila.
- Widget tests de la sección: vacío, datos y error con "Reintentar".
- `@Preview` de la sección en sus estados, en EN y ES.
- `flutter analyze` 0 issues y `flutter test` en verde.
