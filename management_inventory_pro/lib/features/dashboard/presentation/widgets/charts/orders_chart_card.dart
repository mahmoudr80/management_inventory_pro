import 'package:flutter/material.dart';

import '../common/dashboard_card.dart';
import 'chart_header.dart';
import 'chart_placeholder.dart';

class OrdersChartCard extends StatelessWidget {
  const OrdersChartCard({
    super.key,
    required this.weeklyOrders,
    required this.isLoading,
  });

  final List<double> weeklyOrders;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChartHeader(
            title: 'Orders Trend',
            trailing: _Legend(),
          ),
          const SizedBox(height: 20),
          ChartPlaceholder(
            data: weeklyOrders.isEmpty
                ? List.filled(7, 0)
                : weeklyOrders,
            type: ChartType.line,
            accentColor: const Color(0xFF505F76),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _LegendDot(color: const Color(0xFF505F76)),
        const SizedBox(width: 4),
        Text('Standard',
            style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(width: 10),
        _LegendDot(color: const Color(0xFF0041C8)),
        const SizedBox(width: 4),
        Text('Priority',
            style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) =>
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}
