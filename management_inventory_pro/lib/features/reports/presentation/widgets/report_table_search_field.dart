import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// The compact search box that sits in a [ReportDataTable]'s header,
/// matching the reference UI's "Filter invoices...", "Search SKU..."
/// fields (code.html, Image 2). Extracted as its own widget so every
/// report screen wires it into `headerTrailing` the same way instead of
/// duplicating the same small TextField five separate times.
class ReportTableSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hint;

  const ReportTableSearchField({super.key, required this.onChanged, required this.hint});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 28,
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.bodySm,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodySm.copyWith(color: context.colors.outline),
          isDense: true,
          filled: true,
          fillColor: context.colors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: BorderSide(color: context.colors.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: BorderSide(color: context.colors.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: BorderSide(color: context.colors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
