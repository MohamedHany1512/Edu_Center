import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/functions.dart';
import 'package:edu_app/core/validators/app_validators.dart';
import 'package:edu_app/core/widgets/custom_button.dart';
import 'package:edu_app/core/widgets/custom_text_form_field.dart';
import 'package:edu_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:edu_app/features/auth/presentation/widgets/auth_form_label.dart';
import 'package:edu_app/features/auth/presentation/widgets/auth_top_logo_with_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().sendResetLink(email: _emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            snackBarMessage(
              context: context,
              text: state.message,
              backgroundColor: AppColors.error,
            );
          }

          if (state is AuthResetLinkSent) {
            snackBarMessage(
              context: context,
              text: 'Reset link sent successfully',
              backgroundColor: AppColors.success,
            );
          }
        },
        buildWhen: (previous, current) =>
            current is AuthLoading ||
            current is AuthResetLinkSent ||
            current is AuthError ||
            current is AuthInitial,
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const AuthTopLogoWithBack(text: 'Forget Password'),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AuthFormLabel(text: 'Email'),
                        const SizedBox(height: 12),
                        CustomTextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.email],
                          hintText: 'Enter your email',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            size: 20,
                          ),
                          validator: AppValidators.email,
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Send reset link',
                          isLoading: isLoading,
                          onPressed: _submit,
                        ),
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