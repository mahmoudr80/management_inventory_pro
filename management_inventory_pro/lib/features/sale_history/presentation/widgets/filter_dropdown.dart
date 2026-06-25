import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterDropdown<T> extends StatelessWidget {
  const FilterDropdown({
    super.key,
    required this.value,
    required this.icon,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    this.marginTop = 31,
    this.height = 52,
  });

  final T value;
  final IconData icon;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;

  final double marginTop;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      margin: EdgeInsets.only(top: 31.h),
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              size: 5.sp, color: const Color(0xFF6B7280)),
          style: TextStyle(
            fontSize: 4.sp,
            color: const Color(0xFF374151),
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),
          items: items
              .map((item) => DropdownMenuItem<T>(
            value: item,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    size: 5.sp, color: const Color(0xFF6B7280)),
                SizedBox(width: 6.w),
                Text(labelBuilder(item)),
              ],
            ),
          ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
