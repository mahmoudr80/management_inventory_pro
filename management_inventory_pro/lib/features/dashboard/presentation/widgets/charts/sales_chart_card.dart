import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme_extension.dart';
import '../common/dashboard_card.dart';
import 'chart_header.dart';
import 'chart_placeholder.dart';

class SalesChartCard extends StatelessWidget {
  const SalesChartCard({
    super.key,
    required this.weeklyRevenue,
    required this.isLoading,
  });

  final List<double> weeklyRevenue;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChartHeader(
            title: 'Sales Revenue',
            trailing: _PeriodBadge(),
          ),
          const SizedBox(height: 20),
          ChartPlaceholder(
            data: weeklyRevenue.isEmpty
                ? List.filled(7, 0)
                : weeklyRevenue,
            type: ChartType.bar,
            accentColor: context.colors.primary,
          ),
        ],
      ),
    );
  }
}

class _PeriodBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Last 7 Days',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down_rounded,
              size: 14, color: theme.colorScheme.outline),
        ],
      ),
    );
  }
}