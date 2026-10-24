# Kinetix

E-commerce de ropa deportiva (iOS/Android), bilingüe EN/ES. Las reglas comunes
están en el `AGENTS.md` raíz y en `.agents/rules/`; aquí solo lo propio.

## Stack

- Perfil de arquitectura: **Capas** (`team-architecture.md`).
- Estado: `provider` (`ChangeNotifier` + `MultiProvider` en `lib/main.dart`).
- Inyección: repositorios creados en `main.dart` y pasados por constructor.
- Datos: datasources **mock** en `lib/data/datasources/` (sin backend todavía).
- Navegación: rutas con nombre en `MaterialApp.routes` (`/`, `/cart`,
  `/checkout`, `/processing`, `/confirmation`, `/wishlist`). No migrar a go_router sin pedirlo.
- l10n: `lib/l10n/app_en.arb` / `app_es.arb` -> `lib/l10n/generated/`
  (`flutter gen-l10n`). Idioma conmutable con `LocaleProvider`.
- Fuentes: Montserrat (titulares) e Inter (texto) vía `google_fonts`.

## Diseño: Tactile Velour

- Spec visual completa: `design/DESIGN.md` (exportada de Stitch).
- Tokens: `design/tokens.json` -> `lib/core/theme/`.
- Componentes existentes: `design/components.md`. **Reutilízalos.**
- Superficies neumórficas con `NeumorphicDecorations` (raised / sunken); overlays
  glassmórficos con `KinetixGlassContainer`.

## Features

| Feature | Estado | Archivos clave |
|---|---|---|
| Catálogo + búsqueda + categorías | hecho | `catalog_provider.dart`, `catalog_home_screen.dart` |
| Detalle de producto con tallas | hecho | `product_detail_screen.dart` |
| Carrito + cupones | hecho | `cart_provider.dart`, `shopping_cart_screen.dart` |
| Checkout (Apple/Google Pay, tarjeta) | hecho | `checkout_provider.dart`, `checkout_payment_screen.dart` |
| Wishlist (estados sellados, optimista con rollback) | hecho | `wishlist_provider.dart`, `wishlist_screen.dart`, spec `docs/ai/specs/kinetix-wishlist.md` |

## Deuda conocida

- `CatalogProvider` usa `isLoading` + `errorMessage` en vez de estados sellados.
- Varios tests usan `expect`; los nuevos van con `package:checks`.
