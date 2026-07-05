import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

class AppDecorations {
  AppDecorations._();

  static BoxDecoration card({
    Color? color,
    double? radius,
  }) =>
      BoxDecoration(
        color: color ?? AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(radius ?? AppRadius.lg),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      );

  static InputDecoration searchField({
    required String hint,
    Widget? prefix,
    Widget? suffix,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
        prefixIcon: prefix,
        suffixIcon: suffix,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.gutter * 4,
          vertical: AppSpacing.gutter * 2.5,
        ),
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      );

  /// Input field — inactive states.
  static InputDecoration inputField({
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.gutter * 3,
          vertical: AppSpacing.gutter * 2.5,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.standard),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.standard),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.standard),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        isDense: true,
      );
}
