import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand Canvas & Backgrounds (Tactile Velour Palette)
  static const Color surface = Color(0xFFFFF8F7);
  static const Color surfaceDim = Color(0xFFE8D6D8);
  static const Color surfaceBright = Color(0xFFFFF8F7);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFFFF0F1);
  static const Color surfaceContainer = Color(0xFFFDE9EC);
  static const Color surfaceContainerHigh = Color(0xFFF7E4E6);
  static const Color surfaceContainerHighest = Color(0xFFF1DEE0);
  
  static const Color onSurface = Color(0xFF23191B);
  static const Color onSurfaceVariant = Color(0xFF554245);
  static const Color inverseSurface = Color(0xFF392E2F);
  static const Color inverseOnSurface = Color(0xFFFFECEE);

  // Borders & Outlines
  static const Color outline = Color(0xFF887175);
  static const Color outlineVariant = Color(0xFFDBC0C4);

  // Brand Primaries & Accents
  static const Color primary = Color(0xFF9E3756); // Tactile Velour Deep Rose
  static const Color primaryAccent = Color(0xFFD76483); // Vivid Rose Accent
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFBD506E);
  static const Color onPrimaryContainer = Color(0xFFFFFBFB);
  static const Color inversePrimary = Color(0xFFFFB1C2);

  // Secondaries & Tertiaries
  static const Color secondary = Color(0xFF8D4A52);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFFAAB2);
  static const Color onSecondaryContainer = Color(0xFF7B3B43);
  
  static const Color tertiary = Color(0xFF6B5753);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF85706B);

  // Status Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // Neumorphic Specific Calculated Light & Dark Shadow Constants
  static const Color neumorphicLightShadow = Color(0xFFFFFFFF);
  static const Color neumorphicDarkShadow = Color(0xFFE0D1B8);
  static const Color neumorphicInsetDark = Color(0xFFD3C2CA);
  
  // Glassmorphic Tint & Border
  static const Color glassFill = Color(0x99FFFFFF); // 60% Frosted White
  static const Color glassBorder = Color(0x33FFFFFF); // 20% White Edge
}
