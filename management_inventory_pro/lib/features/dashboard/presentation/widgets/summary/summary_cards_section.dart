import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_theme_extension.dart';
import '../../theme/dashboard_theme_extension.dart';
import '../../../data/models/dashboard_summary.dart';
import '../common/loading_card.dart';
import 'summary_card.dart';

class SummaryCardsSection extends StatelessWidget {
  const SummaryCardsSection({
    super.key,
    required this.summary,
    required this.isLoading,
  });

  final DashboardSummary? summary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading || summary == null) {
      return const _SummarySkeletons();
    }
    return _SummaryCards(summary: summary!);
  }
}

class _SummarySkeletons extends StatelessWidget {
  const _SummarySkeletons();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = width < 650 ? 1 : (width < 1100 ? 2 : 4);
        const double spacing = 12.0;
        final double cardWidth = (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(
            4,
                (i) => SizedBox(
              width: cardWidth,
              child: const LoadingCard(height: 132),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final coreColors = context.colors;
    final dashColors = context.dashboardColors;
    final egp = NumberFormat('#,###', 'en_US');
    final changePercent = summary.revenueChangePercent;
    final isPositiveChange = changePercent >= 0;
    final changeLabel =
        '${isPositiveChange ? '+' : ''}${changePercent.toStringAsFixed(0)}%';

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = width < 650 ? 1 : (width < 1100 ? 2 : 4);
        const double spacing = 12.0;
        final double cardWidth = (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;

        final cards = [
          SummaryCard(
            label: "Today's Revenue",
            value: '${egp.format(summary.todayRevenue)} EGP',
            icon: Icons.payments_outlined,
            iconColor: coreColors.primary,
            iconBackground: dashColors.primaryContainer,
            subtitle:
            '${isPositiveChange ? '▲' : '▼'} $changeLabel vs ${egp.format(summary.yesterdayRevenue)} EGP yesterday',
            subtitleColor: isPositiveChange
                ? coreColors.success
                : coreColors.error,
          ),
          SummaryCard(
            label: "Today's Orders",
            value: '${summary.todayOrders} Orders',
            icon: Icons.receipt_long_outlined,
            iconColor: coreColors.success,
            iconBackground: dashColors.successContainer,
            subtitle:
            'Avg. order value: ${egp.format(summary.avgOrderValue)} EGP',
          ),
          SummaryCard(
            label: 'Total Products',
            value: '${egp.format(summary.totalProducts)} Products',
            icon: Icons.inventory_2_outlined,
            iconColor: coreColors.secondary,
            iconBackground: dashColors.secondaryContainer,
            subtitle:
            'Active SKUs across ${summary.activeCategories} categories',
          ),
          SummaryCard(
            label: 'Low Stock Products',
            value: '${summary.lowStockCount} Products',
            icon: Icons.warning_amber_rounded,
            iconColor: coreColors.error,
            iconBackground: dashColors.errorContainer,
            subtitle: 'Immediate action required',
            valueColor: coreColors.error,
            subtitleColor: coreColors.error,
          ),
        ];

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: cards
              .map((card) => SizedBox(
            width: cardWidth,
            child: card,
          ))
              .toList(),
        );
      },
    );
  }
}