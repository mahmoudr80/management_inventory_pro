import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_adjustment_model.dart';

/// One row of the "Adjusted Products" table: product/SKU, signed
/// adjustment + previous stock, and new stock + health status.
class AdjustmentProductRow extends StatelessWidget {
  const AdjustmentProductRow({super.key, required this.product});

  final ProductAdjustmentModel product;

  @override
  Widget build(BuildContext context) {
    final isNegative = product.adjustmentQty < 0;
    final changeColor = isNegative ? AppColors.error : AppColors.primary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2.h),
                Text(
                  product.sku,
                  style: AppTextStyles.dataMono.copyWith(
                    fontSize: 3.sp,
                    color: AppColors.onSurfaceVariant,
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
                Text(
                  '${isNegative ? '' : '+'}${product.adjustmentQty}',
                  style: AppTextStyles.bodySm.copyWith(
                    color: changeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Prev: ${product.previousStock}',
                  style: AppTextStyles.bodySm.copyWith(
                    fontSize: 3.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
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
                Text(
                  '${product.newStock}',
                  style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  product.stockStatus.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 3.sp,
                    fontWeight: FontWeight.w700,
                    color: product.stockStatus.color,
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
