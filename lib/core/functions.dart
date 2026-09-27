import 'package:flutter/material.dart';

/// Shows a transient message at the bottom of the screen.
///
/// The previous version left an unclosed snack bar queue, so a rapid second
/// call would queue behind the first. Queuing is preserved intentionally, but
/// the bar now floats so it is not obscured by the floating bottom nav bar.
void snackBarMessage({
  required BuildContext context,
  required String text,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 3),
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
}
