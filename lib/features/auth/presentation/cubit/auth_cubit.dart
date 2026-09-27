import 'package:edu_app/features/auth/data/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepo authRepo})
    : _authRepo = authRepo,
      super(const AuthInitial());

  final AuthRepo _authRepo;

  /// True while a request is in flight, so a double tap cannot submit twice.
  bool get _isBusy => state is AuthLoading;

  Future<void> login({required String email, required String password}) async {
    if (_isBusy) return;
    emit(const AuthLoading());

    final result = await _authRepo.login(email: email, password: password);

    // The cubit may have been closed (e.g. route popped) while awaiting.
    if (isClosed) return;

    result.fold(
      (error) => emit(AuthError(message: error)),
      (_) => emit(const AuthAuthenticated()),
    );
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    if (_isBusy) return;
    emit(const AuthLoading());

    final result = await _authRepo.signup(
      name: name,
      email: email,
      password: password,
    );

    if (isClosed) return;

    result.fold(
      (error) => emit(AuthError(message: error)),
      (_) {
        // No active session means Supabase requires email confirmation before
        // the user can sign in.
        final session = _authRepo.getCurrentSession();

        if (session == null) {
          emit(AuthAccountCreated(email: email.trim()));
        } else {
          emit(const AuthAuthenticated());
        }
      },
    );
  }

  /// Re-evaluates the current session and emits the matching state.
  void checkAuth() {
    if (_authRepo.getCurrentSession() != null) {
      emit(const AuthAuthenticated());
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> sendResetLink({required String email}) async {
    if (_isBusy) return;
    emit(const AuthLoading());

    final result = await _authRepo.sendResetLink(email: email);

    if (isClosed) return;

    result.fold(
      (error) => emit(AuthError(message: error)),
      (_) => emit(const AuthResetLinkSent()),
    );
  }

  Future<void> changePassword({required String password}) async {
    if (_isBusy) return;
    emit(const AuthLoading());

    final result = await _authRepo.changePassword(password: password);

    if (isClosed) return;

    result.fold(
      (error) => emit(AuthError(message: error)),
      (_) => emit(const AuthPasswordChanged()),
    );
  }
}