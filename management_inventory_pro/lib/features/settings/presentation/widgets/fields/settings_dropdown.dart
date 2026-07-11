import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

class SettingsDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> options;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;
  final String placeholder;
  final String? emptyMessage;

  const SettingsDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.labelBuilder,
    required this.onChanged,
    this.placeholder = 'Select an option',
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final hasOptions = options.isNotEmpty;
    // Only pass a value through if it actually matches an option —
    // otherwise DropdownButtonFormField asserts and crashes.
    final safeValue = (value != null && options.contains(value)) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMd.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<T>(
          value: safeValue,
          hint: Text(
            hasOptions ? placeholder : (emptyMessage ?? placeholder),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMd,
          ),
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
          onChanged: hasOptions
              ? (selected) {
            if (selected != null) onChanged(selected);
          }
              : null,
        ),
      ],
    );
  }
}
