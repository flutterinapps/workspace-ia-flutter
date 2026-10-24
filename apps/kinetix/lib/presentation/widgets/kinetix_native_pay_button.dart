import 'package:flutter/material.dart';
import '../../domain/enums/payment_method_type.dart';
import '../../l10n/generated/app_localizations.dart';

class KinetixNativePayButton extends StatelessWidget {
  final PaymentMethodType type;
  final VoidCallback onPressed;
  final bool isLoading;

  const KinetixNativePayButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isApple = type == PaymentMethodType.applePay;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: isApple ? Colors.black : const Color(0xFF4285F4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else ...[
                  Icon(
                    isApple ? Icons.apple : Icons.g_mobiledata,
                    color: Colors.white,
                    size: isApple ? 26 : 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    loc.payWith(isApple ? loc.applePay : loc.googlePay),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
