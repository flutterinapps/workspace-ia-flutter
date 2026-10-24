# Kinetix E-Commerce Mobile Application Implementation Plan

Implement a complete, scalable, and production-ready mobile e-commerce application for **Kinetix** (sports apparel brand: discipline, dramatic, and exclusive). The application follows Clean Architecture principles in Flutter & Dart, supporting both iOS and Android with bilingual internationalization (EN/ES), native payment options (Apple Pay / Google Pay), modular reusable widgets, `provider` for state management, and design fidelity matching the **Tactile Velour / GlassFit** design system from Stitch project `projects/15101966332426023116`.

---

## User Review Required & Clarifications Incorporated

> [!IMPORTANT]
> - **State Management**: Using `provider` (`ChangeNotifierProvider`, `Consumer`, `context.watch`, `context.read`) as explicitly requested for clean reactive state management across catalog, cart, wishlist, payment, and locale.
> - **High Widget Reusability**: All UI components are modularized into a dedicated reusable component library under `presentation/widgets/` (Tactile text fields, buttons, neumorphic cards, chips, quantity controls, badges, dropdowns, and modal sheets).
> - **Testing & Simulator**: Utilizing Flutter testing rules and skills (`package:flutter_test`, `package:checks`) for unit/widget verification, followed by execution on the available iOS iPhone simulator.

---

## Architecture & Directory Structure

We will implement a **Clean Architecture** structure:

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart             # Color tokens (Tactile Velour design system)
│   │   ├── app_typography.dart         # Montserrat (Headlines) & Inter (Body/Labels)
│   │   ├── app_theme.dart              # ThemeData & ColorScheme configuration
│   │   └── neumorphic_decorations.dart # Dual-shadow neumorphic & glassmorphic utilities
│   ├── localization/
│   │   ├── app_localizations.dart      # EN & ES string dictionaries
│   │   └── app_localizations_delegate.dart
│   ├── utils/
│   │   └── currency_formatter.dart
│   └── constants/
│       └── app_constants.dart
├── domain/
│   ├── enums/
│   │   ├── product_category.dart       # Apparel, Footwear, Accessories, Equipment, Training
│   │   ├── product_size.dart           # XS, S, M, L, XL, EU Shoe sizes (40-45)
│   │   └── payment_method_type.dart    # ApplePay, GooglePay, CreditCard
│   ├── models/
│   │   ├── product.dart                # Has optional sizes list for apparel & footwear
│   │   ├── cart_item.dart
│   │   ├── cart.dart
│   │   ├── order.dart
│   │   ├── coupon.dart
│   │   └── product_catalog.dart        # Map<String, Product> catalog structure
│   └── repositories/
│       ├── product_repository.dart     # API-first interface (Search, List, Detail, Favorites)
│       ├── cart_repository.dart        # Add to cart, Update quantity, Apply coupon
│       ├── payment_repository.dart     # Native Pay & Card processing contract
│       └── order_repository.dart       # Create order & Email notification dispatch
├── data/
│   ├── datasources/
│   │   ├── mock_product_remote_datasource.dart # Realistic sports apparel & footwear data
│   │   ├── mock_cart_local_datasource.dart
│   │   └── mock_order_remote_datasource.dart
│   └── repositories_impl/
│       ├── product_repository_impl.dart
│       ├── cart_repository_impl.dart
│       ├── payment_repository_impl.dart
│       └── order_repository_impl.dart
├── presentation/
│   ├── providers/                      # Provider State Management (ChangeNotifiers)
│   │   ├── catalog_provider.dart       # Product search, filter, categories, detail state
│   │   ├── cart_provider.dart          # Cart items, size selections, quantity, coupon validation
│   │   ├── wishlist_provider.dart      # Saved favorite products
│   │   ├── checkout_provider.dart      # Payment methods (Apple/Google Pay, Card), order creation
│   │   └── locale_provider.dart        # App language switcher (ES / EN)
│   ├── widgets/                        # Modular Reusable Widget Library
│   │   ├── kinetix_card.dart           # Reusable Neumorphic raised & inset container
│   │   ├── kinetix_button.dart         # Reusable Primary, Secondary, & Glass buttons
│   │   ├── kinetix_text_field.dart     # Reusable tactile form input field with validation
│   │   ├── kinetix_product_card.dart   # Reusable product grid card with favorite & cart actions
│   │   ├── kinetix_category_chip.dart  # Reusable filter chip
│   │   ├── kinetix_size_selector.dart  # Reusable apparel & shoe size picker
│   │   ├── kinetix_quantity_picker.dart# Reusable (+) / (-) stepper widget
│   │   ├── kinetix_badge.dart          # Reusable status & pill tag
│   │   ├── kinetix_glass_container.dart# Reusable frosted glass overlay slab
│   │   ├── kinetix_native_pay_button.dart# Reusable Apple Pay & Google Pay native button
│   │   └── kinetix_app_bar.dart        # Reusable custom header with search & language toggle
│   └── screens/
│       ├── catalog_home_screen.dart    # Inicio - SportStore
│       ├── product_detail_screen.dart   # Detalle de Producto
│       ├── shopping_cart_screen.dart    # Carrito de Compras
│       ├── checkout_payment_screen.dart # Pago Seguro
│       ├── payment_processing_screen.dart # Proceso de Pago
│       └── order_confirmation_screen.dart # Orden Confirmada
└── main.dart
```

---

## Proposed Changes

### 1. Dependencies & Configuration (`pubspec.yaml`)

#### [MODIFY] [pubspec.yaml](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/pubspec.yaml)
- Add `provider: ^6.1.2` for reactive state management.
- Add `flutter_localizations` from SDK.
- Add `google_fonts: ^6.2.1` for Montserrat & Inter typography.
- Add `intl: ^0.19.0` for currency formatting.

---

### 2. Core Layer (Theme, Localization & Decorations)

#### [NEW] [app_colors.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/core/theme/app_colors.dart)
- Tactile Velour color palette:
  - Primary: `#9E3756` / `#D76483`
  - Secondary: `#8D4A52` / `#EF9CA4`
  - Surface/Background: `#FFF8F7`
  - Neumorphic Light Shadow: `#FFFFFF`
  - Neumorphic Dark Shadow: `#E8D6D8`
  - Outline: `#887175`
  - Glass Tint: `#FDE9EC`

