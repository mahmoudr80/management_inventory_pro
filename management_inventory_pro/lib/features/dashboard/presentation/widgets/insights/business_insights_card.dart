import 'package:flutter/material.dart';
import '../../../data/models/business_insight.dart';
import '../common/dashboard_card.dart';
import '../common/empty_state.dart';
import '../common/section_header.dart';
import 'insight_tile.dart';

class BusinessInsightsCard extends StatelessWidget {
  const BusinessInsightsCard({
    super.key,
    required this.insights,
    required this.onGenerateReport,
  });

  final List<BusinessInsight> insights;
  final VoidCallback onGenerateReport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Business Insights'),
          const SizedBox(height: 16),
          if (insights.isEmpty)
            const EmptyState(
              message: 'No insights available.',
              icon: Icons.lightbulb_outline_rounded,
            )
          else
            ...insights.map((i) => InsightTile(insight: i)),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onGenerateReport,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
                side: BorderSide(color: theme.colorScheme.outlineVariant),
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Generate Full Report'),
            ),
          ),
        ],
      ),
    );
  }
}
