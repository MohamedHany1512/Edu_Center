import 'package:dartz/dartz.dart';
import 'package:edu_app/core/utils/supabase_guard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Data source for authentication and the `profiles` table.
///
/// Depends on the Supabase SDK directly, so the presentation layer stays free
/// of any backend knowledge.
class AuthRepo {
  AuthRepo({SupabaseClient? supabaseClient})
    : _supabase = supabaseClient ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  /// Deep link Supabase redirects to after a password-reset email is clicked.
  static const String passwordResetRedirectUrl = 'learnify://reset-password/';

  Future<Either<String, void>> login({
    required String email,
    required String password,
  }) {
    return guardSupabase(() async {
      await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
    });
  }

  Future<Either<String, void>> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return guardSupabase(() async {
      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        // Storing the name in the account metadata keeps it available even
        // before the `profiles` row exists.
        data: {'full_name': name.trim()},
      );

      // The user id is only available once the account is created; depending on
      // `currentUser` instead would break when email confirmation is required.
      final user = response.user;
      if (user == null) {
        throw const AuthException('Failed to create account.');
      }

      // A profile failure must not fail the signup itself.
      await saveUserData(id: user.id, name: name, email: email);
    });
  }

  /// Persists the new user's profile.
  ///
  /// Single responsibility: saving only, no session checks.
  Future<Either<String, void>> saveUserData({
    required String id,
    required String name,
    required String email,
  }) {
    return guardSupabase(() async {
      await _supabase.from('profiles').upsert({
        'id': id,
        'full_name': name.trim(),
        'email': email.trim(),
      });
    });
  }

  Session? getCurrentSession() => _supabase.auth.currentSession;

  User? getCurrentUser() => _supabase.auth.currentUser;

  Future<Either<String, void>> sendResetLink({required String email}) {
    return guardSupabase(() async {
      await _supabase.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: passwordResetRedirectUrl,
      );
    });
  }

  Future<Either<String, void>> changePassword({required String password}) {
    return guardSupabase(() async {
      await _supabase.auth.updateUser(UserAttributes(password: password));
    });
  }

  Future<Either<String, void>> signOut() {
    return guardSupabase(() async {
      await _supabase.auth.signOut();
    });
  }
}
