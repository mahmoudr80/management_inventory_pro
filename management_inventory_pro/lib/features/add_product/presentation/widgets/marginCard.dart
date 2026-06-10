import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarginCard extends StatelessWidget {
  const MarginCard({super.key, this.marginPercent, required this.sell, required this.cost});
final double ?marginPercent;
final double sell;
final double cost;

  @override
  Widget build(BuildContext context) {
      final margin = marginPercent;
      if (margin == null) return const SizedBox.shrink();

      final profit = sell - cost;
      final isGood = margin > 20;
      final isOk = margin > 0;
      final bgColor = isGood
          ? const Color(0xFFEAF3DE)
          : isOk
          ? const Color(0xFFFAEEDA)
          : const Color(0xFFFCEBEB);
      final textColor = isGood
          ? const Color(0xFF3B6D11)
          : isOk
          ? const Color(0xFF854F0B)
          : const Color(0xFFA32D2D);

      return Container(
        margin: EdgeInsets.only(top: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gross margin',
                      style: TextStyle(
                          fontSize: 10.sp.clamp(9, 12), color: textColor)),
                  Text('${margin.round()}%',
                      style: TextStyle(
                          fontSize: 20.sp.clamp(16, 26),
                          fontWeight: FontWeight.w700,
                          color: textColor)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Profit / unit',
                      style: TextStyle(
                          fontSize: 10.sp.clamp(9, 12), color: textColor)),
                  Text('\$${profit.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 16.sp.clamp(13, 20),
                          fontWeight: FontWeight.w600,
                          color: textColor)),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

