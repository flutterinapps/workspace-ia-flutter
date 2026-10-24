import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/enums/product_size.dart';
import '../widgets/kinetix_app_bar.dart';
import '../widgets/kinetix_button.dart';
import '../widgets/kinetix_size_selector.dart';
import '../widgets/kinetix_quantity_picker.dart';
import '../widgets/kinetix_badge.dart';
import 'shopping_cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductSize? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    final catalogProvider = context.read<CatalogProvider>();
    final product = catalogProvider.selectedProduct;
    if (product != null) {
      if (product.availableSizes.isNotEmpty) {
        _selectedSize = product.availableSizes.first;
      }
      if (product.availableColors.isNotEmpty) {
        _selectedColor = product.availableColors.first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final catalogProvider = context.watch<CatalogProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();
    final cartProvider = context.read<CartProvider>();
    final product = catalogProvider.selectedProduct;

    if (product == null) {
      return Scaffold(
        appBar: KinetixAppBar(
          title: loc.appTitle,
          showBackButton: true,
        ),
        body: Center(child: Text(loc.productNotFound)),
      );
    }

    final isFav = wishlistProvider.isFavorite(product.id);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: KinetixAppBar(
        title: product.title,
        showBackButton: true,
        onCartTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ShoppingCartScreen(),
            ),
          );
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Main Hero Image Container
                  Stack(
                    children: [
                      Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.sports_soccer, size: 64),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: FloatingActionButton.small(
                          backgroundColor: Colors.white,
                          elevation: 2,
                          onPressed: () =>
                              wishlistProvider.toggleFavorite(product),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? AppColors.primary : AppColors.outline,
                          ),
                        ),
                      ),
                      if (product.isLimitedEdition)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: KinetixBadge(
                            label: loc.limitedEdition,
                            variant: KinetixBadgeVariant.limitedEdition,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Title and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: AppTypography.headlineMedium.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(product.price),
                        style: AppTypography.displayLarge.copyWith(
                          fontSize: 24,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    loc.description,
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Size Selector (If Applicable)
                  if (product.requiresSizeSelection) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.selectSize,
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          loc.sizeGuide,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    KinetixSizeSelector(
                      availableSizes: product.availableSizes,
                      selectedSize: _selectedSize,
                      onSizeSelected: (size) {
                        setState(() {
                          _selectedSize = size;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.quantity,
                        style: AppTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      KinetixQuantityPicker(
                        quantity: _quantity,
                        onChanged: (newQty) {
                          if (newQty >= 1) {
                            setState(() {
                              _quantity = newQty;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Add to Cart Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: KinetixButton(
              label: loc.addToCart,
              icon: Icons.shopping_bag_outlined,
              width: double.infinity,
              onPressed: () {
                cartProvider.addToCart(
                  product,
                  selectedSize: _selectedSize,
                  selectedColor: _selectedColor,
                  quantity: _quantity,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.title} añadido al carrito'),
                    backgroundColor: AppColors.primary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
