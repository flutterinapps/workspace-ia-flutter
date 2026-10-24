import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../widgets/kinetix_app_bar.dart';
import '../widgets/kinetix_button.dart';
import '../widgets/kinetix_card.dart';
import '../widgets/kinetix_quantity_picker.dart';
import '../widgets/kinetix_text_field.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final cartProvider = context.watch<CartProvider>();
    final cart = cartProvider.cart;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: KinetixAppBar(
        title: loc.cart,
        showBackButton: true,
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: AppColors.outlineVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.emptyCart,
                    style: AppTypography.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  KinetixButton(
                    label: loc.backToShop,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return KinetixCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.product.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.labelLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (item.selectedSize != null)
                                    Text(
                                      '${loc.size}: ${item.selectedSize!.name.toUpperCase()}',
                                      style: AppTypography.labelSmall,
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    CurrencyFormatter.format(item.product.price),
                                    style: AppTypography.titleLarge.copyWith(
                                      fontSize: 15,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            KinetixQuantityPicker(
                              quantity: item.quantity,
                              onChanged: (newQty) {
                                cartProvider.updateQuantity(item, newQty);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Coupon & Summary Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: KinetixTextField(
                              label: '',
                              hintText: loc.couponCode,
                              controller: _couponController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          KinetixButton(
                            label: loc.applyCoupon,
                            variant: KinetixButtonVariant.secondary,
                            onPressed: () async {
                              final success = await cartProvider
                                  .applyCoupon(_couponController.text);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? loc.couponApplied
                                          : loc.invalidCoupon,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        loc.subtotal,
                        CurrencyFormatter.format(cart.subtotal),
                      ),
                      if (cart.discountAmount > 0)
                        _buildSummaryRow(
                          loc.discount,
                          '-${CurrencyFormatter.format(cart.discountAmount)}',
                          isHighlight: true,
                        ),
                      _buildSummaryRow(
                        loc.shipping,
                        cart.shippingFee == 0
                            ? loc.freeShipping
                            : CurrencyFormatter.format(cart.shippingFee),
                      ),
                      _buildSummaryRow(
                        loc.tax,
                        CurrencyFormatter.format(cart.taxAmount),
                      ),
                      const Divider(height: 20),
                      _buildSummaryRow(
                        loc.total,
                        CurrencyFormatter.format(cart.total),
                        isTotal: true,
                      ),
                      const SizedBox(height: 16),
                      KinetixButton(
                        label: loc.proceedToCheckout,
                        width: double.infinity,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/checkout');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isTotal = false, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800)
                : AppTypography.bodyMedium.copyWith(
                    color: isHighlight ? AppColors.primary : AppColors.onSurfaceVariant,
                  ),
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  )
                : AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isHighlight ? AppColors.primary : AppColors.onSurface,
                  ),
          ),
        ],
      ),
    );
  }
}
