import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide isEmpty;
import 'package:kinetix/data/repositories_impl/cart_repository_impl.dart';
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/l10n/generated/app_localizations.dart';
import 'package:kinetix/presentation/providers/cart_provider.dart';
import 'package:kinetix/presentation/providers/catalog_provider.dart';
import 'package:kinetix/presentation/providers/locale_provider.dart';
import 'package:kinetix/presentation/providers/wishlist_provider.dart';
import 'package:kinetix/presentation/screens/catalog_home_screen.dart';
import 'package:kinetix/presentation/widgets/kinetix_product_card.dart';
import 'package:provider/provider.dart';

import '../fakes/fake_product_repository.dart';

Widget _catalogApp() => MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => CatalogProvider(
        FakeProductRepository([
          fakeProduct('mid', 50, ProductCategory.footwear),
          fakeProduct('cheap', 10, ProductCategory.apparel),
          fakeProduct('pricey', 90, ProductCategory.equipment),
        ]),
      ),
    ),
    ChangeNotifierProvider(create: (_) => WishlistProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider(CartRepositoryImpl())),
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
  ],
  child: const MaterialApp(
    locale: Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: CatalogHomeScreen(),
  ),
);

String _firstProductId(WidgetTester tester) => tester
    .widget<KinetixProductCard>(find.byType(KinetixProductCard).first)
    .product
    .id;

void main() {
  testWidgets('changing the sort reorders the catalog grid', (tester) async {
    await tester.pumpWidget(_catalogApp());
    await tester.pumpAndSettle();
    check(_firstProductId(tester)).equals('mid');

    await tester.tap(find.byTooltip('Sort'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: high to low'));
    await tester.pumpAndSettle();
    check(_firstProductId(tester)).equals('pricey');

    await tester.tap(find.byTooltip('Sort'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: low to high'));
    await tester.pumpAndSettle();
    check(_firstProductId(tester)).equals('cheap');
  });

  testWidgets('sort button meets the 48 dp touch target', (tester) async {
    await tester.pumpWidget(_catalogApp());
    await tester.pumpAndSettle();

    final handle = tester.ensureSemantics();
    final rect = tester.getSemantics(find.byTooltip('Sort')).rect;
    handle.dispose();

    check(rect.width).isGreaterOrEqual(kMinInteractiveDimension);
    check(rect.height).isGreaterOrEqual(kMinInteractiveDimension);
  });
}
