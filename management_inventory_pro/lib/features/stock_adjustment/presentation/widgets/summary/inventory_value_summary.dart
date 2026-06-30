import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../data/models/stock_adjustment_model.dart';

class InventoryValueSummary extends StatelessWidget {
  final StockAdjustmentModel adjustment;

  const InventoryValueSummary({super.key, required this.adjustment});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final impact = adjustment.valuationImpact;
    final impactColor =
        impact >= 0 ? const Color(0xFF0041C8) : const Color(0xFFBA1A1A);
    final impactPrefix = impact >= 0 ? '+' : '';

    return Container(
      padding: EdgeInsets.symmetric(vertical:14.h,horizontal: 2.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0041C8).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF0041C8).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVENTORY VALUATION IMPACT',
            style: TextStyle(
              fontSize: 4.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
              color: const Color(0xFF0039B3),
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$impactPrefix${fmt.format(impact)}',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 6.sp,
                  fontWeight: FontWeight.w700,
                  color: impactColor,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'EGP',
                style: TextStyle(
                  fontSize: 5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF434656),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
