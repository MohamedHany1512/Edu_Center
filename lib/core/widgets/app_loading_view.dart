import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Centred progress indicator used by every feature's loading state.
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
