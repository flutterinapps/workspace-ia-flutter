import '../../l10n/generated/app_localizations.dart';

enum ProductCategory { all, apparel, footwear, accessories, equipment }

extension ProductCategoryExtension on ProductCategory {
  String label(AppLocalizations loc) {
    switch (this) {
      case ProductCategory.all:
        return loc.catAll;
      case ProductCategory.apparel:
        return loc.catApparel;
      case ProductCategory.footwear:
        return loc.catFootwear;
      case ProductCategory.accessories:
        return loc.catAccessories;
      case ProductCategory.equipment:
        return loc.catEquipment;
    }
  }
}
