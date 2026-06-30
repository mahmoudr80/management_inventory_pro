import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdjustmentTableHeader extends StatelessWidget {
  const AdjustmentTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: const BoxDecoration(
        color: Color(0xFFEAEDFF),
        border: Border(bottom: BorderSide(color: Color(0xFFC3C5D9))),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 5.w),
          _HeaderCell('#', flex: 0, width: 10.w),
          _HeaderCell('Product Details', flex: 2),
          _HeaderCell('Current', flex: 1, ),
          _HeaderCell('Adjustment', flex: 1,),
          _HeaderCell('New Level', flex: 1, ),
          _HeaderCell('Value Impact', flex: 1,),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  final double? width;
  final TextAlign textAlign;

  const _HeaderCell(
    this.label, {
    required this.flex,
    this.width,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 4.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.05,
        color: const Color(0xFF434656),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: Padding(padding: EdgeInsets.symmetric(horizontal: 2.w), child: text));
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: text,
      ),
    );
  }
}
