import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Card 1: Total Receipts ────────────────────────────────────────
          Expanded(
            child: StatBentoCard(
              title: 'Total Receipts',
              value: _formatCount(summary.totalReceipts),
              footer: 'All stock receipts',
            ),
          ),
          SizedBox(width: 20),

          // ── Card 2: Pending Verification ──────────────────────────────────
          Expanded(
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
                  SizedBox(height: 6.h),
                  Text(
                    'Receipts awaiting verification',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
            )
          ),
          SizedBox(width: 20),

          // ── Card 3: Logistics Throughput ──────────────────────────────────
          Expanded(
            child: StatBentoCard(
              title: 'Inventory Value',
              value: _formatValue(summary.totalValue),
              footer: ' Total value of received inventory',
              decorativeIcon: Icons.local_shipping_outlined,
            ),
          ),
        ],
      ),
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
    return Row(
      children: List.generate(3, (i) {
        final isLast = i == 2;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 16.w),
            child: Container(
              height: 128.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bone(width: 120.w, height: 10.h),
                  SizedBox(height: 12.h),
                  _Bone(width: 72.w, height: 28.h),
                  SizedBox(height: 16.h),
                  _Bone(width: 100.w, height: 10.h),
                ],
              ),
            ),
          ),
        );
      }),
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
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
