import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_summary_model.dart';

class AdjustmentSummaryCard extends StatelessWidget {
  const AdjustmentSummaryCard({super.key, required this.summary});

  final AdjustmentSummaryModel summary;

  static final _currencyFormat = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    final isNegativeDelta = summary.inventoryValueDelta < 0;
    final deltaColor = summary.inventoryValueDelta == 0
        ? context.colors.onSurface
        : (isNegativeDelta ? context.colors.error : context.colors.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ADJUSTMENT SUMMARY', style: AppTextStyles.labelCaps),
        SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.xxs),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLow,
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
                valueColor: context.colors.primary,
              ),
              SizedBox(height: AppSpacing.md),
              _SummaryLine(
                label: 'Total Decrease',
                value: '${summary.totalDecrease} Units',
                valueColor: context.colors.error,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Divider(height: AppBorder.thin, color: context.colors.outlineVariant),
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
                color: bold ? context.colors.onSurface : context.colors.onSurfaceVariant,
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
                color: valueColor ?? context.colors.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}