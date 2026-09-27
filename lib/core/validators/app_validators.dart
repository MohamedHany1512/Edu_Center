import 'package:flutter/widgets.dart';

/// Reusable field validators for auth forms.
///
/// The previous implementation accepted any string containing `@`, while the
/// signup page used a different (stricter) regex inline — the same rule was
/// therefore implemented twice with different results. Both pages now share
/// the single definition here.
abstract final class AppValidators {
  /// Minimum accepted password length.
  static const int minPasswordLength = 6;

  /// Pragmatic email pattern: `local@domain.tld`.
  static final RegExp _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$',
  );

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Please enter your email';
    }
    if (!_emailPattern.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    return null;
  }

  /// Validates that [value] matches [other].
  ///
  /// Passing [otherController] avoids reading a controller during build,
  /// keeping the validator referentially transparent.
  static String? Function(String?) confirmPassword(
    TextEditingController otherController,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      if (value != otherController.text) {
        return 'Passwords do not match';
      }
      return null;
    };
  }
}
