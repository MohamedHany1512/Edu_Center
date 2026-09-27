import 'package:flutter/material.dart';

import '../extensions/context_theme_extension.dart';

/// Circular back button that defaults to theme-aware colours.
///
/// Previously every colour was a required argument, forcing each call site to
/// repeat the same `isDark ? A : B` ternaries. They are now optional and
/// resolved from the theme, so the call sites collapse to `CustomBackButton()`.
class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.containerColor,
    this.borderColor,
    this.iconColor,
    this.onPressed,
  });

  final Color? containerColor;
  final Color? borderColor;
  final Color? iconColor;

  /// Overrides the default "pop the current route" behaviour.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: containerColor ?? context.surface,
        border: Border.all(color: borderColor ?? context.border, width: 2),
      ),
      child: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: iconColor ?? context.textPrimary,
          size: 22,
        ),
      ),
    );
  }
}
