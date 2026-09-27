import 'package:edu_app/core/widgets/custom_back_button.dart';
import 'package:edu_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter/material.dart';

/// Brand header with a floating circular back button.
class AuthTopLogoWithBack extends StatelessWidget {
  const AuthTopLogoWithBack({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        AuthHeader(title: text),
        Positioned(
          top: 50,
          left: 16,
       
          child: CustomBackButton(
            containerColor: scheme.primary,
            borderColor: scheme.surface,
            iconColor: scheme.surface,
          ),
        ),
      ],
    );
  }
}