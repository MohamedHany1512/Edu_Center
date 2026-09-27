import 'package:edu_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
 
class CustomCircleAvatar extends StatelessWidget {
  final String name;
  const CustomCircleAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final firstLetter = name.trim().isNotEmpty
        ? name.trim()[0].toUpperCase()
        : "?";
    return CircleAvatar(
      radius: 32,
      backgroundColor: AppColors.bgDark,
      child: Text(
        firstLetter,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
