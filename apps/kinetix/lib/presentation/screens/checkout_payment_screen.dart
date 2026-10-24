import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/enums/payment_method_type.dart';
import '../widgets/kinetix_app_bar.dart';
import '../widgets/kinetix_button.dart';
import '../widgets/kinetix_card.dart';
import '../widgets/kinetix_text_field.dart';
import '../widgets/kinetix_native_pay_button.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  const CheckoutPaymentScreen({super.key});

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryController;
  late TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();
    final checkout = context.read<CheckoutProvider>();
    _nameController = TextEditingController(text: checkout.customerName);
    _emailController = TextEditingController(text: checkout.customerEmail);
    _addressController = TextEditingController(text: checkout.shippingAddress);
    _cardNumberController = TextEditingController(text: checkout.cardNumber);
    _expiryController = TextEditingController(text: checkout.expiryDate);
    _cvvController = TextEditingController(text: checkout.cvv);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _onPayPressed() async {
    final loc = AppLocalizations.of(context);
    final checkout = context.read<CheckoutProvider>();
    final cart = context.read<CartProvider>().cart;

    checkout.updateShippingDetails(
      name: _nameController.text,
      email: _emailController.text,
      address: _addressController.text,
    );

    if (checkout.selectedPaymentMethod == PaymentMethodType.creditCard) {
      if (!_formKey.currentState!.validate()) return;
      checkout.updateCardDetails(
        number: _cardNumberController.text,
        expiry: _expiryController.text,
        cvvCode: _cvvController.text,
      );
    }

    Navigator.of(context).pushNamed('/processing');

    final success = await checkout.processOrder(
      items: cart.items,
      totalAmount: cart.total,
    );

    if (mounted) {
      if (success) {
        context.read<CartProvider>().clearCart();
        Navigator.of(context).pushReplacementNamed('/confirmation');
      } else {
        Navigator.of(context).pop(); // dismiss processing loader
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.paymentFailed),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final checkout = context.watch<CheckoutProvider>();
    final cart = context.watch<CartProvider>().cart;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: KinetixAppBar(title: loc.checkout, showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Total Banner
              KinetixCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(loc.total, style: AppTypography.titleLarge),
                    Text(
                      CurrencyFormatter.format(cart.total),
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Payment Method Selector
              Text(
                loc.paymentMethod,
                style: AppTypography.headlineMedium.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                type: PaymentMethodType.applePay,
                title: loc.applePay,
                icon: Icons.apple,
                isSelected:
                    checkout.selectedPaymentMethod ==
                    PaymentMethodType.applePay,
              ),
              const SizedBox(height: 10),
              _buildPaymentOption(
                type: PaymentMethodType.googlePay,
                title: loc.googlePay,
                icon: Icons.g_mobiledata,
                isSelected:
                    checkout.selectedPaymentMethod ==
                    PaymentMethodType.googlePay,
              ),
              const SizedBox(height: 10),
              _buildPaymentOption(
                type: PaymentMethodType.creditCard,
                title: loc.creditCard,
                icon: Icons.credit_card_rounded,
                isSelected:
                    checkout.selectedPaymentMethod ==
                    PaymentMethodType.creditCard,
              ),
              const SizedBox(height: 24),
              // Shipping Address Section
              Text(
                loc.shippingAddress,
                style: AppTypography.headlineMedium.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),
              KinetixTextField(
                label: loc.fullName,
                controller: _nameController,
              ),
              const SizedBox(height: 10),
              KinetixTextField(
                label: loc.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              KinetixTextField(
                label: loc.address,
                controller: _addressController,
              ),
              const SizedBox(height: 24),
              // Credit Card Form (If selected)
              if (checkout.selectedPaymentMethod ==
                  PaymentMethodType.creditCard) ...[
                Text(
                  loc.creditCard,
                  style: AppTypography.headlineMedium.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                KinetixTextField(
                  label: loc.cardNumber,
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: KinetixTextField(
                        label: loc.expiry,
                        controller: _expiryController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: KinetixTextField(
                        label: loc.cvv,
                        controller: _cvvController,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              // Pay Action Button
              if (checkout.selectedPaymentMethod == PaymentMethodType.applePay)
                KinetixNativePayButton(
                  type: PaymentMethodType.applePay,
                  onPressed: _onPayPressed,
                )
              else if (checkout.selectedPaymentMethod ==
                  PaymentMethodType.googlePay)
                KinetixNativePayButton(
                  type: PaymentMethodType.googlePay,
                  onPressed: _onPayPressed,
                )
              else
                KinetixButton(
                  label:
                      '${loc.payNow} (${CurrencyFormatter.format(cart.total)})',
                  width: double.infinity,
                  onPressed: _onPayPressed,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethodType type,
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    final checkout = context.read<CheckoutProvider>();

    return GestureDetector(
      onTap: () => checkout.setPaymentMethod(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainer : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.outline,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTypography.labelLarge.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
