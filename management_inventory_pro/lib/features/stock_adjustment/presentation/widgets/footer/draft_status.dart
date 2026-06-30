import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DraftStatus extends StatelessWidget {
  final bool isSaved;

  const DraftStatus({super.key, required this.isSaved});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEDFF),
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: const Color(0xFFC3C5D9)),
          ),
          child: Text(
            'Ctrl+S',
            style: TextStyle(
              fontSize: 3.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF434656),
            ),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          overflow: TextOverflow.ellipsis,
          isSaved ? 'Draft Saved' : 'Unsaved changes',
          style: TextStyle(
            fontSize: 4.sp,
            color: isSaved ? const Color(0xFF22C55E) : const Color(0xFF737688),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