#### [NEW] [app_typography.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/core/theme/app_typography.dart)
- Montserrat (Headlines) & Inter (Body/Labels) per design rules.

#### [NEW] [neumorphic_decorations.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/core/theme/neumorphic_decorations.dart)
- Tactile Neumorphic dual shadow decorations (Raised & Inset) and Glassmorphic border overlays.

#### [NEW] [app_localizations.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/core/localization/app_localizations.dart)
- i18n support in English (`en`) and Spanish (`es`) with automatic system language detection and manual toggle.

---

### 3. Domain Layer (Models & Repository Contracts)

#### [NEW] [product_category.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/domain/enums/product_category.dart)
- Categories: `all`, `apparel` (ropa), `footwear` (zapatillas), `accessories` (accesorios), `equipment` (equipamiento).

#### [NEW] [product_size.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/domain/enums/product_size.dart)
- Apparel (`XS`, `S`, `M`, `L`, `XL`) & Footwear (`EU 40`-`EU 45`).

#### [NEW] [product.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/domain/models/product.dart)
- Has optional size list for apparel & footwear; omitted/empty for accessories.

#### [NEW] [product_catalog.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/domain/models/product_catalog.dart)
- `Map<String, Product>` catalog data structure.

#### [NEW] [cart.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/domain/models/cart.dart) & [cart_item.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/domain/models/cart_item.dart)
- Items list, selected size/color, quantity, subtotal, discount, shipping, total calculation.

#### [NEW] [order.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/domain/models/order.dart) & [coupon.dart](file:///Users/flutterinapps/Documents/velapps/EngineerFlutterina/kinetix/lib/domain/models/coupon.dart)

