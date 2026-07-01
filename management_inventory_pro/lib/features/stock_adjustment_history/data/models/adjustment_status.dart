import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Lifecycle status of a stock adjustment.
enum AdjustmentStatus {
  completed,
  draft,
  cancelled;

  String get label {
    switch (this) {
      case AdjustmentStatus.completed:
        return 'Completed';
      case AdjustmentStatus.draft:
        return 'Draft';
      case AdjustmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get background {
    switch (this) {
      case AdjustmentStatus.completed:
        return AppColors.successContainer;
      case AdjustmentStatus.draft:
        return AppColors.warningContainer;
      case AdjustmentStatus.cancelled:
        return AppColors.neutralContainer;
    }
  }

  Color get foreground {
    switch (this) {
      case AdjustmentStatus.completed:
        return AppColors.onSuccessContainer;
      case AdjustmentStatus.draft:
        return AppColors.onWarningContainer;
      case AdjustmentStatus.cancelled:
        return AppColors.onNeutralContainer;
    }
  }
}
