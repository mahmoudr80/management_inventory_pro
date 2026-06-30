import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentStockWidget extends StatelessWidget {
  final double currentStock;
  final String unit;

  const CurrentStockWidget({
    super.key,
    required this.currentStock,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$currentStock',
      textAlign: TextAlign.right,
      style: TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: 5.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF131B2E),
      ),
    );
  }
}
