import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/stock_adjustment_item_model.dart';

class ProductInformation extends StatelessWidget {
  final StockAdjustmentItemModel item;

  const ProductInformation({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.inventory_2_outlined,
          color: AppColors.primary,
          size: 40.r,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.productName,
                style: TextStyle(
                  fontSize: 5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF131B2E),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                overflow: TextOverflow.ellipsis,
                'SKU: ${item.sku} · ${item.barcode}',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 4.sp,
                  color: const Color(0xFF737688),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: const Color(0xFFEAEDFF),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: const Color(0xFFC3C5D9)),
      ),
      child: Icon(
        Icons.image_outlined,
        size: 28.r,
        color: const Color(0xFF737688),
      ),
    );
  }
}
