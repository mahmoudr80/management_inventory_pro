import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_adjustment_model.dart';

class AdjustmentStatusChip extends StatelessWidget {
  final AdjustmentStatus status;

  const AdjustmentStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, dot) = switch (status) {
      AdjustmentStatus.draft => (
          AppColors.warningContainer,
          AppColors.onWarningContainer,
          AppColors.warning,
        ),
      AdjustmentStatus.completed => (
          AppColors.statusHealthyBg,
          AppColors.statusHealthyFg,
          AppColors.statusHealthyDot,
        ),
      AdjustmentStatus.cancelled => (
          AppColors.statusCancelledBg,
          AppColors.statusCancelledFg,
          AppColors.statusCancelledDot,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: dot.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            status.label.toUpperCase(),
            style: AppTextStyles.labelCaps.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
