import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompleteAdjustmentDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const CompleteAdjustmentDialog({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 4,
      child: SizedBox(
        width: 200.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w,vertical:  12.h),
          child: Column(
            spacing: 8.h,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 2.w,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical:  8.h,horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEDFF),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.task_alt,
                      size: 40.r,
                      color: const Color(0xFF0041C8),
                    ),
                  ),
                  Text(
                    'Complete Stock Adjustment',
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF131B2E),
                    ),
                  ),
                ],
              ),
              Container(
                padding:EdgeInsets.symmetric(vertical:  8.h,horizontal: 2.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.4)),
                ),
                child: Row(
                  spacing: 2.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 30.r, color: const Color(0xFFF59E0B)),
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        'This operation will immediately update inventory quantities. Completed adjustments cannot be edited.',
                        style: TextStyle(
                          fontSize: 5.sp,
                          color: const Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF131B2E),
                      side: const BorderSide(color: Color(0xFFC3C5D9)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical:  8.h,horizontal: 6.w),
                    ),
                    child: Text('Cancel', style: TextStyle(fontSize: 5.sp)),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0041C8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical:  8.h,horizontal: 6.w),
                    ),
                    icon: Icon(Icons.task_alt, size: 40.r),
                    label: Text(
                      'Complete Adjustment',
                      style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
