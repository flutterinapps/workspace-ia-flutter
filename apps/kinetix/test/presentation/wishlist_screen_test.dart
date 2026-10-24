import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/domain/models/product.dart';
import 'package:kinetix/l10n/generated/app_localizations.dart';
import 'package:kinetix/presentation/providers/wishlist_state.dart';
import 'package:kinetix/presentation/screens/wishlist_screen.dart';
import 'package:kinetix/presentation/widgets/kinetix_product_card.dart';

Future<void> _pumpView(
  WidgetTester tester,
  WishlistState state, {
  VoidCallback? onRetry,
  VoidCallback? onExplore,
}) {
  return tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: WishlistView(
          state: state,
          onRetry: onRetry ?? () {},
          onExplore: onExplore ?? () {},
          onToggleFavorite: (_) {},
          onOpenProduct: (_) {},
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('Empty shows the explore action', (tester) async {
    var explored = false;
    await _pumpView(
      tester,
      const WishlistEmpty(),
      onExplore: () => explored = true,
    );

    await tester.tap(find.text('Explorar catálogo'));
    check(explored).isTrue();
  });

  testWidgets('Error shows retry and calls it', (tester) async {
    var retried = false;
    await _pumpView(
      tester,
      const WishlistError('offline'),
      onRetry: () => retried = true,
    );

    await tester.tap(find.text('Reintentar'));
    check(retried).isTrue();
  });

  testWidgets('Data shows one card per favorite', (tester) async {
    await _pumpView(
      tester,
      const WishlistData([
        Product(
          id: 'shoe',
          title: 'Velour Runner',
          description: 'Running shoe',
          price: 180,
          imageUrl: '',
          category: ProductCategory.footwear,
        ),
      ]),
    );

    check(find.byType(KinetixProductCard).evaluate().length).equals(1);
  });
}
