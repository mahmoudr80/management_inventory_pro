import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/adjustment_reason.dart';

class ReasonDropdown extends StatelessWidget {
  final AdjustmentReason? selected;
  final ValueChanged<AdjustmentReason?> onChanged;

  const ReasonDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFC3C5D9)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AdjustmentReason?>(
          value: selected,
          hint: Text(
            'Reason: Select...',
            style: TextStyle(fontSize: 5.sp, color: const Color(0xFF737688)),
          ),
          icon: Icon(Icons.keyboard_arrow_down, size: 28.r, color: const Color(0xFF737688)),
          style: TextStyle(fontSize: 5.sp, color: const Color(0xFF131B2E), fontFamily: 'Inter'),
          items: [
            DropdownMenuItem<AdjustmentReason?>(
              value: null,
              child: Text(
                'No reason',
                style: TextStyle(fontSize: 5.sp, color: const Color(0xFF737688)),
              ),
            ),
            ...AdjustmentReason.values.map(
              (r) => DropdownMenuItem(
                value: r,
                child: Text('Reason: ${r.label}'  ,style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600)),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
