import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48.r, color: const Color(0xFF737688)),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 6.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF131B2E),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 5.sp,
              color: const Color(0xFF434656),
            ),
          ),
        ],
      ),
    );
  }
}
