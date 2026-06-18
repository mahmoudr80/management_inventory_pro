import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class MiniProgressBar extends StatelessWidget {
  final double fraction; // 0.0 – 1.0
  final Color color;

  const MiniProgressBar({
    super.key,
    required this.fraction,
    this.color = AppColors.error,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: fraction.clamp(0.0, 1.0),
        backgroundColor: AppColors.surfaceVariant,
        valueColor: AlwaysStoppedAnimation(color),
        minHeight: 6,
      ),
    );
  }
}
