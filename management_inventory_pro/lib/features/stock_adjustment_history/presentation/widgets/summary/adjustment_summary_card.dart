import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_summary_model.dart';

/// "Adjustment Summary" card in the right panel: items adjusted, total
/// increase/decrease, and the net inventory value delta.
class AdjustmentSummaryCard extends StatelessWidget {
  const AdjustmentSummaryCard({super.key, required this.summary});

  final AdjustmentSummaryModel summary;

  static final _currencyFormat = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    final isNegativeDelta = summary.inventoryValueDelta < 0;
    final deltaColor = summary.inventoryValueDelta == 0
        ? AppColors.onSurface
        : (isNegativeDelta ? AppColors.error : AppColors.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ADJUSTMENT SUMMARY', style: AppTextStyles.labelCaps),
        SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.xxs),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Column(
            children: [
              _SummaryLine(
                label: 'Items Adjusted',
                value: '${summary.skuCount} SKUs (${summary.totalUnitsMoved} Units)',
              ),
              SizedBox(height: AppSpacing.md),
              _SummaryLine(
                label: 'Total Increase',
                value: '+${summary.totalIncrease} Units',
                valueColor: AppColors.primary,
              ),
              SizedBox(height: AppSpacing.md),
              _SummaryLine(
                label: 'Total Decrease',
                value: '${summary.totalDecrease} Units',
                valueColor: AppColors.error,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                // Not `const` — every other Divider in this codebase using
                // AppColors.* is non-const too, which means that color
                // isn't a compile-time constant. The `const` here would
                // fail to build.
                child: Divider(height: AppBorder.thin, color: AppColors.outlineVariant),
              ),
              _SummaryLine(
                label: 'Inventory Value Delta',
                value:
                '${isNegativeDelta ? '-' : ''}${_currencyFormat.format(summary.inventoryValueDelta.abs())} EGP',
                valueColor: deltaColor,
                bold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Tooltip(
            message: label,
            child: Text(
              label,
              style: AppTextStyles.bodySm.copyWith(
                color: bold ? AppColors.onSurface : AppColors.onSurfaceVariant,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Tooltip(
            message: value,
            child: Text(
              value,
              style: AppTextStyles.bodySm.copyWith(
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}