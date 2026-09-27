import 'package:edu_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
 
class CoursesCountCard extends StatelessWidget {
  final int count;
  final String title;
  const CoursesCountCard({
    super.key,
    required this.count,
    this.title = "My Courses",
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(color: AppColors.bgLight),
          ),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.bgLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
