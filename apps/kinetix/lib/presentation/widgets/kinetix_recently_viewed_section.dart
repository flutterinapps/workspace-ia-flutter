import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/product.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers/recently_viewed_state.dart';
import 'kinetix_mini_product_card.dart';

/// "Recently viewed" row of the catalog. Pure view: it receives the state and
/// callbacks, so it can be previewed and tested without providers.
class KinetixRecentlyViewedSection extends StatelessWidget {
  const KinetixRecentlyViewedSection({
    super.key,
    required this.state,
    required this.onOpenProduct,
    required this.onRetry,
  });

  final RecentlyViewedState state;
  final ValueChanged<Product> onOpenProduct;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(loc.recentlyViewed, style: AppTypography.titleLarge),
          ),
          const SizedBox(height: 12),
          switch (state) {
            RecentlyViewedLoading() => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
            RecentlyViewedEmpty() => _Message(text: loc.recentlyViewedEmpty),
            RecentlyViewedError() => _Message(
              text: loc.recentlyViewedError,
              actionLabel: loc.retry,
              onAction: onRetry,
            ),
            RecentlyViewedData(:final items) => _ProductRow(
              items: items,
              onOpenProduct: onOpenProduct,
            ),
          },
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.items, required this.onOpenProduct});

  final List<Product> items;
  final ValueChanged<Product> onOpenProduct;

  @override
  Widget build(BuildContext context) {
    // Height grows with the text scale so titles are never clipped.
    final height = MediaQuery.textScalerOf(context).scale(96) + 120;
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => KinetixMiniProductCard(
          product: items[index],
          onTap: () => onOpenProduct(items[index]),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.actionLabel, this.onAction});

  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          if (actionLabel case final label?)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              child: Text(label),
            ),
        ],
      ),
    );
  }
}
