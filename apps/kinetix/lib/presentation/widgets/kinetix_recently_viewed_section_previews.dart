import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/enums/product_category.dart';
import '../../domain/models/product.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers/recently_viewed_state.dart';
import 'kinetix_recently_viewed_section.dart';

/// Previews every [RecentlyViewedState] in English and Spanish.
///
/// Run `flutter widget-preview start` in `apps/kinetix`.
final class RecentlyViewedPreview extends MultiPreview {
  const RecentlyViewedPreview(this.state);

  final String state;

  @override
  List<Preview> get previews => [
    Preview(
      group: 'Recently viewed',
      name: '$state · EN',
      size: const Size(390, 280),
      wrapper: recentlyViewedPreviewWrapper,
      localizations: recentlyViewedEnglish,
    ),
    Preview(
      group: 'Recently viewed',
      name: '$state · ES',
      size: const Size(390, 280),
      wrapper: recentlyViewedPreviewWrapper,
      localizations: recentlyViewedSpanish,
    ),
  ];
}

Widget recentlyViewedPreviewWrapper(Widget child) => Theme(
  data: AppTheme.lightTheme,
  child: Material(
    color: AppTheme.lightTheme.scaffoldBackgroundColor,
    child: child,
  ),
);

PreviewLocalizationsData recentlyViewedEnglish() =>
    _localizations(const Locale('en'));

PreviewLocalizationsData recentlyViewedSpanish() =>
    _localizations(const Locale('es'));

PreviewLocalizationsData _localizations(Locale locale) =>
    PreviewLocalizationsData(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );

const _sample = [
  Product(
    id: 'preview-1',
    title: 'Velour Runner',
    description: 'Running shoe',
    price: 180,
    imageUrl: '',
    category: ProductCategory.footwear,
  ),
  Product(
    id: 'preview-2',
    title: 'Tactile Compression Hoodie',
    description: 'Hoodie',
    price: 129.5,
    imageUrl: '',
    category: ProductCategory.apparel,
  ),
  Product(
    id: 'preview-3',
    title: 'AeroFit Training Shorts',
    description: 'Shorts',
    price: 54.99,
    imageUrl: '',
    category: ProductCategory.apparel,
  ),
];

Widget _section(RecentlyViewedState state) => KinetixRecentlyViewedSection(
  state: state,
  onOpenProduct: (_) {},
  onRetry: () {},
);

@RecentlyViewedPreview('Loading')
Widget recentlyViewedLoadingPreview() =>
    _section(const RecentlyViewedLoading());

@RecentlyViewedPreview('Empty')
Widget recentlyViewedEmptyPreview() => _section(const RecentlyViewedEmpty());

@RecentlyViewedPreview('Data')
Widget recentlyViewedDataPreview() =>
    _section(const RecentlyViewedData(_sample));

@RecentlyViewedPreview('Error')
Widget recentlyViewedErrorPreview() => _section(const RecentlyViewedError());
