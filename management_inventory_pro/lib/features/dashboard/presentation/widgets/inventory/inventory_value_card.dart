import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/dashboard_theme_extension.dart';
import '../../../data/models/dashboard_summary.dart';

class InventoryValueCard extends StatelessWidget {
  const InventoryValueCard({
    super.key,
    required this.summary,
  });

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dashColors = context.dashboardColors;
    final egp = NumberFormat('#,###', 'en_US');
    final change = summary.inventoryTurnoverChange;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dashColors.inverseSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL INVENTORY VALUE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: dashColors.onInverseSurface,
              letterSpacing: 0.08,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${egp.format(summary.inventoryValue)} EGP',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          _TrendBadge(change: change),
        ],
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.change});
  final double change;

  @override
  Widget build(BuildContext context) {
    final dashColors = context.dashboardColors;
    return Row(
      children: [
        Icon(Icons.trending_up_rounded, size: 16, color: dashColors.trendPositive),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Stock turnover increased by ${change.toStringAsFixed(1)}% this month.',
            style: TextStyle(
              color: dashColors.onInverseSurface,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}