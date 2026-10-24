import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/domain/models/product.dart';
import 'package:kinetix/l10n/generated/app_localizations.dart';
import 'package:kinetix/presentation/providers/recently_viewed_state.dart';
import 'package:kinetix/presentation/widgets/kinetix_mini_product_card.dart';
import 'package:kinetix/presentation/widgets/kinetix_recently_viewed_section.dart';

Future<void> _pump(
  WidgetTester tester,
  RecentlyViewedState state, {
  ValueChanged<Product>? onOpen,
  VoidCallback? onRetry,
  double textScale = 1,
}) {
  return tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          body: KinetixRecentlyViewedSection(
            state: state,
            onOpenProduct: onOpen ?? (_) {},
            onRetry: onRetry ?? () {},
          ),
        ),
      ),
    ),
  );
}

const _shoe = Product(
  id: 'shoe',
  title: 'Velour Runner',
  description: '',
  price: 180,
  imageUrl: '',
  category: ProductCategory.footwear,
);

void main() {
  testWidgets('Empty shows the hint', (tester) async {
    await _pump(tester, const RecentlyViewedEmpty());
    check(
      find.text('Los productos que abras aparecerán aquí.').evaluate(),
    ).length.equals(1);
  });

  testWidgets('Data shows one card per product and opens it', (tester) async {
    Product? opened;
    await _pump(
      tester,
      const RecentlyViewedData([_shoe]),
      onOpen: (product) => opened = product,
    );
    check(find.byType(KinetixMiniProductCard).evaluate()).length.equals(1);
    await tester.tap(find.byType(KinetixMiniProductCard));
    check(opened).equals(_shoe);
  });

  testWidgets('Error shows retry and calls it', (tester) async {
    var retried = false;
    await _pump(
      tester,
      const RecentlyViewedError(),
      onRetry: () => retried = true,
    );
    await tester.tap(find.text('Reintentar'));
    check(retried).isTrue();
  });

  testWidgets('Data layout survives text at 200%', (tester) async {
    await _pump(tester, const RecentlyViewedData([_shoe]), textScale: 2);
    check(tester.takeException()).isNull();
  });
}
