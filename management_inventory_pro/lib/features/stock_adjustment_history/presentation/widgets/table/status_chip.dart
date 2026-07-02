import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/adjustment_status.dart';
import '../../../../../core/theme/app_dimens.dart';

/// Pill badge rendering an [AdjustmentStatus]'s label in its theme color.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.dense = false});

  final AdjustmentStatus status;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 2.w : 3.w,
        vertical: dense ? 2.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        overflow: TextOverflow.ellipsis,
        status.label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: dense ? 3.0.sp : 3.5.sp,
          fontWeight: FontWeight.w700,
          color: status.foreground,
          letterSpacing: 0.02,
        ),
      ),
    );
  }
}
