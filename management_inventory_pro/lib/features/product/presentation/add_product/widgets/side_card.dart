import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideCard extends StatelessWidget {
  const SideCard({super.key, required this.child, required this.title});
final Widget child;
final String title;
  @override
  Widget build(BuildContext context) {
      final cs = Theme.of(context).colorScheme;
      return Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.sp.clamp(9, 11),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Divider(height: 1, color: cs.outlineVariant),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: child,
            ),
          ],
        ),
      );
    }
  }

