
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class DateRangeButton extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String Function(DateTimeRange) formatDateRange;

  const DateRangeButton({super.key,
    required this.selectedRange,
    required this.onTap,
    required this.onClear,
    required this.formatDateRange,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = selectedRange != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal:16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryFixed : AppColors.surface,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.outline,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 15,
              color: isActive
                  ? AppColors.onPrimaryFixedVariant
                  : AppColors.outline,
            ),
            SizedBox(width: 8),
            Text(
              isActive
                  ? formatDateRange(selectedRange!)
                  : 'Date range',
              style: AppTextStyles.bodySm.copyWith(
                color: isActive
                    ? AppColors.onPrimaryFixedVariant
                    : AppColors.onSurfaceVariant,
                fontSize: 4.sp.clamp(2,15)
              ),
            ),
            if (isActive && onClear != null) ...[
              SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: AppColors.onPrimaryFixedVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}