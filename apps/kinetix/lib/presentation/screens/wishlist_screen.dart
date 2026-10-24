import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/product.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers/catalog_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/wishlist_state.dart';
import '../widgets/kinetix_app_bar.dart';
import '../widgets/kinetix_button.dart';
import '../widgets/kinetix_product_card.dart';
import 'product_detail_screen.dart';

/// Connects [WishlistView] to the providers. All layout lives in the view so it
/// can be previewed and tested without providers.
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: KinetixAppBar(title: loc.wishlist, showBackButton: true),
      body: WishlistView(
        state: wishlist.state,
        onRetry: wishlist.load,
        onExplore: () => Navigator.of(context).pop(),
        onToggleFavorite: wishlist.toggleFavorite,
        onOpenProduct: (product) {
          context.read<CatalogProvider>().selectProduct(product);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const ProductDetailScreen(),
            ),
          );
        },
      ),
    );
  }
}

class WishlistView extends StatelessWidget {
  const WishlistView({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onExplore,
    required this.onToggleFavorite,
    required this.onOpenProduct,
  });

  final WishlistState state;
  final VoidCallback onRetry;
  final VoidCallback onExplore;
  final ValueChanged<Product> onToggleFavorite;
  final ValueChanged<Product> onOpenProduct;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return switch (state) {
      WishlistLoading() => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      WishlistEmpty() => _WishlistMessage(
        icon: Icons.favorite_border_rounded,
        title: loc.noFavorites,
        body: loc.wishlistEmptyBody,
        actionLabel: loc.exploreCatalog,
        onAction: onExplore,
      ),
      WishlistError() => _WishlistMessage(
        icon: Icons.cloud_off_rounded,
        title: loc.wishlistLoadError,
        actionLabel: loc.retry,
        onAction: onRetry,
      ),
      WishlistData(:final items) => GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          childAspectRatio: 0.68,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
          return KinetixProductCard(
            product: product,
            isFavorite: true,
            onFavoriteToggle: () => onToggleFavorite(product),
            onTap: () => onOpenProduct(product),
          );
        },
      ),
    };
  }
}

class _WishlistMessage extends StatelessWidget {
  const _WishlistMessage({
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.body,
  });

  final IconData icon;
  final String title;
  final String? body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(icon, size: 64, color: AppColors.primaryContainer),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleLarge,
            ),
            if (body case final body?) ...[
              const SizedBox(height: 8),
              Text(
                body,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 24),
            KinetixButton(label: actionLabel, onPressed: onAction),
          ],
        ),
      ),
    );
  }
}
