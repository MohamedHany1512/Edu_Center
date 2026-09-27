import 'dart:async';

import 'package:edu_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
// Prefixed import: Supabase also defines an `AuthState`, which collides with
// the app's own auth feature state.
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Bridges Supabase's auth stream to the app router.
///
/// This is the only place allowed to react to a password-recovery deep link,
/// which requires a navigator reference rather than a `BuildContext` because
/// the event can fire before any route is pushed.
class AuthStateListener {
  AuthStateListener({required GlobalKey<NavigatorState> navigatorKey})
    : _navigatorKey = navigatorKey;

  final GlobalKey<NavigatorState> _navigatorKey;
  StreamSubscription<supabase.AuthState>? _authSubscription;

  /// Whether the password-recovery route is already on screen, so repeated
  /// `passwordRecovery` events do not stack duplicate pages.
  bool _isNavigating = false;

  void startListening() {
    _authSubscription = supabase.Supabase.instance.client.auth.onAuthStateChange
        .listen(
          _onAuthStateChange,
          onError: (Object error) => debugPrint('Auth stream error: $error'),
        );
  }

  void _onAuthStateChange(supabase.AuthState state) {
    debugPrint('AUTH EVENT: ${state.event}');

    if (state.event != supabase.AuthChangeEvent.passwordRecovery) return;
    if (_isNavigating) return;

    _isNavigating = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final navigator = _navigatorKey.currentState;

      if (navigator == null) {
        debugPrint('Navigator is not ready; skipping recovery navigation.');
        _isNavigating = false;
        return;
      }

      // No session is logged here: it can contain a refresh token, and the
      // previous implementation printed it in full to the console.
      await navigator.pushNamed(Routes.changePasswordPage);
      _isNavigating = false;
    });
  }

  Future<void> dispose() async {
    await _authSubscription?.cancel();
    _authSubscription = null;
  }
}
