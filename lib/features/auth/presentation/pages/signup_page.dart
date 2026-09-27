import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/extensions/context_theme_extension.dart';
import 'package:edu_app/core/functions.dart';
import 'package:edu_app/core/routing/app_navigation.dart';
import 'package:edu_app/features/auth/presentation/cubit/auth_cubit.dart';
 import 'package:edu_app/features/auth/presentation/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_acceptTerms) {
      snackBarMessage(
        context: context,
        text: 'يرجى الموافقة على الشروط والأحكام للمتابعة',
        backgroundColor: AppColors.error,
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().signup(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const _BackButton()),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              snackBarMessage(
                context: context,
                text: state.message,
                backgroundColor: AppColors.error,
              );
            }

            if (state is AuthAccountCreated) {
              snackBarMessage(
                context: context,
                text:
                    'تم إنشاء الحساب. يرجى تأكيد بريدك الإلكتروني ${state.email} ثم تسجيل الدخول.',
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 5),
              );
              // Return to the root so AuthGate re-evaluates the session.
              context.popToRoot<void>();
            }

            if (state is AuthAuthenticated) {
              context.popToRoot<void>();
            }
          },
          buildWhen: (previous, current) =>
              current is AuthLoading || current is AuthInitial,
          builder: (context, state) => SignupForm(
            formKey: _formKey,
            isLoading: state is AuthLoading,
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            acceptTerms: _acceptTerms,
            onAcceptTermsChanged: (value) =>
                setState(() => _acceptTerms = value),
            onSubmit: _submit,
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      color: context.textPrimary,
      onPressed: () => context.popRoute<void>(),
    );
  }
}