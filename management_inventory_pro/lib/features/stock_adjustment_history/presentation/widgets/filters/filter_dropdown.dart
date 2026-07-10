import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

class FilterDropdown<T> extends StatelessWidget {
  const FilterDropdown({
    super.key,
    required this.value,
    required this.allLabel,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  final T? value;
  final String allLabel;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        border: Border.all(color: context.colors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T?>(
          value: value,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: AppIconSize.lg,
            color: context.colors.onSurfaceVariant,
          ),
          style: AppTextStyles.bodySm.copyWith(color: context.colors.onSurfaceVariant),
          dropdownColor: context.colors.surfaceContainerLowest,
          onChanged: onChanged,
          items: [
            DropdownMenuItem<T?>(
              value: null,
              child: Tooltip(
                message: allLabel,
                child: Text(
                  allLabel,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            ...items.map(
                  (item) => DropdownMenuItem<T?>(
                value: item,
                child: Tooltip(
                  message: labelBuilder(item),
                  child: Text(
                    labelBuilder(item),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}