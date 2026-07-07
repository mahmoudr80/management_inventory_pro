import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_reason.dart';

class ReasonDropdown extends StatelessWidget {
  const ReasonDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AdjustmentReason? selected;
  final ValueChanged<AdjustmentReason?> onChanged;

  static const double _width = 220;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: AppSize.textFieldHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: AppColors.outlineVariant,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AdjustmentReason?>(
              value: selected,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: AppIconSize.lg,
                color: AppColors.outline,
              ),
              hint: Text(
                'Reason: Select...',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.outline,
                ),
              ),
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.textPrimary,
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(
                    'No reason',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.outline,
                    ),
                  ),
                ),
                ...AdjustmentReason.values.map(
                      (reason) => DropdownMenuItem(
                    value: reason,
                    child: Text(
                      'Reason: ${reason.label}',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelCaps.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}