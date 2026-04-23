import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.obscureText = false,
    this.autofillHints,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.minLines,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;
  final int? minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      validator: validator,
      obscureText: obscureText,
      autofillHints: autofillHints,
      onFieldSubmitted: onSubmitted,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}

