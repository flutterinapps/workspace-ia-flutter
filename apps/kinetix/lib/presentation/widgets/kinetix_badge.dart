import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum KinetixBadgeVariant { newRelease, limitedEdition, custom }

class KinetixBadge extends StatelessWidget {
  final String label;
  final KinetixBadgeVariant variant;

  const KinetixBadge({
    super.key,
    required this.label,
    this.variant = KinetixBadgeVariant.custom,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textCol;

    switch (variant) {
      case KinetixBadgeVariant.newRelease:
        bg = AppColors.primary;
        textCol = AppColors.onPrimary;
        break;
      case KinetixBadgeVariant.limitedEdition:
        bg = AppColors.secondary;
        textCol = AppColors.onSecondary;
        break;
      case KinetixBadgeVariant.custom:
        bg = AppColors.surfaceContainerHigh;
        textCol = AppColors.onSurfaceVariant;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: textCol,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
