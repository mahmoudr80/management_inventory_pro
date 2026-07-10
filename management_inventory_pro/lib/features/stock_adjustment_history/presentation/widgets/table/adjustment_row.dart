import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'status_chip.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_model.dart';
import 'reason_tag.dart';

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
        ? context.colors.onSurfaceVariant
        : (isQtyNegative ? context.colors.error : context.colors.primary);

    final valueImpact = adjustment.valueImpact;
    final isValueNegative = valueImpact < 0;
    final isValueZero = valueImpact == 0;
    final valueColor = isValueZero
        ? context.colors.onSurfaceVariant
        : (isValueNegative ? context.colors.error : context.colors.primary);
    final valueSign = isValueNegative ? '-' : (isValueZero ? '' : '+');

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primaryContainer.withOpacity(0.08)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: context.colors.outlineVariant, width: AppBorder.thin),
            left: BorderSide(
              color: isSelected ? context.colors.primary : Colors.transparent,
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
                    color: isSelected ? context.colors.primary : context.colors.onSurface,
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
                    color: context.colors.onSurfaceVariant,
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