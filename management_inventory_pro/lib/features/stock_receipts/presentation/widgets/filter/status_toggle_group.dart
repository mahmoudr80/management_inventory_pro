import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_status.dart';

class StatusToggleGroup extends StatelessWidget {
  final StockEntryStatus? activeStatus;
  final ValueChanged<StockEntryStatus?> onChanged;

  const StatusToggleGroup({super.key,
    required this.activeStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: _StatusChip(
            label: 'All',
            isActive: activeStatus == null,
            onTap: () => onChanged(null),
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          child: _StatusChip(
            label: 'Pending',
            isActive: activeStatus == StockEntryStatus.pending,
            onTap: () => onChanged(StockEntryStatus.pending),
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          child: _StatusChip(
            label: 'Verified',
            isActive: activeStatus == StockEntryStatus.verified,
            onTap: () => onChanged(StockEntryStatus.verified),
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          child: _StatusChip(
            label: 'Cancelled',
            isActive: activeStatus == StockEntryStatus.cancelled,
            onTap: () => onChanged(StockEntryStatus.cancelled),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodySm.copyWith(
            color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            fontSize: 4.sp.clamp(2, 15),overflow: TextOverflow.ellipsis
          ),
        ),
      ),
    );
  }
}
