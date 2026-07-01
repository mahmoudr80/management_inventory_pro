import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'status_chip.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_model.dart';
import 'reason_tag.dart';

/// A single row of the adjustment history table. Stateless — selection
/// state is driven entirely by [isSelected] from the parent via cubit
/// state, avoiding any local UI state.
class AdjustmentRow extends StatelessWidget {
  const AdjustmentRow({
    super.key,
    required this.adjustment,
    required this.isSelected,
    required this.onTap,
  });

  final AdjustmentModel adjustment;
  final bool isSelected;
  final VoidCallback onTap;

  static final _dateFormat = DateFormat('d MMM, HH:mm');
  static final _currencyFormat = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    final qtyChange = adjustment.qtyChange;
    final isNegative = qtyChange < 0;
    final isZero = qtyChange == 0;
    final changeColor = isZero
        ? AppColors.onSurfaceVariant
        : (isNegative ? AppColors.error : AppColors.primary);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer.withOpacity(0.08)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: AppColors.outlineVariant),
            left: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 1.w,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                adjustment.id,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.dataMono.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                overflow: TextOverflow.ellipsis,
                _dateFormat.format(adjustment.dateTime),
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(flex: 3, child: ReasonTag(reason: adjustment.reason)),
            Expanded(
              flex: 2,
              child: Text(
                overflow: TextOverflow.ellipsis,
                '${adjustment.productCount} SKUs',
                style: AppTextStyles.bodySm,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                overflow: TextOverflow.ellipsis,
                '${isNegative ? '' : '+'}$qtyChange Units',
                style: AppTextStyles.bodySm.copyWith(
                  color: changeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                '${isNegative ? '-' : isZero ? '' : '+'}${_currencyFormat.format(adjustment.valueImpact.abs())} EGP',
                style: AppTextStyles.bodySm.copyWith(
                  color: changeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(overflow: TextOverflow.ellipsis,
                  adjustment.createdBy, style: AppTextStyles.bodySm),
            ),
            Expanded(
              flex: 2,
              child: Align(
                child: StatusChip(status: adjustment.status, dense: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
