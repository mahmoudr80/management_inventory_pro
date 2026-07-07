import 'package:flutter/material.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/kpi/statistics_bento_card.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_summary.dart';
import 'mini_progress_bar.dart';

class StockEntryKpiRow extends StatelessWidget {
  final StockEntrySummary summary;
  final bool isLoading;

  const StockEntryKpiRow({
    super.key,
    required this.summary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _KpiRowSkeleton();

    final pendingFraction = summary.totalReceipts > 0
        ? summary.pendingReceipts / summary.totalReceipts
        : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 800;
        const double spacing = 16.0;
        final double itemWidth = isNarrow
            ? (constraints.maxWidth < 550
                ? double.infinity
                : (constraints.maxWidth - spacing) / 2)
            : (constraints.maxWidth - (spacing * 2)) / 3;

        final card1 = SizedBox(
          width: itemWidth,
          child: StatBentoCard(
            title: 'Total Receipts',
            value: _formatCount(summary.totalReceipts),
            footer: 'All stock receipts',
          ),
        );

        final card2 = SizedBox(
          width: itemWidth,
          child: StatBentoCard(
            title: 'Pending Receipts',
            value: _formatCount(summary.pendingReceipts),
            valueColor: AppColors.error,
            customFooter: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MiniProgressBar(
                  fraction: pendingFraction.toDouble(),
                  color: AppColors.error,
                ),
                const SizedBox(height: 6),
                Text(
                  'Receipts awaiting verification',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
        );

        final card3 = SizedBox(
          width: isNarrow && constraints.maxWidth >= 550 ? double.infinity : itemWidth,
          child: StatBentoCard(
            title: 'Inventory Value',
            value: _formatValue(summary.totalValue),
            footer: 'Total value of received inventory',
            decorativeIcon: Icons.local_shipping_outlined,
          ),
        );

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            card1,
            card2,
            card3,
          ],
        );
      },
    );
  }

  String _formatCount(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}k';
    }
    return n.toString();
  }

  String _formatValue(double v) {
    if (v >= 1000000) {
      return '\$${(v / 1000000).toStringAsFixed(1)}M';
    }
    if (v >= 1000) {
      return '\$${(v / 1000).toStringAsFixed(1)}k';
    }
    return '\$${v.toStringAsFixed(0)}';
  }
}

// ── Skeleton placeholder while data loads ────────────────────────────────────

class _KpiRowSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 800;
        const double spacing = 16.0;
        final double itemWidth = isNarrow
            ? (constraints.maxWidth < 550
                ? double.infinity
                : (constraints.maxWidth - spacing) / 2)
            : (constraints.maxWidth - (spacing * 2)) / 3;

        final skeletonCard = Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Bone(width: 120, height: 10),
              const SizedBox(height: 12),
              const _Bone(width: 72, height: 28),
              const SizedBox(height: 16),
              const _Bone(width: 100, height: 10),
            ],
          ),
        );

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(width: itemWidth, child: skeletonCard),
            SizedBox(width: itemWidth, child: skeletonCard),
            SizedBox(
              width: isNarrow && constraints.maxWidth >= 550 ? double.infinity : itemWidth,
              child: skeletonCard,
            ),
          ],
        );
      },
    );
  }
}

class _Bone extends StatelessWidget {
  final double width;
  final double height;

  const _Bone({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
