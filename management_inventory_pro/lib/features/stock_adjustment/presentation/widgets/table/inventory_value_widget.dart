import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_adjustment_item_model.dart';

class InventoryValueWidget extends StatelessWidget {
  final StockAdjustmentItemModel item;

  const InventoryValueWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final impact = item.valueImpact;
    final isPositive = impact > 0;
    final isZero = impact == 0;

    final color = isZero
        ? AppColors.outline
        : isPositive
            ? AppColors.primary
            : AppColors.error;

    final formatted = NumberFormat.currency(symbol: '\$', decimalDigits: 2)
        .format(impact.abs());
    final prefix = isZero ? '' : isPositive ? '+' : '-';

    return Text(
      '$prefix$formatted',
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.dataMono.copyWith(
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
