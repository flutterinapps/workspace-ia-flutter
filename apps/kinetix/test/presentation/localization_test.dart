import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetix/domain/enums/product_category.dart';
import 'package:kinetix/l10n/generated/app_localizations.dart';
import 'package:kinetix/main.dart';
import 'package:kinetix/presentation/providers/locale_provider.dart';

void main() {
  group('AppLocalizations', () {
    test('supports Spanish and English', () {
      expect(
        AppLocalizations.supportedLocales.map((l) => l.languageCode),
        containsAll(<String>['es', 'en']),
      );
    });

    test('resolves Spanish strings', () {
      final loc = lookupAppLocalizations(const Locale('es'));
      expect(loc.featured, 'Destacados');
      expect(loc.addToCart, 'Añadir al Carrito');
      expect(loc.freeShipping, '¡Envío Gratis!');
      expect(loc.payWith(loc.applePay), 'Pagar con Apple Pay');
    });

    test('resolves English strings', () {
      final loc = lookupAppLocalizations(const Locale('en'));
      expect(loc.featured, 'Featured Products');
      expect(loc.addToCart, 'Add to Cart');
      expect(loc.freeShipping, 'Free Shipping!');
      expect(loc.payWith(loc.applePay), 'Pay with Apple Pay');
    });

    test('category labels follow the active locale', () {
      final es = lookupAppLocalizations(const Locale('es'));
      final en = lookupAppLocalizations(const Locale('en'));
      expect(ProductCategory.footwear.label(es), 'Calzado');
      expect(ProductCategory.footwear.label(en), 'Footwear');
    });
  });

  group('LocaleProvider', () {
    test('starts in Spanish and toggles to English and back', () {
      final provider = LocaleProvider();
      expect(provider.locale.languageCode, 'es');
      provider.toggleLanguage();
      expect(provider.locale.languageCode, 'en');
      provider.toggleLanguage();
      expect(provider.locale.languageCode, 'es');
    });
  });

  testWidgets('catalog screen swaps language when the toggle is tapped',
      (tester) async {
    await tester.pumpWidget(const KinetixApp());
    await tester.pumpAndSettle();

    expect(find.text('Destacados'), findsOneWidget);
    expect(find.text('Todos'), findsOneWidget);

    await tester.tap(find.text('ES'));
    await tester.pumpAndSettle();

    expect(find.text('Featured Products'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Destacados'), findsNothing);
  });
}