#### [NEW] Repositories:
- `product_repository.dart`, `cart_repository.dart`, `payment_repository.dart`, `order_repository.dart`.

---

### 4. Data Layer (Sources & Implementation)

#### [NEW] Data Sources:
- `mock_product_remote_datasource.dart`, `mock_cart_local_datasource.dart`, `mock_order_remote_datasource.dart`.

#### [NEW] Repository Implementations:
- `product_repository_impl.dart`, `cart_repository_impl.dart`, `payment_repository_impl.dart`, `order_repository_impl.dart`.

---

### 5. Presentation Layer (Providers, Reusable Widgets & Screens)

#### Provider State Management:
- `catalog_provider.dart`: `ChangeNotifier` managing catalog loading, category filtering, search term, and product selection.
- `cart_provider.dart`: `ChangeNotifier` managing item additions, size/color parameters, quantity updates, coupon code validation (`KINETIX10`, `PROMO20`).
- `wishlist_provider.dart`: `ChangeNotifier` managing saved favorite products.
- `checkout_provider.dart`: `ChangeNotifier` managing selected payment method (Apple Pay, Google Pay, Card), shipping address, payment processing status, and order email dispatch.
- `locale_provider.dart`: `ChangeNotifier` managing active locale (`Locale('es')` / `Locale('en')`).

#### Highly Reusable Component Widget Library (`lib/presentation/widgets/`):
- `kinetix_card.dart`: Neumorphic card with customizable depth (`raised` vs `inset`), padding, and onPressed callback.
- `kinetix_button.dart`: Tactical button with variants (`primary`, `secondary`, `glass`, `outlined`).
- `kinetix_text_field.dart`: Sunken inset neumorphic text field with focus glow and validation.
- `kinetix_product_card.dart`: Product card displaying image, category, title, price, favorite heart button, and quick add.
- `kinetix_category_chip.dart`: Filter pill with active neumorphic/glass styling.
- `kinetix_size_selector.dart`: Reusable horizontal selector for apparel and shoe sizes.
- `kinetix_quantity_picker.dart`: Reusable stepper widget with `+` and `-` buttons.
- `kinetix_native_pay_button.dart`: Native look & feel payment trigger for Apple Pay and Google Pay.
- `kinetix_badge.dart`: Status tag pill for "Nuevo", "Edición Limitada", etc.
- `kinetix_glass_container.dart`: Reusable frosted glass slab widget with backdrop filter blur.

#### Screens:
1. `catalog_home_screen.dart` (Inicio)
2. `product_detail_screen.dart` (Detalle de Producto)
3. `shopping_cart_screen.dart` (Carrito de Compras)
4. `checkout_payment_screen.dart` (Pago Seguro)
5. `payment_processing_screen.dart` (Proceso de Pago)
6. `order_confirmation_screen.dart` (Orden Confirmada)

---

## Verification Plan

### Automated Tests
Write comprehensive unit and widget tests using `package:flutter_test`:
- `test/domain/product_model_test.dart`: Test product size validation (apparel/shoes have sizes, accessories do not).
- `test/domain/cart_test.dart`: Test subtotal calculation, coupon discounts (`KINETIX10`), shipping fee, and grand total.
- `test/presentation/cart_provider_test.dart`: Test cart item additions, quantity modifications, and item removal using `Provider`.
- `test/presentation/widgets/reusable_widgets_test.dart`: Test reusable widgets (`KinetixButton`, `KinetixCard`, `KinetixTextField`, `KinetixSizeSelector`).

Run tests command:
```bash
flutter test
```

### Manual & Simulator Verification
- Execute application check and compile verification:
  ```bash
  flutter analyze
  ```
- Run on iOS Simulator (iPhone 16 / available iOS simulator):
  ```bash
  flutter run -d ios
  ```
- Verify language switching (Spanish / English).
- Verify product size selector behavior (visible for hoodies/sneakers, hidden for duffel bags).
- Verify Apple Pay & Google Pay selection flow and email order dispatch simulation.
