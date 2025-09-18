import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color emerald = Color(0xFF2ECC71);
  static const Color forest = Color(0xFF1B5E20);
  static const Color leaf = Color(0xFF66BB6A);
  static const Color ocean = Color(0xFF0277BD);
  static const Color sky = Color(0xFF4FC3F7);
  static const Color earth = Color(0xFF8D6E63);
  static const Color sun = Color(0xFFFFC107);
  static const Color danger = Color(0xFFE53935);
  static const Color glassLight = Colors.white24;
  static const Color glassBorder = Colors.white54;

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [forest, ocean, sky],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark mode variant (deeper tones, more contrast neutrality)
  static const LinearGradient backgroundGradientDark = LinearGradient(
    colors: [Color(0xFF0F2A1C), Color(0xFF082032), Color(0xFF0D3A4A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient onboardingGradient = LinearGradient(
    colors: [forest, ocean],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient onboardingGradientDark = LinearGradient(
    colors: [Color(0xFF0F2A1C), Color(0xFF0D3A4A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient themedBackground(Brightness brightness) =>
      brightness == Brightness.dark ? backgroundGradientDark : backgroundGradient;

  static LinearGradient themedOnboarding(Brightness brightness) =>
      brightness == Brightness.dark ? onboardingGradientDark : onboardingGradient;
}
