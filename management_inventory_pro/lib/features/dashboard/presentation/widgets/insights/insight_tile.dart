import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme_extension.dart';
import '../../theme/dashboard_theme_extension.dart';
import '../../../data/models/business_insight.dart';

class InsightTile extends StatelessWidget {
  const InsightTile({super.key, required this.insight});
  final BusinessInsight insight;

  @override
  Widget build(BuildContext context) {
    final coreColors = context.colors;
    final dashColors = context.dashboardColors;
    final (icon, iconColor, iconBg) = switch (insight.severity) {
      InsightSeverity.info => (
      Icons.info_outline,
      coreColors.primary,
      dashColors.primaryContainer,
      ),
      InsightSeverity.warning => (
      Icons.warning_amber_rounded,
      dashColors.onWarningContainer,
      dashColors.warningContainer,
      ),
      InsightSeverity.alert => (
      Icons.error_outline_rounded,
      coreColors.error,
      dashColors.errorContainer,
      ),
    };
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  insight.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}