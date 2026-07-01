import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_dimens.dart';

/// A single KPI card used in the summary row above the history table.
///
/// [trendPct] is optional — when provided it renders a small "+x%" badge
/// with a trend arrow next to the value. [valueColor] overrides the value
/// text color (used for the net-quantity and value-impact cards).
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.trendPct,
    this.valueColor,
    required this.caption,
  });

  final String label;
  final String value;
  final String? unit;
  final double? trendPct;
  final Color? valueColor;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final isPositiveTrend = (trendPct ?? 0) >= 0;

    return Container(
      padding: EdgeInsets.symmetric(vertical:  8.h,horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTextStyles.labelCaps),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTextStyles.display.copyWith(
                  color: valueColor ?? AppColors.onSurface,
                ),
              ),
              if (unit != null) ...[
                SizedBox(width: 2.w),
                Text(
                  unit!,
                  style: AppTextStyles.bodySm.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
              if (trendPct != null) ...[
                SizedBox(width: 2.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${isPositiveTrend ? '+' : ''}${trendPct!.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                    Icon(
                      Icons.trending_up,
                      size: 28.r,
                      color: AppColors.success,
                    ),
                  ],
                ),
              ],
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            caption,
            style: AppTextStyles.bodySm.copyWith(
              fontSize: 3.5.sp,
              color: AppColors.onSurfaceVariant.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
