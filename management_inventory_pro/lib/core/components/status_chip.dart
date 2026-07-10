import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme_extension.dart';
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
        backgroundColor = context.colors.successContainer;
        textColor = context.colors.success;
        showDot = true;
        dotColor = context.colors.success;
        break;

      case StatusType.lowStock:
        backgroundColor = context.colors.warningContainer;
        textColor = context.colors.onWarningContainer;
        showDot = true;
        dotColor = context.colors.onWarningContainer;
        break;

      case StatusType.outOfStock:
        backgroundColor = context.colors.errorContainer;
        textColor = context.colors.error;
        showDot = true;
        dotColor = context.colors.error;
        break;

      case StatusType.active:
        backgroundColor = context.colors.successContainer;
        textColor = context.colors.success;
        showDot = true;
        dotColor = context.colors.success;
        break;

      case StatusType.inactive:
        backgroundColor = context.colors.surfaceContainerLow;
        textColor = context.colors.secondary;
        break;

      case StatusType.pending:
        backgroundColor = context.colors.infoContainer;
        textColor = context.colors.info;
        break;

      case StatusType.completed:
        backgroundColor = context.colors.successContainer;
        textColor = context.colors.success;
        break;

      case StatusType.cancelled:
        backgroundColor = context.colors.errorContainer;
        textColor = context.colors.error;
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (AppSpacing.gutter * 1.25).w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
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