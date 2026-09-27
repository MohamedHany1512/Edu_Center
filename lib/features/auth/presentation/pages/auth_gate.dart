import 'dart:async';

import 'package:edu_app/core/widgets/app_loading_view.dart';
import 'package:edu_app/features/auth/data/repo/auth_repo.dart';
import 'package:edu_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:edu_app/features/auth/presentation/pages/login_page.dart';
import 'package:edu_app/features/layout/presentation/pages/layout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: AuthRepo())..checkAuth(),
      child: const _AuthGateView(),
    );
  }
}

/// يستمع لتغيّر حالة المصادقة في Supabase ليعرض الشاشة الصحيحة
/// فور تسجيل الدخول أو تسجيل الخروج.
class _AuthGateView extends StatefulWidget {
  const _AuthGateView();

  @override
  State<_AuthGateView> createState() => _AuthGateViewState();
}

class _AuthGateViewState extends State<_AuthGateView> {
  // يتم استخدام dynamic لأن AuthState هنا من Supabase وليست من الـ Cubit
  StreamSubscription<supabase.AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    _authSubscription = supabase.Supabase.instance.client.auth.onAuthStateChange
        .listen(
          (_) {
            if (!mounted) return;
            context.read<AuthCubit>().checkAuth();
          },
          onError: (Object error) => debugPrint('AuthGate stream error: $error'),
        );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _authSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      // Only these four states change *which* screen is shown. The rest
      // (error, reset-link-sent, ...) are surfaced by each page's own
      // listener, so skipping them avoids rebuilding the whole layout.
      buildWhen: (previous, current) =>
          current is AuthAuthenticated ||
          current is AuthUnauthenticated ||
          current is AuthInitial ||
          current is AuthLoading,
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const LayoutPage();
        }

        // Previously this returned LoginPage, briefly flashing the fully
        // built login form during the session check.
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(body: AppLoadingView());
        }

        return const LoginPage();
      },
    );
  }
}
