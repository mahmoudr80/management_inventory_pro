import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_status.dart';

class StatusPill extends StatelessWidget {
  final StockEntryStatus status;

  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border, dot, label) = _resolve(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySm.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, Color, Color, String) _resolve(StockEntryStatus s) {
    switch (s) {
      case StockEntryStatus.verified:
        return (
        AppColors.statusHealthyBg,
        AppColors.statusHealthyFg,
        AppColors.statusHealthyBorder,
        AppColors.statusHealthyDot,
        'Verified',
        );
      case StockEntryStatus.pending:
        return (
        AppColors.statusPendingBg,
        AppColors.statusPendingFg,
        AppColors.statusPendingBorder,
        AppColors.statusPendingDot,
        'Pending',
        );
      case StockEntryStatus.cancelled:
        return (
        AppColors.statusCancelledBg,
        AppColors.statusCancelledFg,
        AppColors.statusCancelledBorder,
        AppColors.statusCancelledDot,
        'Cancelled',
        );
    }
  }
}
