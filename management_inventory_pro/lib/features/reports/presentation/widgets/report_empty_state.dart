import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// Shared "nothing to show" placeholder for chart areas, tables, or a
/// whole workspace when a report has zero rows for the current filters.
class ReportEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final Widget? action;

  const ReportEmptyState({
    super.key,
    this.message = 'No data available.',
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: context.colors.outlineVariant),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppTextStyles.bodySm.copyWith(color: context.colors.textSecondary)),
          if (action != null) ...[const SizedBox(height: AppSpacing.md), action!],
        ],
      ),
    );
  }
}
