// presentation/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? initLab;
  final String? hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Widget? suffixIcon;
  
  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.suffixIcon,
    this.initLab
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          initialValue: initLab,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}