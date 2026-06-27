import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Row(
      children: List.generate(
        4,
        (i) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 3 ? 12 : 0),
            child: const LoadingCard(height: 132),
          ),
        ),
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final egp = NumberFormat('#,###', 'en_US');
    final changePercent = summary.revenueChangePercent;
    final isPositiveChange = changePercent >= 0;
    final changeLabel =
        '${isPositiveChange ? '+' : ''}${changePercent.toStringAsFixed(0)}%';

    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            label: "Today's Revenue",
            value: '${egp.format(summary.todayRevenue)} EGP',
            icon: Icons.payments_outlined,
            iconColor: const Color(0xFF0041C8),
            iconBackground: const Color(0xFFDCE1FF),
            subtitle:
                '${isPositiveChange ? '▲' : '▼'} $changeLabel vs ${egp.format(summary.yesterdayRevenue)} EGP yesterday',
            subtitleColor: isPositiveChange
                ? const Color(0xFF1B6E3C)
                : const Color(0xFFBA1A1A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            label: "Today's Orders",
            value: '${summary.todayOrders} Orders',
            icon: Icons.receipt_long_outlined,
            iconColor: const Color(0xFF1B6E3C),
            iconBackground: const Color(0xFFD6F4E3),
            subtitle:
                'Avg. order value: ${egp.format(summary.avgOrderValue)} EGP',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            label: 'Total Products',
            value: '${egp.format(summary.totalProducts)} Products',
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFF505F76),
            iconBackground: const Color(0xFFD0E1FB),
            subtitle:
                'Active SKUs across ${summary.activeCategories} categories',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            label: 'Low Stock Products',
            value: '${summary.lowStockCount} Products',
            icon: Icons.warning_amber_rounded,
            iconColor: const Color(0xFFBA1A1A),
            iconBackground: const Color(0xFFFFDAD6),
            subtitle: 'Immediate action required',
            valueColor: const Color(0xFFBA1A1A),
            subtitleColor: const Color(0xFFBA1A1A),
          ),
        ),
      ],
    );
  }
}
