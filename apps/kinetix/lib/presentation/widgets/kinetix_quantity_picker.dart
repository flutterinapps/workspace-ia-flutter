import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/neumorphic_decorations.dart';

class KinetixQuantityPicker extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const KinetixQuantityPicker({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStepperButton(
          icon: Icons.remove,
          onTap: () => onChanged(quantity - 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            '$quantity',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _buildStepperButton(
          icon: Icons.add,
          onTap: () => onChanged(quantity + 1),
        ),
      ],
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: NeumorphicDecorations.decoration(
          style: NeumorphicStyle.raised,
          borderRadius: 10,
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
