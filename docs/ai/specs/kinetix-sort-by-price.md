# Spec: Kinetix — Ordenar por precio

## Objetivo

Que quien compra pueda ordenar el catálogo por precio sin perder la categoría
ni la búsqueda que ya eligió.

## Opciones (`ProductSort`, en `lib/domain/enums/product_sort.dart`)

| Valor | Etiqueta EN | Etiqueta ES |
|---|---|---|
| `relevance` (por defecto) | Relevance | Relevancia |
| `priceLowToHigh` | Price: low to high | Precio: menor a mayor |
| `priceHighToLow` | Price: high to low | Precio: mayor a menor |

## Dónde se ordena y por qué

En `CatalogProvider`, sobre la lista que ya devolvió el repositorio filtrada por
categoría y búsqueda. Es lo más simple que respeta `team-architecture.md`:

- El contrato `ProductRepository` no cambia (el filtro es del dato; el orden es
  una preferencia de presentación de una lista que ya está en memoria).
- Cambiar el orden **no** vuelve a llamar al repositorio: es instantáneo y no
  muestra el loader.
- El provider guarda la lista original, así `relevance` restaura el orden del
  repositorio.
- El enum vive en `domain` y no importa Flutter; su etiqueta l10n vive en
  `presentation`.

## UI

Botón de icono (`PopupMenuButton`, icono `sort`) a la derecha del título
"Destacados", con `tooltip` "Ordenar" (área táctil de 48 dp del `IconButton`).
El menú marca la opción activa. Colores y tipografía salen del theme.

## Casos borde

- Precios iguales: orden **estable** (se conserva el orden original entre ellos).
- Lista vacía: no falla; se ve el estado vacío de siempre.
- Cambiar categoría o búsqueda conserva el orden elegido.
- Elegir la opción ya activa no notifica.

## Criterios de aceptación

1. Con `priceLowToHigh` el primer producto es el más barato del filtro actual.
2. Con `priceHighToLow` el primero es el más caro.
3. Con `relevance` el orden es el del repositorio.
4. El orden se mantiene al cambiar categoría o búsqueda.
5. Textos en EN y ES; `flutter analyze` sin issues y `flutter test` en verde
   (unit tests del provider y widget test con `package:checks`).
