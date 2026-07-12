import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import 'report_empty_state.dart';
import 'report_loading_state.dart';

/// Wraps whatever chart widget a report supplies (fl_chart, a custom
/// painter, ...) with the title bar + loading/empty handling every chart
/// area needs, so individual reports (Revenue Trend, Value by Category,
/// Stock Movement area chart, ...) don't reimplement that shell.
class ReportChartCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;
  final bool isLoading;
  final bool isEmpty;
  final double height;

  const ReportChartCard({
    super.key,
    required this.title,
    this.trailing,
    required this.child,
    this.isLoading = false,
    this.isEmpty = false,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.headlineSm.copyWith(color: context.colors.textPrimary)),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: height,
            child: isLoading
                ? const ReportLoadingState()
                : isEmpty
                    ? const ReportEmptyState(message: 'No data for this period.')
                    : child,
          ),
        ],
      ),
    );
  }
}
