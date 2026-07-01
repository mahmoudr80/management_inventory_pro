import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Reason recorded for a stock adjustment.
enum AdjustmentReason {
  damaged,
  inventoryCount,
  correction,
  expired,
  theft,
  lost,
  sample,
  other;

  String get label {
    switch (this) {
      case AdjustmentReason.damaged:
        return 'Damaged';
      case AdjustmentReason.inventoryCount:
        return 'Inventory Count';
      case AdjustmentReason.correction:
        return 'Correction';
      case AdjustmentReason.expired:
        return 'Expired';
      case AdjustmentReason.theft:
        return 'Theft';
      case AdjustmentReason.lost:
        return 'Lost';
      case AdjustmentReason.sample:
        return 'Sample';
      case AdjustmentReason.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case AdjustmentReason.damaged:
        return Icons.report_problem_outlined;
      case AdjustmentReason.inventoryCount:
        return Icons.analytics_outlined;
      case AdjustmentReason.correction:
        return Icons.edit_note_outlined;
      case AdjustmentReason.expired:
        return Icons.history_edu_outlined;
      case AdjustmentReason.theft:
        return Icons.security_outlined;
      case AdjustmentReason.lost:
        return Icons.help_outline;
      case AdjustmentReason.sample:
        return Icons.science_outlined;
      case AdjustmentReason.other:
        return Icons.cancel_outlined;
    }
  }

  Color get color {
    switch (this) {
      case AdjustmentReason.damaged:
      case AdjustmentReason.expired:
      case AdjustmentReason.theft:
      case AdjustmentReason.lost:
        return AppColors.error;
      case AdjustmentReason.inventoryCount:
      case AdjustmentReason.sample:
        return AppColors.primary;
      case AdjustmentReason.correction:
        return AppColors.warning;
      case AdjustmentReason.other:
        return AppColors.outline;
    }
  }
}
