import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/stock_adjustment_item_model.dart';
import '../common/warning_badge.dart';

class MovementPreviewItem extends StatelessWidget {
  final StockAdjustmentItemModel item;

  const MovementPreviewItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isPositive = item.adjustmentQty > 0;
    final adjColor = isPositive ? const Color(0xFF0041C8) : const Color(0xFFBA1A1A);
    final adjPrefix = isPositive ? '+' : '';

    return Container(
      padding: EdgeInsets.symmetric(vertical:  10.h,horizontal: 2.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFC3C5D9).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.productName,
            style: TextStyle(
              fontSize: 4.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF131B2E),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StockLabel(label: 'FROM', value: '${item.currentStock}', color: const Color(0xFF131B2E)),
              //SizedBox(width: 2.w),
              Icon(Icons.arrow_forward, size: 28.r, color: const Color(0xFF737688)),
              //SizedBox(width: 2.w),
              _StockLabel(
                label: 'TO',
                value: '${item.newStock}',
                color: item.isNegativeInventory || item.isOutOfStock
                    ? const Color(0xFFBA1A1A)
                    : isPositive
                        ? const Color(0xFF0041C8)
                        : const Color(0xFF131B2E),
              ),
              //const Spacer(),
              Container(
                width: 1,
                height: 24.h,
                color: const Color(0xFFC3C5D9),
              ),
              //SizedBox(width: 8.w),
              Text(
                '$adjPrefix${item.adjustmentQty}',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 4.sp,
                  fontWeight: FontWeight.w700,
                  color: adjColor,
                ),
              ),
            ],
          ),
          if (item.isNegativeInventory || item.isLowStock || item.isOutOfStock) ...[
            //SizedBox(height: 4.h),
            WarningBadge(
              level: item.isNegativeInventory
                  ? WarningLevel.negative
                  : item.isOutOfStock
                      ? WarningLevel.out
                      : WarningLevel.low,
            ),
          ],
        ],
      ),
    );
  }
}

class _StockLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StockLabel({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 4.sp, color: const Color(0xFF737688)),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 4.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
