import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

class CompleteAdjustmentDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const CompleteAdjustmentDialog({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      elevation: 4,
      child: ConstrainedBox(
        // Was a fixed SizedBox(width: 200) — far too narrow for the icon +
        // title row, the warning paragraph, and two full-size buttons; that
        // combination would overflow horizontally on any real window.
        // A ConstrainedBox with min/max lets it size to content between a
        // sensible floor and ceiling instead.
        constraints: const BoxConstraints(minWidth: 380, maxWidth: AppSize.cardMaxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            spacing: AppSpacing.sm,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: AppSpacing.sm,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      Icons.task_alt,
                      size: AppIconSize.xl,
                      color: context.colors.primary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Complete Stock Adjustment',
                      style: AppTextStyles.headlineSm.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.colors.warningContainer,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: context.colors.warning.withOpacity(0.4)),
                ),
                child: Row(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: AppIconSize.lg, color: context.colors.warning),
                    Expanded(
                      child: Text(
                        'This operation will immediately update inventory quantities. Completed adjustments cannot be edited.',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: AppTextStyles.bodySm.copyWith(
                          color: context.colors.onWarningContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colors.textPrimary,
                      side: BorderSide(color: context.colors.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.lg),
                    ),
                    child: Text('Cancel', style: AppTextStyles.bodySm),
                  ),
                  ElevatedButton.icon(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.lg),
                    ),
                    icon: const Icon(Icons.task_alt, size: AppIconSize.lg),
                    label: Text(
                      'Complete Adjustment',
                      style: AppTextStyles.buttonText.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}