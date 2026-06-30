import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscardDraftButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DiscardDraftButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEDFF),
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: const Color(0xFFC3C5D9)),
          ),
          child: Text(
            'Del',
            style: TextStyle(
              fontSize: 3.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF434656),
            ),
          ),
        ),
        SizedBox(width: 2.w),
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF131B2E),
            side: const BorderSide(color: Color(0xFF737688)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
          ),
          child: Text(
            'Discard Draft',
            style: TextStyle(
              fontSize: 4.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
