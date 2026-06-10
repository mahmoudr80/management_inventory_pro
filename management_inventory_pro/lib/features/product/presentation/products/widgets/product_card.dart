import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/components/app_card.dart';
import '../../../../../../core/components/status_chip.dart';
import '../../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
           // padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.
                      headlineSm.
                      copyWith(fontSize: 14.sp.clamp(10, 18),fontWeight: FontWeight.bold),
                    ),

                    SizedBox(width: 8.w),
                    StatusChip(
                      label: product.statusText??'in active',
                      type: product.status??StatusType.inStock,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  product.sku,
                  style: AppTextStyles.dataMono.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Category: ${product.category}',
                  style: AppTextStyles.bodySm.copyWith(
                    fontSize: 10.sp.clamp(8, 14)
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${product.currentStock} units',
                style: AppTextStyles.dataMono.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp.clamp(8, 18),
                ),
              ),
              SizedBox(height: 8.h),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
