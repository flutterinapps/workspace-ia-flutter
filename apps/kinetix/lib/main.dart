import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'data/repositories_impl/product_repository_impl.dart';
import 'data/repositories_impl/cart_repository_impl.dart';
import 'data/repositories_impl/payment_repository_impl.dart';
import 'data/repositories_impl/order_repository_impl.dart';
import 'data/repositories_impl/recently_viewed_repository_impl.dart';

import 'presentation/providers/catalog_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/wishlist_provider.dart';
import 'presentation/providers/checkout_provider.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/providers/recently_viewed_provider.dart';

import 'presentation/screens/catalog_home_screen.dart';
import 'presentation/screens/shopping_cart_screen.dart';
import 'presentation/screens/checkout_payment_screen.dart';
import 'presentation/screens/payment_processing_screen.dart';
import 'presentation/screens/order_confirmation_screen.dart';

void main() {
  // Lets AI agents drive the running app through marionette_mcp. Debug only:
  // release builds keep the default binding.
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  runApp(const KinetixApp());
}

class KinetixApp extends StatelessWidget {
  const KinetixApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Shared Repository Instances
    final productRepo = ProductRepositoryImpl();
    final cartRepo = CartRepositoryImpl();
    final paymentRepo = PaymentRepositoryImpl();
    final orderRepo = OrderRepositoryImpl();
    final recentlyViewedRepo = RecentlyViewedRepositoryImpl();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => CatalogProvider(productRepo)),
        ChangeNotifierProvider(create: (_) => CartProvider(cartRepo)),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(
          create: (_) => RecentlyViewedProvider(recentlyViewedRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => CheckoutProvider(paymentRepo, orderRepo),
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Kinetix SportStore',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routes: {
              '/': (context) => const CatalogHomeScreen(),
              '/cart': (context) => const ShoppingCartScreen(),
              '/checkout': (context) => const CheckoutPaymentScreen(),
              '/processing': (context) => const PaymentProcessingScreen(),
              '/confirmation': (context) => const OrderConfirmationScreen(),
            },
          );
        },
      ),
    );
  }
}
