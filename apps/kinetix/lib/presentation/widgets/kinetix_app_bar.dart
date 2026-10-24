import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/neumorphic_decorations.dart';
import '../../l10n/generated/app_localizations.dart';

class KinetixAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onWishlistTap;
  final int wishlistCount;

  const KinetixAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackTap,
    this.onCartTap,
    this.onWishlistTap,
    this.wishlistCount = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(color: AppColors.surface),
        child: Row(
          children: [
            if (showBackButton)
              GestureDetector(
                onTap: onBackTap ?? () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: NeumorphicDecorations.decoration(
                    style: NeumorphicStyle.raised,
                    borderRadius: 14,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: AppColors.onSurface,
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(8),
                decoration: NeumorphicDecorations.primaryGradientDecoration(
                  borderRadius: 14,
                ),
                child: const Icon(Icons.bolt, color: Colors.white, size: 22),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTypography.headlineMedium.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Language Switcher Toggle
            GestureDetector(
              onTap: () => localeProvider.toggleLanguage(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: NeumorphicDecorations.decoration(
                  style: NeumorphicStyle.raised,
                  borderRadius: 12,
                ),
                child: Text(
                  localeProvider.locale.languageCode.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (onWishlistTap != null) ...[
              _WishlistButton(
                count: wishlistCount,
                tooltip: AppLocalizations.of(context).openWishlist,
                onTap: onWishlistTap!,
              ),
              const SizedBox(width: 10),
            ],
            // Cart Button with Badge
            if (onCartTap != null)
              GestureDetector(
                onTap: onCartTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: NeumorphicDecorations.decoration(
                        style: NeumorphicStyle.raised,
                        borderRadius: 14,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 20,
                        color: AppColors.onSurface,
                      ),
                    ),
                    if (cartProvider.itemCount > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cartProvider.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  const _WishlistButton({
    required this.count,
    required this.tooltip,
    required this.onTap,
  });

  final int count;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        value: count > 0 ? '$count' : null,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: NeumorphicDecorations.decoration(
                    style: NeumorphicStyle.raised,
                    borderRadius: 14,
                  ),
                  child: Icon(
                    count > 0 ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: count > 0 ? AppColors.primary : AppColors.onSurface,
                  ),
                ),
                if (count > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: ExcludeSemantics(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
