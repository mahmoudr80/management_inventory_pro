import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

/// Labeled dropdown for small, fixed option lists (timezone, language,
/// currency, date/time format, default unit...).
///
/// Deliberately simpler than `SearchSelectDropdown`: these lists are short
/// enough that search would be overkill, so this stays a plain themed
/// `DropdownButtonFormField`.
class SettingsDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> options;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;

  const SettingsDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMd.copyWith(
            fontWeight: FontWeight.w500,
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<T>(
          value: value,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: context.colors.outline),
          style: AppTextStyles.bodyMd.copyWith(color: context.colors.textPrimary),
          dropdownColor: context.colors.surface,
          decoration: InputDecoration(
            filled: true,
            fillColor: context.colors.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + AppSpacing.xxs,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: context.colors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: context.colors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: context.colors.primary, width: AppBorder.medium),
            ),
          ),
          items: options
              .map(
                (option) => DropdownMenuItem<T>(
                  value: option,
                  child: Text(
                    labelBuilder(option),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
        ),
      ],
    );
  }
}
