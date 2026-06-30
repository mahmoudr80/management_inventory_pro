import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum WarningLevel { low, out, negative }

class WarningBadge extends StatelessWidget {
  final WarningLevel level;

  const WarningBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final (color, icon, text) = switch (level) {
      WarningLevel.negative => (
      const Color(0xFFBA1A1A),
      Icons.error_outline,
      'Negative',
      ),
      WarningLevel.out => (
      const Color(0xFFBA1A1A),
      Icons.remove_circle_outline,
      'Out of stock',
      ),
      WarningLevel.low => (
      const Color(0xFFF59E0B),
      Icons.warning_amber_rounded,
      'Low stock',
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: text,
          child: Icon(size: 20.r,
            icon,
            color: color,
          ),
        )
      ],
    );
  }
}
