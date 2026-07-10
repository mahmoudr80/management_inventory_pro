import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_adjustment_model.dart';

class AdjustmentProductRow extends StatelessWidget {
  const AdjustmentProductRow({super.key, required this.product});

  final ProductAdjustmentModel product;

  @override
  Widget build(BuildContext context) {
    final isNegative = product.adjustmentQty < 0;
    final changeColor = isNegative ? context.colors.error : context.colors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: product.productName,
                  child: Text(
                    product.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Tooltip(
                  message: product.sku,
                  child: Text(
                    product.sku,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.dataMono.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Tooltip(
                  message: '${isNegative ? '' : '+'}${product.adjustmentQty}',
                  child: Text(
                    '${isNegative ? '' : '+'}${product.adjustmentQty}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(
                      color: changeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Prev: ${product.previousStock}',
                  child: Text(
                    'Prev: ${product.previousStock}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Tooltip(
                  message: '${product.newStock}',
                  child: Text(
                    '${product.newStock}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Tooltip(
                  message: product.stockStatus.label,
                  child: Text(
                    product.stockStatus.label,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelCaps.copyWith(
                      color: product.stockStatus.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}