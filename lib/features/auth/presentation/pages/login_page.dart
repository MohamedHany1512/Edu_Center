import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/extensions/context_theme_extension.dart';
import 'package:edu_app/core/functions.dart';
import 'package:edu_app/core/routing/app_navigation.dart';
import 'package:edu_app/core/routing/routes.dart';
import 'package:edu_app/core/validators/app_validators.dart';
import 'package:edu_app/core/widgets/custom_button.dart';
import 'package:edu_app/core/widgets/custom_text_form_field.dart';
import 'package:edu_app/core/widgets/password_text_field.dart';
import 'package:edu_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:edu_app/features/auth/presentation/widgets/auth_brand_mark.dart';
import 'package:edu_app/features/auth/presentation/widgets/auth_form_label.dart';
import 'package:edu_app/features/auth/presentation/widgets/social_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            if (state is AuthAuthenticated) {
              context.pushRoute(Routes.mainScreen);
            }
          },
           buildWhen: (previous, current) => current is! AuthAuthenticated,
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const AuthBrandMark(),
                      const SizedBox(height: 24),
                      const _WelcomeHeader(),

                      const SizedBox(height: 36),
                      const AuthFormLabel(text: 'البريد الإلكتروني'),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        hintText: 'example@domain.com',
                        prefixIcon: const Icon(Icons.email_outlined, size: 20),
                        validator: AppValidators.email,
                      ),

                      const SizedBox(height: 20),
                      const AuthFormLabel(text: 'كلمة المرور'),
                      const SizedBox(height: 8),
                      PasswordTextField(
                        controller: _passwordController,
                        validator: AppValidators.password,
                        onFieldSubmitted: (_) => _submit(),
                      ),

                      const SizedBox(height: 12),
                      const _ForgotPasswordButton(),

                      const SizedBox(height: 28),
                      CustomButton(
                        text: isLoading
                            ? 'جاري تسجيل الدخول...'
                            : 'تسجيل الدخول',
                        isLoading: isLoading,
                        onPressed: _submit,
                      ),

                      const SizedBox(height: 24),
                      const _OrDivider(),
                      const SizedBox(height: 24),
                      const _SocialButtons(),

                      const SizedBox(height: 32),
                      const _RegisterPrompt(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'مرحباً بك مجدداً! 👋',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'قم بتسجيل الدخول لمتابعة رحلة تعلمك',
          style: TextStyle(fontSize: 14, color: context.textSecondary),
        ),
      ],
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () => context.pushRoute<void>(Routes.forgetPasswordPage),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'نسيت كلمة المرور؟',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final border = context.border;

    return Row(
      children: [
        Expanded(child: Divider(color: border)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('أو التسجيل بواسطة', style: TextStyle(fontSize: 12)),
        ),
        Expanded(child: Divider(color: border)),
      ],
    );
  }
}

class _SocialButtons extends StatelessWidget {
  const _SocialButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialSignInButton(
            icon: Icons.g_mobiledata_rounded,
            label: 'Google',
            onTap: () => snackBarMessage(
              context: context,
              text: 'تسجيل الدخول عبر Google غير مهيأ حالياً',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SocialSignInButton(
            icon: Icons.apple_rounded,
            label: 'Apple',
            onTap: () => snackBarMessage(
              context: context,
              text: 'تسجيل الدخول عبر Apple غير مهيأ حالياً',
            ),
          ),
        ),
      ],
    );
  }
}

class _RegisterPrompt extends StatelessWidget {
  const _RegisterPrompt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب؟',
          style: TextStyle(fontSize: 13, color: context.textSecondary),
        ),
        TextButton(
          onPressed: () => context.pushRoute<void>(Routes.signup),
          child: const Text(
            'إنشاء حساب جديد',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
