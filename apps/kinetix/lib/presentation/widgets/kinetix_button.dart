import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/neumorphic_decorations.dart';

enum KinetixButtonVariant { primary, secondary, glass, outlined }

class KinetixButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final KinetixButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const KinetixButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = KinetixButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;
    TextStyle textStyle;

    switch (variant) {
      case KinetixButtonVariant.primary:
        decoration = NeumorphicDecorations.primaryGradientDecoration();
        textStyle = AppTypography.labelLarge.copyWith(color: AppColors.onPrimary);
        break;
      case KinetixButtonVariant.secondary:
        decoration = NeumorphicDecorations.decoration(style: NeumorphicStyle.raised);
        textStyle = AppTypography.labelLarge.copyWith(color: AppColors.primary);
        break;
      case KinetixButtonVariant.glass:
        decoration = NeumorphicDecorations.glassDecoration();
        textStyle = AppTypography.labelLarge.copyWith(color: AppColors.onSurface);
        break;
      case KinetixButtonVariant.outlined:
        decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary, width: 1.5),
        );
        textStyle = AppTypography.labelLarge.copyWith(color: AppColors.primary);
        break;
    }

    return Container(
      width: width,
      height: 52,
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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
                  if (icon != null) ...[
                    Icon(icon, color: textStyle.color, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(label, style: textStyle),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
