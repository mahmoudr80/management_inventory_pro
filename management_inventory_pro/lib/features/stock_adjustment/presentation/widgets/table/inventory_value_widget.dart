import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
        ? const Color(0xFF737688)
        : isPositive
            ? const Color(0xFF0041C8)
            : const Color(0xFFBA1A1A);

    final formatted = NumberFormat.currency(symbol: '\$', decimalDigits: 2)
        .format(impact.abs());
    final prefix = isZero ? '' : isPositive ? '+' : '-';

    return Text(
      '$prefix$formatted',
      style: TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: 5.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
