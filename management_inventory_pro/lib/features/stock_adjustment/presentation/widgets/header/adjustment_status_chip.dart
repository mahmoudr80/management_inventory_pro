import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/stock_adjustment_model.dart';

class AdjustmentStatusChip extends StatelessWidget {
  final AdjustmentStatus status;

  const AdjustmentStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, dot) = switch (status) {
      AdjustmentStatus.draft => (
          const Color(0xFFFEF3C7),
          const Color(0xFF92400E),
          const Color(0xFFF59E0B),
        ),
      AdjustmentStatus.completed => (
          const Color(0xFFDCFCE7),
          const Color(0xFF14532D),
          const Color(0xFF22C55E),
        ),
      AdjustmentStatus.cancelled => (
          const Color(0xFFFFDAD6),
          const Color(0xFF93000A),
          const Color(0xFFBA1A1A),
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: dot.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4.w,
            height: 6.w,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          SizedBox(width: 2.w),
          Text(
            status.label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 4.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
