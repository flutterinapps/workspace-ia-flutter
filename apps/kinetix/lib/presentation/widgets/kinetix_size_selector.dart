import 'package:flutter/material.dart';
import '../../domain/enums/product_size.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/neumorphic_decorations.dart';

class KinetixSizeSelector extends StatelessWidget {
  final List<ProductSize> availableSizes;
  final ProductSize? selectedSize;
  final ValueChanged<ProductSize> onSizeSelected;

  const KinetixSizeSelector({
    super.key,
    required this.availableSizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (availableSizes.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: availableSizes.map((size) {
        final isSelected = selectedSize == size;
        return GestureDetector(
          onTap: () => onSizeSelected(size),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 44,
            alignment: Alignment.center,
            decoration: isSelected
                ? NeumorphicDecorations.primaryGradientDecoration(borderRadius: 12)
                : NeumorphicDecorations.decoration(
                    style: NeumorphicStyle.raised,
                    borderRadius: 12,
                  ),
            child: Text(
              size.displayLabel,
              style: AppTypography.labelLarge.copyWith(
                color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
