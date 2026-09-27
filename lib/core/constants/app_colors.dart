import 'package:flutter/material.dart';

/// Application colour palette.
///
/// `abstract final` prevents instantiation and inheritance, guaranteeing the
/// palette is used as a static namespace only.
abstract final class AppColors {
  // Primary Palette (Electric Purple/Indigo)
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary & Accent (Cyan & Teal)
  static const Color secondary = Color(0xFF0EA5E9);
  static const Color accent = Color(0xFF14B8A6);

  // Neutral Tones - Light Mode
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Neutral Tones - Dark Mode
  static const Color bgDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF334155);

  // Feedback & Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color starRating = Color(0xFFFBBF24);
}