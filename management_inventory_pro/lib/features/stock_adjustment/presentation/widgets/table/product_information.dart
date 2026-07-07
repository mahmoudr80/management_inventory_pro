import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_adjustment_item_model.dart';

class ProductInformation extends StatelessWidget {
  final StockAdjustmentItemModel item;

  const ProductInformation({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.inventory_2_outlined,
          color: AppColors.primary,
          size: AppIconSize.xl,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: item.productName,
                child: Text(
                  item.productName,
                  style: AppTextStyles.bodySm.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Tooltip(
                message: 'SKU: ${item.sku} · ${item.barcode}',
                child: Text(
                  'SKU: ${item.sku} · ${item.barcode}',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.dataMono.copyWith(
                    fontSize: 11,
                    color: AppColors.outline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
