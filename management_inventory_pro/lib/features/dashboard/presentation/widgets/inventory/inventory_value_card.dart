import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final egp = NumberFormat('#,###', 'en_US');
    final change = summary.inventoryTurnoverChange;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF283044), // inverse-surface
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL INVENTORY VALUE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFFB6C4FF),
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
    return Row(
      children: [
        const Icon(Icons.trending_up_rounded, size: 16, color: Color(0xFF82E0AA)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Stock turnover increased by ${change.toStringAsFixed(1)}% this month.',
            style: const TextStyle(
              color: Color(0xFFB6C4FF),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
