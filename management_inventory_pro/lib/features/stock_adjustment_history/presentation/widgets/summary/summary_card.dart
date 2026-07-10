import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_dimens.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.trendPct,
    this.valueColor,
    required this.caption,
  });

  final String label;
  final String value;
  final String? unit;
  final double? trendPct;
  final Color? valueColor;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final isPositiveTrend = (trendPct ?? 0) >= 0;
    final trendColor = isPositiveTrend ? context.colors.success : context.colors.error;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        border: Border.all(color: context.colors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTextStyles.labelCaps),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Tooltip(
                  message: value,
                  child: Text(
                    value,
                    style: AppTextStyles.display.copyWith(
                      color: valueColor ?? context.colors.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  unit!,
                  style: AppTextStyles.bodySm.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
              if (trendPct != null) ...[
                const SizedBox(width: AppSpacing.xxs),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${isPositiveTrend ? '+' : ''}${trendPct!.toStringAsFixed(0)}%',
                      style: AppTextStyles.labelCaps.copyWith(
                        color: trendColor,
                        letterSpacing: 0,
                      ),
                    ),
                    Icon(
                      isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                      size: AppIconSize.sm,
                      color: trendColor,
                    ),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            caption,
            style: AppTextStyles.bodySm.copyWith(
              color: context.colors.onSurfaceVariant.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}