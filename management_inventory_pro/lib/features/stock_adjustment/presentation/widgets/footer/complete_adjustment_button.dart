import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

class CompleteAdjustmentButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CompleteAdjustmentButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            'Ctrl+↵',
            style: AppTextStyles.labelCaps.copyWith(
              // Was Colors.white70 on a near-white chip background —
              // effectively invisible. AppColors.primary matches the chip's
              // tint and is actually readable.
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
            elevation: 2,
          ),
          icon: const Icon(Icons.task_alt, size: AppIconSize.lg),
          label: Text(
            'Complete Adjustment',
            style: AppTextStyles.buttonText.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
