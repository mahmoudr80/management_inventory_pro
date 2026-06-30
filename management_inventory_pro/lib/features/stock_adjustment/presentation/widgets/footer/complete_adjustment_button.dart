import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompleteAdjustmentButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CompleteAdjustmentButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0041C8).withOpacity(0.15),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            'Ctrl+↵',
            style: TextStyle(
              fontSize: 3.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0041C8),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 12.h),
            elevation: 2,
          ),
          icon: Icon(Icons.task_alt, size: 28.r),
          label: Text(
            'Complete Adjustment',
            style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700),
          ),
        ),

      ],
    );
  }
}
