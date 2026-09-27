import 'package:edu_app/core/widgets/custom_text_form_field.dart';
 import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.validator,
    required this.hintText,
    required this.labelColor,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final String hintText;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 12),
        CustomTextFormField(
          controller: controller,
          validator: validator,
          hintText: hintText,
        ),
      ],
    );
  }
}
