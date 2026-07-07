import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_status.dart';

/// Pill badge rendering an [AdjustmentStatus]'s label in its theme color.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.dense = false});

  final AdjustmentStatus status;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.labelCaps.copyWith(color: status.foreground);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? AppSpacing.xxs : AppSpacing.xs,
        vertical: dense ? AppSpacing.xxs : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Tooltip(
        message: status.label.toUpperCase(),
        child: Text(
          overflow: TextOverflow.ellipsis,
          status.label.toUpperCase(),
          // Dense chips (used inline in table rows) step down relative to
          // the base labelCaps size instead of a hardcoded literal, so this
          // still tracks AppTextStyles if that scale ever changes.
          style: dense
              ? baseStyle.copyWith(fontSize: baseStyle.fontSize! - 1)
              : baseStyle,
        ),
      ),
    );
  }
}
