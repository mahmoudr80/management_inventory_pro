import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/stock_adjustment_item_model.dart';
import '../common/warning_badge.dart';

class NewStockWidget extends StatelessWidget {
  final StockAdjustmentItemModel item;

  const NewStockWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Color stockColor = const Color(0xFF131B2E);
    if (item.isNegativeInventory) stockColor = const Color(0xFFBA1A1A);
    else if (item.isOutOfStock) stockColor = const Color(0xFFBA1A1A);
    else if (item.isLowStock) stockColor = const Color(0xFFF59E0B);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${item.newStock}',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 5.sp,
            fontWeight: FontWeight.w700,
            color: stockColor,
          ),
        ),
        SizedBox(width: 2.w,),
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
