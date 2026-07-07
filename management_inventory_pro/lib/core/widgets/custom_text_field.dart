import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_decoration.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Labeled text field used across forms.
///
/// Refactor notes (responsive_rules.md):
/// - Removed `flutter_screenutil` (.h/.w/.r) in favor of `AppSpacing` /
///   `AppRadius` so the field renders consistently from 900px up to
///   ultrawide, instead of scaling relative to a mobile design frame.
/// - Default decoration now goes through `AppDecorations.inputField()` so
///   borders/radius/colors stay centralized in `core/theme`.
/// - Label wrapped in a `Tooltip` + ellipsis: long field labels (e.g. from
///   dynamic form configs) truncate cleanly instead of wrapping/overflowing.
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final String? prefixText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final InputDecoration? inputDecoration;
  final void Function(String)? onChanged;
  final TextStyle? hintStyle;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.helperText,
    this.prefixText,
    this.inputDecoration,
    this.onChanged,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tooltip(
          message: label,
          waitDuration: const Duration(milliseconds: 500),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        TextFormField(
          maxLines: maxLines,
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.bodyMd,
          decoration: inputDecoration ??
              AppDecorations.inputField(
                hint: hint,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
              ).copyWith(
                prefixText: prefixText,
                helperText: helperText,
                hintStyle: hintStyle ??
                    AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.standard),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.standard),
                  borderSide: const BorderSide(color: AppColors.primary, width: AppBorder.thick),
                ),
              ),
        ),
      ],
    );
  }
}
