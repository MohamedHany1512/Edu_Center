part of 'auth_cubit.dart';

/// Immutable, `sealed` auth states.
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthResetLinkSent extends AuthState {
  const AuthResetLinkSent();
}

final class AuthPasswordChanged extends AuthState {
  const AuthPasswordChanged();
}

/// The account was created but requires email confirmation before sign-in.
final class AuthAccountCreated extends AuthState {
  const AuthAccountCreated({required this.email});

  final String email;
}

final class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;
}