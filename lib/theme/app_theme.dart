import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: AppColors.leaf));
    final scaledText = base.textTheme.copyWith(
      headlineLarge: base.textTheme.headlineLarge?.copyWith(fontSize: 38, fontWeight: FontWeight.bold),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(fontSize: 30, fontWeight: FontWeight.w600),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: base.textTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.3),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.3),
    );
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: scaledText.apply(bodyColor: Colors.white, displayColor: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white70, size: 24),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.leaf,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.08),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.leaf,
        brightness: Brightness.dark,
      ),
    );
    final scaledText = base.textTheme.copyWith(
      headlineLarge: base.textTheme.headlineLarge?.copyWith(fontSize: 38, fontWeight: FontWeight.bold),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(fontSize: 30, fontWeight: FontWeight.w600),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: base.textTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.3),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.3),
    );
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: scaledText.apply(
        bodyColor: Colors.white.withOpacity(0.95),
        displayColor: Colors.white.withOpacity(0.95),
      ),
      iconTheme: const IconThemeData(color: Colors.white70, size: 24),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.leaf,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.06),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
  }
}
