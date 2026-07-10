import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_adjustment_item_model.dart';
import '../common/warning_badge.dart';

class NewStockWidget extends StatelessWidget {
  final StockAdjustmentItemModel item;

  const NewStockWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Color stockColor = context.colors.textPrimary;
    if (item.isNegativeInventory) {
      stockColor = context.colors.error;
    } else if (item.isOutOfStock) {
      stockColor = context.colors.error;
    } else if (item.isLowStock) {
      stockColor = context.colors.warning;
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xs,
      children: [
        Text(
          '${item.newStock}',
          style: AppTextStyles.dataMono.copyWith(
            fontWeight: FontWeight.w700,
            color: stockColor,
          ),
        ),
        if (item.isNegativeInventory)
          const WarningBadge(level: WarningLevel.negative)
        else if (item.isOutOfStock)
          const WarningBadge(level: WarningLevel.out)
        else if (item.isLowStock)
            const WarningBadge(level: WarningLevel.low),
      ],
    );
  }
}