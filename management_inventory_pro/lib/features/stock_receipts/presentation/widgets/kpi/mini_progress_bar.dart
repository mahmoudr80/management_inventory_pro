import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';

class MiniProgressBar extends StatelessWidget {
  final double fraction; // 0.0 – 1.0
  final Color? color;

  const MiniProgressBar({
    super.key,
    required this.fraction,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? context.colors.error;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: fraction.clamp(0.0, 1.0),
        backgroundColor: context.colors.surfaceVariant,
        valueColor: AlwaysStoppedAnimation(resolvedColor),
        minHeight: 6,
      ),
    );
  }
}