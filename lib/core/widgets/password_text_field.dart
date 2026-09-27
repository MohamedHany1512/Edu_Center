import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// A password field with a built-in visibility toggle.
///
/// Extracted because the same obscure/visible toggle state machine was
/// duplicated across `login_page`, `signup_page` (twice) and
/// `change_password_page`. Making it a stateful widget means the toggle
/// rebuilds only this field, not the whole enclosing form page.
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
    this.autofillHints = const [AutofillHints.password],
  });

  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
        suffixIcon: IconButton(
          tooltip: _isObscured ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
          icon: Icon(
            _isObscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 20,
          ),
          onPressed: () => setState(() => _isObscured = !_isObscured),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
      ),
    );
  }
}