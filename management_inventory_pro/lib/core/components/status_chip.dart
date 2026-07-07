import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

enum StatusType {
  inStock,
  lowStock,
  outOfStock,

  active,
  inactive,
  pending,
  completed,
  cancelled,
}

class StatusChip extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusChip({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    bool showDot = false;
    Color? dotColor;

    switch (type) {
      case StatusType.inStock:
        backgroundColor = AppColors.successContainer;
        textColor = AppColors.success;
        showDot = true;
        dotColor = AppColors.success;
        break;

      case StatusType.lowStock:
        backgroundColor = AppColors.warningContainer;
        textColor = AppColors.onWarningContainer;
        showDot = true;
        dotColor = AppColors.onWarningContainer;
        break;

      case StatusType.outOfStock:
        backgroundColor = AppColors.errorContainer;
        textColor = AppColors.error;
        showDot = true;
        dotColor = AppColors.error;
        break;

      case StatusType.active:
        backgroundColor = AppColors.successContainer;
        textColor = AppColors.success;
        showDot = true;
        dotColor = AppColors.success;
        break;

      case StatusType.inactive:
        backgroundColor = AppColors.surfaceContainerLow;
        textColor = AppColors.secondary;
        break;

      case StatusType.pending:
        backgroundColor = AppColors.infoContainer;
        textColor = AppColors.info;
        break;

      case StatusType.completed:
        backgroundColor = AppColors.successContainer;
        textColor = AppColors.success;
        break;

      case StatusType.cancelled:
        backgroundColor = AppColors.errorContainer;
        textColor = AppColors.error;
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(
        // 1.25x / 1x gutter instead of bare 5 / 4 literals.
        horizontal: (AppSpacing.gutter * 1.25).w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        // AppRadius.full guarantees a true pill regardless of the chip's
        // rendered height, rather than a fixed 12px that only looked
        // pill-shaped by coincidence.
        borderRadius: BorderRadius.circular(AppRadius.full.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot && dotColor != null) ...[
            Container(
              width: (AppSpacing.gutter * 1.5).r,
              height: (AppSpacing.gutter * 1.5).r,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: (AppSpacing.gutter * 1.5).w),
          ],
          Text(
            label,
            style: AppTextStyles.labelCaps.copyWith(
              color: textColor,
              fontSize: 8.sp.clamp(5, 12),
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}
