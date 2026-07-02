import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_model.dart';
import '../table/status_chip.dart';

/// Top section of the right detail panel: adjustment id, status, created
/// date, and the reason / created-by info chips.
class DetailsHeader extends StatelessWidget {
  const DetailsHeader({
    super.key,
    required this.adjustment,
    required this.onClose,
  });

  final AdjustmentModel adjustment;
  final VoidCallback onClose;

  static final _dateFormat = DateFormat('d MMM, HH:mm');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:  20.h,horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(overflow: TextOverflow.ellipsis,'Adjustment Details', style: AppTextStyles.headlineSm),
              IconButton(
                onPressed: onClose,
                icon: Icon(Icons.close, size: 28.r, color: AppColors.onSurfaceVariant),
                splashRadius: 18.r,
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      adjustment.id,
                      style: AppTextStyles.dataMono.copyWith(
                        fontSize: 5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      'Created on ${_dateFormat.format(adjustment.dateTime)}',
                      style: AppTextStyles.bodySm.copyWith(
                        fontSize: 4.sp,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(status: adjustment.status),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Reason',
                  icon: adjustment.reason.icon,
                  iconColor: adjustment.reason.color,
                  value: adjustment.reason.label,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _InfoTile(
                  label: 'Created By',
                  icon: Icons.person_outline,
                  iconColor: AppColors.onSurfaceVariant,
                  value: adjustment.createdBy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:  12.h,horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            overflow: TextOverflow.ellipsis,
            label.toUpperCase(),
            style: AppTextStyles.labelCaps.copyWith(fontSize: 4.sp),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(icon, size: 20.r, color: iconColor),
              SizedBox(width: 1.w),
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600,fontSize: 3.5.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
