import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/extensions/context_theme_extension.dart';
import 'package:edu_app/core/routing/app_navigation.dart';
import 'package:edu_app/core/validators/app_validators.dart';
import 'package:edu_app/core/widgets/custom_button.dart';
import 'package:edu_app/core/widgets/custom_text_form_field.dart';
import 'package:edu_app/core/widgets/password_text_field.dart';
import 'package:edu_app/features/auth/presentation/widgets/auth_form_label.dart';
import 'package:flutter/material.dart';

/// Signup form, extracted from the page so the page only owns state and bloc
/// wiring. Keeps `build` small and the form independently testable.
class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
    required this.formKey,
    required this.isLoading,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.acceptTerms,
    required this.onAcceptTermsChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool acceptTerms;
  final ValueChanged<bool> onAcceptTermsChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Form(
        key: formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إنشاء حساب جديد ✨',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'انضم إلينا وابدأ بتطوير مهاراتك اليوم',
                style: TextStyle(fontSize: 14, color: context.textSecondary),
              ),

              const SizedBox(height: 28),
              const AuthFormLabel(text: 'الاسم الكامل'),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                hintText: 'محمد هاني',
                prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                validator: AppValidators.name,
              ),

              const SizedBox(height: 18),
              const AuthFormLabel(text: 'البريد الإلكتروني'),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                hintText: 'example@domain.com',
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
                // A second, stricter email regex used to live inline here;
                // it now shares the single AppValidators implementation.
                validator: AppValidators.email,
              ),

              const SizedBox(height: 18),
              const AuthFormLabel(text: 'كلمة المرور'),
              const SizedBox(height: 8),
              PasswordTextField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                validator: AppValidators.password,
              ),

              const SizedBox(height: 18),
              const AuthFormLabel(text: 'تأكيد كلمة المرور'),
              const SizedBox(height: 8),
              PasswordTextField(
                controller: confirmPasswordController,
                autofillHints: const [AutofillHints.newPassword],
                validator: AppValidators.confirmPassword(passwordController),
              ),

              const SizedBox(height: 14),
              _TermsAndConditions(
                value: acceptTerms,
                onChanged: onAcceptTermsChanged,
              ),

              const SizedBox(height: 24),
              CustomButton(
                text: isLoading ? 'جاري إنشاء الحساب...' : 'إنشاء الحساب',
                isLoading: isLoading,
                onPressed: onSubmit,
              ),

              const SizedBox(height: 24),
              const _LoginPrompt(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsAndConditions extends StatelessWidget {
  const _TermsAndConditions({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (v) => onChanged(v ?? false),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            children: [
              Text(
                'أوافق على ',
                style: TextStyle(fontSize: 12, color: context.textSecondary),
              ),
              const _TermsLink(text: 'الشروط والأحكام'),
              Text(
                ' و ',
                style: TextStyle(fontSize: 12, color: context.textSecondary),
              ),
              const _TermsLink(text: 'سياسة الخصوصية'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Tappable legal link. The destination page is not implemented yet, so the
/// tap is a documented no-op rather than a silently empty callback.
class _TermsLink extends StatelessWidget {
  const _TermsLink({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟',
          style: TextStyle(fontSize: 13, color: context.textSecondary),
        ),
        TextButton(
          onPressed: () => context.popRoute<void>(),
          child: const Text(
            'تسجيل الدخول',
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