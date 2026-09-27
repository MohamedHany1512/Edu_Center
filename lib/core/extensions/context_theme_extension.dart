import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Semantic, brightness-aware colour resolution.
///
/// Replaces the repeated `isDark ? AppColors.xDark : AppColors.xLight` pattern
/// that was duplicated in ~10 widgets. Components now depend on a
/// [ColorScheme]-style semantic token instead of picking palette entries by
/// hand, which also makes them correct in *both* themes automatically.
extension AppThemeX on BuildContext {
  /// Whether the active theme is dark.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Primary body text colour.
  Color get textPrimary => isDarkMode
      ? AppColors.textPrimaryDark
      : AppColors.textPrimaryLight;

  /// Secondary / supporting text colour.
  Color get textSecondary => isDarkMode
      ? AppColors.textSecondaryDark
      : AppColors.textSecondaryLight;

  /// Card or panel background.
  Color get surface => isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;

  /// Divider / outline colour.
  Color get border => isDarkMode ? AppColors.borderDark : AppColors.borderLight;

  /// Page background colour.
  Color get background => isDarkMode ? AppColors.bgDark : AppColors.bgLight;

  /// Resolves a colour pair, e.g. `context.resolve(AppColors.xDark, AppColors.xLight)`.
  Color resolve(Color dark, Color light) => isDarkMode ? dark : light;
}