import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/recently_viewed_provider.dart';
import '../providers/wishlist_provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/enums/product_category.dart';
import '../../domain/models/product.dart';
import '../widgets/kinetix_app_bar.dart';
import '../widgets/kinetix_product_card.dart';
import '../widgets/kinetix_category_chip.dart';
import '../widgets/kinetix_recently_viewed_section.dart';
import '../widgets/kinetix_text_field.dart';
import 'product_detail_screen.dart';
import 'shopping_cart_screen.dart';

class CatalogHomeScreen extends StatelessWidget {
  const CatalogHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final catalogProvider = context.watch<CatalogProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();
    final recentlyViewed = context.watch<RecentlyViewedProvider>();

    void openProduct(Product product) {
      catalogProvider.selectProduct(product);
      context.read<RecentlyViewedProvider>().add(product);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProductDetailScreen()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: KinetixAppBar(
        title: loc.appTitle,
        onCartTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ShoppingCartScreen(),
            ),
          );
        },
      ),
      body: CustomScrollView(
        slivers: [
          // Search & Tagline Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.tagline,
                    style: AppTypography.labelSmall.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  KinetixTextField(
                    label: '',
                    hintText: loc.searchPlaceholder,
                    prefixIcon: Icons.search_rounded,
                    onChanged: (value) =>
                        catalogProvider.updateSearchQuery(value),
                  ),
                ],
              ),
            ),
          ),
          // Categories Filter Horizontal List
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: ProductCategory.values.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final cat = ProductCategory.values[index];
                  return KinetixCategoryChip(
                    label: cat.label(loc),
                    isSelected: catalogProvider.selectedCategory == cat,
                    onTap: () => catalogProvider.selectCategory(cat),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: KinetixRecentlyViewedSection(
              state: recentlyViewed.state,
              onOpenProduct: openProduct,
              onRetry: recentlyViewed.load,
            ),
          ),
          // Product Grid Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                loc.featured,
                style: AppTypography.headlineMedium.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          // Products Grid View
          if (catalogProvider.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else if (catalogProvider.products.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  loc.noProductsFound,
                  style: AppTypography.bodyMedium,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = catalogProvider.products[index];
                    return KinetixProductCard(
                      product: product,
                      isFavorite: wishlistProvider.isFavorite(product.id),
                      onFavoriteToggle: () =>
                          wishlistProvider.toggleFavorite(product),
                      onTap: () => openProduct(product),
                    );
                  },
                  childCount: catalogProvider.products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
