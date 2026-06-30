import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowActions extends StatelessWidget {
  final VoidCallback onDelete;

  const RowActions({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Remove row (Del)',
      child: InkWell(
        onTap: onDelete,
        borderRadius: BorderRadius.circular(4.r),
        hoverColor: const Color(0xFFFFDAD6),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Icon(
            Icons.delete_outline,
            size: 28.r,
            color: const Color(0xFF737688),
          ),
        ),
      ),
    );
  }
}
