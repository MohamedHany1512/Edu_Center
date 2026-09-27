import 'package:edu_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Centred brand mark shown above the login form.
class AuthBrandMark extends StatelessWidget {
  const AuthBrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.school_rounded,
          size: 48,
          color: AppColors.primary,
        ),
      ),
    );
  }
}