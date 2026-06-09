import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckRow extends StatelessWidget {
  const CheckRow({super.key, required this.label, required this.done});
final String label;
final bool done;
  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              size: 16.r,
              color: done
                  ? const Color(0xFF3B6D11)
                  : Theme.of(context).colorScheme.outlineVariant,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp.clamp(10, 14),
                color: done
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
}

