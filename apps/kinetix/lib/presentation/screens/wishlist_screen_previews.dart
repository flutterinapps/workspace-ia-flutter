import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/enums/product_category.dart';
import '../../domain/models/product.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers/wishlist_state.dart';
import 'wishlist_screen.dart';

/// Previews every [WishlistState] in English and Spanish.
///
/// Run `flutter widget-preview start` in `apps/kinetix`.
final class WishlistPreview extends MultiPreview {
  const WishlistPreview(this.state);

  final String state;

  @override
  List<Preview> get previews => [
    Preview(
      group: 'Wishlist',
      name: '$state · EN',
      size: const Size(390, 720),
      wrapper: kinetixPreviewWrapper,
      localizations: englishLocalizations,
    ),
    Preview(
      group: 'Wishlist',
      name: '$state · ES',
      size: const Size(390, 720),
      wrapper: kinetixPreviewWrapper,
      localizations: spanishLocalizations,
    ),
  ];
}

Widget kinetixPreviewWrapper(Widget child) => Theme(
  data: AppTheme.lightTheme,
  child: Material(
    color: AppTheme.lightTheme.scaffoldBackgroundColor,
    child: child,
  ),
);

PreviewLocalizationsData englishLocalizations() =>
    _localizations(const Locale('en'));

PreviewLocalizationsData spanishLocalizations() =>
    _localizations(const Locale('es'));

PreviewLocalizationsData _localizations(Locale locale) =>
    PreviewLocalizationsData(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );

const _sampleProducts = [
  Product(
    id: 'preview-1',
    title: 'Velour Runner',
    description: 'Lightweight running shoe',
    price: 180,
    imageUrl: '',
    category: ProductCategory.footwear,
    isNew: true,
  ),
  Product(
    id: 'preview-2',
    title: 'Tactile Hoodie',
    description: 'Brushed fleece hoodie',
    price: 95,
    imageUrl: '',
    category: ProductCategory.apparel,
    isLimitedEdition: true,
  ),
];

WishlistView _view(WishlistState state) => WishlistView(
  state: state,
  onRetry: () {},
  onExplore: () {},
  onToggleFavorite: (_) {},
  onOpenProduct: (_) {},
);

@WishlistPreview('Loading')
Widget wishlistLoadingPreview() => _view(const WishlistLoading());

@WishlistPreview('Empty')
Widget wishlistEmptyPreview() => _view(const WishlistEmpty());

@WishlistPreview('Data')
Widget wishlistDataPreview() => _view(const WishlistData(_sampleProducts));

@WishlistPreview('Error')
Widget wishlistErrorPreview() => _view(const WishlistError('offline'));
