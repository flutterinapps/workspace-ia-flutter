import 'package:flutter/material.dart';
import 'app_colors.dart';

enum NeumorphicStyle { raised, inset, flat }

abstract class NeumorphicDecorations {
  static BoxDecoration decoration({
    NeumorphicStyle style = NeumorphicStyle.raised,
    double borderRadius = 16.0,
    Color color = AppColors.surface,
    Color? customLightShadow,
    Color? customDarkShadow,
    Border? border,
  }) {
    if (style == NeumorphicStyle.inset) {
      return sunken(
        borderRadius: borderRadius,
        color: AppColors.surfaceContainerLow,
      );
    }
    return raised(
      borderRadius: borderRadius,
      color: color,
      customLightShadow: customLightShadow,
      customDarkShadow: customDarkShadow,
      border: border,
    );
  }

  static BoxDecoration raised({
    double borderRadius = 16.0,
    Color color = AppColors.surface,
    Color? customLightShadow,
    Color? customDarkShadow,
    Border? border,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: border,
      boxShadow: [
        BoxShadow(
          color: customLightShadow ?? AppColors.neumorphicLightShadow,
          offset: const Offset(-4, -4),
          blurRadius: 10,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: customDarkShadow ?? AppColors.neumorphicDarkShadow,
          offset: const Offset(4, 4),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ],
    );
  }

  static BoxDecoration sunken({
    double borderRadius = 16.0,
    Color color = AppColors.surfaceContainerLow,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? AppColors.outlineVariant.withValues(alpha: 0.6),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.neumorphicDarkShadow.withValues(alpha: 0.4),
          offset: const Offset(2, 2),
          blurRadius: 4,
          spreadRadius: -1,
        ),
        const BoxShadow(
          color: AppColors.neumorphicLightShadow,
          offset: Offset(-2, -2),
          blurRadius: 4,
          spreadRadius: -1,
        ),
      ],
    );
  }

  static BoxDecoration glassDecoration({
    double borderRadius = 20.0,
    Color fillColor = AppColors.glassFill,
    Color borderColor = AppColors.glassBorder,
  }) {
    return BoxDecoration(
      color: fillColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          offset: const Offset(0, 8),
          blurRadius: 20,
        ),
      ],
    );
  }

  static BoxDecoration primaryGradientDecoration({double borderRadius = 16.0}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: const LinearGradient(
        colors: [AppColors.primaryAccent, AppColors.primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.35),
          offset: const Offset(0, 6),
          blurRadius: 14,
        ),
      ],
    );
  }
}
