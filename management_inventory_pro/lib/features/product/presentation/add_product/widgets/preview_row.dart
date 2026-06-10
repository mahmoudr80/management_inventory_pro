import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewRow extends StatelessWidget {
  const PreviewRow({super.key, required this.label, required this.value, this.mono=false});
final String label;
final String value;
final bool ?mono;
  @override
  Widget build(BuildContext context) {
      final cs = Theme.of(context).colorScheme;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11.sp.clamp(10, 13),
                    color: cs.onSurfaceVariant)),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 11.sp.clamp(10, 13),
                  fontWeight: FontWeight.w500,
                  color:
                  value == '—' ? cs.outlineVariant : cs.onSurface,
                  fontFamily: mono??false ? 'monospace' : null,
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

  }

