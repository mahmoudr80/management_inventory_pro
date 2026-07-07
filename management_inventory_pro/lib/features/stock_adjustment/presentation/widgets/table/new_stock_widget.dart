import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_adjustment_item_model.dart';
import '../common/warning_badge.dart';

class NewStockWidget extends StatelessWidget {
  final StockAdjustmentItemModel item;

  const NewStockWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Color stockColor = AppColors.textPrimary;
    if (item.isNegativeInventory) {
      stockColor = AppColors.error;
    } else if (item.isOutOfStock) {
      stockColor = AppColors.error;
    } else if (item.isLowStock) {
      stockColor = AppColors.warning;
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
