import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// Data for a single metric card (Total Revenue, Orders, ...). Kept
/// separate from any report's domain model so [ReportSummaryCards] stays
/// generic — each report maps its own summary object into a list of
/// these.
class ReportSummaryCardData {
  final String label;
  final String value;
  final String? delta;
  final bool? deltaPositive;
  final IconData? icon;
  final Color? valueColor;

  const ReportSummaryCardData({
    required this.label,
    required this.value,
    this.delta,
    this.deltaPositive,
    this.icon,
    this.valueColor,
  });
}

class ReportSummaryCards extends StatelessWidget {
  final List<ReportSummaryCardData> cards;

  const ReportSummaryCards({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _columnsFor(constraints.maxWidth);
        const spacing = AppSpacing.md;
        final cardWidth = (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final data in cards) SizedBox(width: cardWidth, child: _SummaryCard(data: data)),
          ],
        );
      },
    );
  }

  /// Mirrors the reference UI's CSS grid breakpoints
  /// (`grid-cols-1 md:grid-cols-2 lg:grid-cols-4`): one column below
  /// [AppBreakpoints.mobile], two up to [AppBreakpoints.medium], four
  /// above it. This replaces a `Wrap` where each card only declared a
  /// `minWidth` and let the flow layout fit as many as would satisfy
  /// it per row — on any width where that minimum didn't divide evenly
  /// into the available space, it silently dropped to one card per row
  /// well before the window was actually narrow. Fixed column counts
  /// remove that dependency: cards size to the column, not the other
  /// way around, so the row only ever breaks at the real breakpoints.
  int _columnsFor(double width) {
    if (width < AppBreakpoints.compact) return 1;
    if (width < AppBreakpoints.medium) return 2;
    return 4;
  }
}

class _SummaryCard extends StatelessWidget {
  final ReportSummaryCardData data;

  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final deltaColor = data.deltaPositive == null
        ? context.colors.textSecondary
        : (data.deltaPositive! ? context.colors.success : context.colors.error);
    final iconTint = data.valueColor ?? context.colors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data.label.toUpperCase(),
                  style: AppTextStyles.labelCaps.copyWith(color: context.colors.textSecondary),
                ),
              ),
              if (data.icon != null)
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: iconTint.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(data.icon, size: AppIconSize.sm, color: iconTint),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.value,
                style: AppTextStyles.display.copyWith(
                  fontSize: 24,
                  color: data.valueColor ?? context.colors.textPrimary,
                ),
              ),
              if (data.delta != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                  child: Text(
                    data.delta!,
                    style: AppTextStyles.bodySm.copyWith(color: deltaColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
