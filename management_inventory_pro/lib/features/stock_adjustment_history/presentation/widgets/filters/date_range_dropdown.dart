import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';
import '../../../data/models/date_range_filter.dart';

class DateRangeDropdown extends StatelessWidget {
  const DateRangeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DateRangeFilter value;
  final ValueChanged<DateRangeFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        border: Border.all(color: context.colors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateRangeFilter>(
          value: value,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: AppIconSize.lg,
            color: context.colors.onSurfaceVariant,
          ),
          style: AppTextStyles.bodySm.copyWith(color: context.colors.onSurfaceVariant),
          dropdownColor: context.colors.surfaceContainerLowest,
          onChanged: (range) => onChanged(range ?? value),
          items: DateRangeFilter.values
              .map(
                (range) => DropdownMenuItem(
              value: range,
              child: Tooltip(
                message: range.label,
                child: Text(
                  range.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}