import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'status_chip.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
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
    final isQtyNegative = qtyChange < 0;
    final isQtyZero = qtyChange == 0;
    final qtyColor = isQtyZero
        ? AppColors.onSurfaceVariant
        : (isQtyNegative ? AppColors.error : AppColors.primary);

    // Value's sign follows valueImpact itself, not qtyChange — the two can
    // diverge (e.g. a write-off with a positive qty but negative value),
    // so deriving one sign from the other field was showing the wrong
    // +/- on the Value column.
    final valueImpact = adjustment.valueImpact;
    final isValueNegative = valueImpact < 0;
    final isValueZero = valueImpact == 0;
    final valueColor = isValueZero
        ? AppColors.onSurfaceVariant
        : (isValueNegative ? AppColors.error : AppColors.primary);
    final valueSign = isValueNegative ? '-' : (isValueZero ? '' : '+');

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer.withOpacity(0.08)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: AppColors.outlineVariant, width: AppBorder.thin),
            left: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: AppBorder.thin,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs, vertical: AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Tooltip(
                message: adjustment.id,
                child: Text(
                  adjustment.id,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.dataMono.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Tooltip(
                message: _dateFormat.format(adjustment.dateTime),
                child: Text(
                  _dateFormat.format(adjustment.dateTime),
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Expanded(flex: 3, child: ReasonTag(reason: adjustment.reason)),
            Expanded(
              flex: 2,
              child: Tooltip(
                message: '${adjustment.productCount} SKUs',
                child: Text(
                  '${adjustment.productCount} SKUs',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Tooltip(
                message: '${isQtyNegative ? '' : '+'}$qtyChange Units',
                child: Text(
                  '${isQtyNegative ? '' : '+'}$qtyChange Units',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm.copyWith(
                    color: qtyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Tooltip(
                message: '$valueSign${_currencyFormat.format(valueImpact.abs())} EGP',
                child: Text(
                  '$valueSign${_currencyFormat.format(valueImpact.abs())} EGP',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySm.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Tooltip(
                message: adjustment.createdBy,
                child: Text(
                  adjustment.createdBy,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm,
                ),
              ),
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
