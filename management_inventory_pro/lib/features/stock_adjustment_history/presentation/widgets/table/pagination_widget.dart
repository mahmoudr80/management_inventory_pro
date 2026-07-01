import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_dimens.dart';

/// Static (mock) pagination footer. Per spec, real pagination wiring is
/// out of scope for this audit screen.
class PaginationWidget extends StatelessWidget {
  const PaginationWidget({
    super.key,
    required this.totalCount,
    this.pageSize = 10,
    this.currentPage = 1,
  });

  final int totalCount;
  final int pageSize;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final start = totalCount == 0 ? 0 : ((currentPage - 1) * pageSize) + 1;
    final end = (currentPage * pageSize).clamp(0, totalCount);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $start-$end of $totalCount results',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,

            ),
          ),
          Row(
            children: [
              _PageButton(icon: Icons.chevron_left, onTap: () {}),
              SizedBox(width: 2.w),
              _PageNumber(label: '$currentPage', isActive: true),
              SizedBox(width: 2.w),
              _PageButton(icon: Icons.chevron_right, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.standard),
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outlineVariant),
          borderRadius: BorderRadius.circular(AppRadius.standard),
        ),
        child: Icon(icon, size: 28.r, color: AppColors.onSurfaceVariant),
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  const _PageNumber({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62.r,
      height: 32.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.standard),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySm.copyWith(
          color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
