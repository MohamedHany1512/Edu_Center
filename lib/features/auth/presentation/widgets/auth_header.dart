import 'package:edu_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Curved brand header shown at the top of the auth screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, this.brand = 'Edu Center'});

  final String title;

  /// Product name shown above [title].
  final String brand;
  @override
  Widget build(BuildContext context) {
    final headline = Theme.of(context).textTheme.headlineSmall;

    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.25,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(brand, style: headline?.copyWith(color: AppColors.bgDark)),
            const SizedBox(height: 25),
            Text(title, style: headline?.copyWith(color: AppColors.bgLight)),
          ],
        ),
      ),
    );
  }
}
