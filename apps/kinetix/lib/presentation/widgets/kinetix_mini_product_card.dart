import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/neumorphic_decorations.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/models/product.dart';

/// Compact product card for horizontal rows such as "Recently viewed".
class KinetixMiniProductCard extends StatelessWidget {
  const KinetixMiniProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  static const width = 128.0;

  @override
  Widget build(BuildContext context) {
    final price = CurrencyFormatter.format(product.price);
    return Semantics(
      button: true,
      label: '${product.title}, $price',
      excludeSemantics: true,
      child: SizedBox(
        width: width,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              decoration: NeumorphicDecorations.decoration(
                style: NeumorphicStyle.raised,
                borderRadius: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const ColoredBox(
                              color: AppColors.surfaceContainerHigh,
                              child: Center(
                                child: Icon(
                                  Icons.sports_soccer,
                                  color: AppColors.outline,
                                ),
                              ),
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
