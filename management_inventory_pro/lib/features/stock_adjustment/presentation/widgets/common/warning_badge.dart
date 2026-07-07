import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';

enum WarningLevel { low, out, negative }

class WarningBadge extends StatelessWidget {
  final WarningLevel level;

  const WarningBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final (color, icon, text) = switch (level) {
      WarningLevel.negative => (
      AppColors.error,
      Icons.error_outline,
      'Negative',
      ),
      WarningLevel.out => (
      AppColors.error,
      Icons.remove_circle_outline,
      'Out of stock',
      ),
      WarningLevel.low => (
      AppColors.warning,
      Icons.warning_amber_rounded,
      'Low stock',
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: text,
          child: Icon(
            icon,
            size: AppIconSize.md,
            color: color,
          ),
        )
      ],
    );
  }
}
