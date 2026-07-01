import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_dimens.dart';

/// Generic single-select filter dropdown matching the filter bar styling.
/// `null` represents the "All" / unset option, labeled via [allLabel].
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
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T?>(
          value: value,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 28.r,
            color: AppColors.onSurfaceVariant,
          ),
          style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
          dropdownColor: AppColors.surfaceContainerLowest,
          onChanged: onChanged,
          items: [
            DropdownMenuItem<T?>(value: null, child: Text(allLabel)),
            ...items.map(
              (item) => DropdownMenuItem<T?>(
                value: item,
                child: Text(labelBuilder(item)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
