import 'package:flutter/material.dart';
import '../../../data/models/business_insight.dart';

class InsightTile extends StatelessWidget {
  const InsightTile({super.key, required this.insight});
  final BusinessInsight insight;

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor, iconBg) = switch (insight.severity) {
      InsightSeverity.info => (
      Icons.info_outline,
      Color(0xFF0041C8),
      Color(0xFFDCE1FF),
      ),
      InsightSeverity.warning => (
      Icons.warning_amber_rounded,
      Color(0xFF8A6200),
      Color(0xFFFFF3CD),
      ),
      InsightSeverity.alert => (
      Icons.error_outline_rounded,
      Color(0xFFBA1A1A),
      Color(0xFFFFDAD6),
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
