import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

/// Application themes.
///
/// Light and dark themes previously duplicated ~60 lines of identical
/// structure, differing only in six colour tokens. They are now built from a
/// single private factory driven by a small token record, so a future change
/// is made once and applies to both modes.
abstract final class AppThemes {
  static const double _inputRadius = 14;
  static const double _cardRadius = 16;

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    background: AppColors.bgLight,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textPrimaryLight,
    mutedText: AppColors.textSecondaryLight,
    border: AppColors.borderLight,
    overlayStyle: SystemUiOverlayStyle.dark,
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    background: AppColors.bgDark,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimaryDark,
    mutedText: AppColors.textSecondaryDark,
    border: AppColors.borderDark,
    overlayStyle: SystemUiOverlayStyle.light,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color onSurface,
    required Color mutedText,
    required Color border,
    required SystemUiOverlayStyle overlayStyle,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
      ).copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: surface,
        error: AppColors.error,
      ),

      // AppBar Styling
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        systemOverlayStyle: overlayStyle,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
          side: BorderSide(color: border),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: mutedText, fontSize: 14),
        border: _inputBorder(border),
        enabledBorder: _inputBorder(border),
        focusedBorder: _inputBorder(AppColors.primary, width: 1.5),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_inputRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}