import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/functions.dart';
import 'package:edu_app/core/routing/app_navigation.dart';
import 'package:edu_app/core/validators/app_validators.dart';
import 'package:edu_app/core/widgets/custom_button.dart';
import 'package:edu_app/core/widgets/password_text_field.dart';
import 'package:edu_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:edu_app/features/auth/presentation/widgets/auth_form_label.dart';
import 'package:edu_app/features/auth/presentation/widgets/auth_top_logo_with_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().changePassword(
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordChanged) {
            snackBarMessage(
              context: context,
              text: 'Password changed successfully',
              backgroundColor: AppColors.success,
            );
            context.popRoute<void>();
          }

          if (state is AuthError) {
            snackBarMessage(
              context: context,
              text: state.message,
              backgroundColor: AppColors.error,
            );
          }
        },
        buildWhen: (previous, current) =>
            current is AuthLoading ||
            current is AuthPasswordChanged ||
            current is AuthError ||
            current is AuthInitial,
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const AuthTopLogoWithBack(text: 'Change Password'),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AuthFormLabel(text: 'New Password'),
                        const SizedBox(height: 12),
                        PasswordTextField(
                          controller: _passwordController,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          hintText: 'Enter your password',
                          validator: AppValidators.password,
                        ),
                        const SizedBox(height: 18),
                        const AuthFormLabel(text: 'Confirm Password'),
                        const SizedBox(height: 12),
                        PasswordTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Re-enter your password',
                          // The local `_confirmPasswordValidator` method was
                          // removed in favour of the shared implementation.
                          validator: AppValidators.confirmPassword(
                            _passwordController,
                          ),
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 25),
                        CustomButton(
                          text: isLoading
                              ? 'Changing...'
                              : 'Change Password',
                          isLoading: isLoading,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}