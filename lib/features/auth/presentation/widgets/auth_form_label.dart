import 'package:edu_app/core/extensions/context_theme_extension.dart';
import 'package:flutter/material.dart';

/// A bold field caption used by the auth forms.
///
/// Replaces the `const Text('...', style: TextStyle(fontSize: 14,
/// fontWeight: w600))` block that was copy-pasted 9 times across the login,
/// signup and change-password pages.
class AuthFormLabel extends StatelessWidget {
  const AuthFormLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: context.textPrimary,
      ),
    );
  }
}