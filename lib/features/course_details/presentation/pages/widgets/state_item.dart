import 'package:edu_app/core/extensions/context_theme_extension.dart';
import 'package:flutter/material.dart';

/// A small icon + caption pair used in the course-details stat row.
class StatItem extends StatelessWidget {
  const StatItem({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: context.textSecondary),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: context.textSecondary),
        ),
      ],
    );
  }
}