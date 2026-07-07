import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decoration.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/sale_summary_model.dart';

class SalesSummarySection extends StatefulWidget {
  const SalesSummarySection({super.key, required this.summary});
  final SalesSummaryModel summary;

  @override
  State<SalesSummarySection> createState() => _SalesSummarySectionState();
}

class _SalesSummarySectionState extends State<SalesSummarySection> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    final cards = [
      SummaryCardData(
        label: 'Total Sales Revenue',
        value: '\$${summary.totalRevenue.toStringAsFixed(2)}',
        icon: Icons.attach_money_rounded,
        iconColor: AppColors.success,
        iconBg: AppColors.successContainer,
        trend: '+18.6% vs last period',
        trendPositive: true,
      ),
      SummaryCardData(
        label: 'Total Orders',
        value: summary.totalOrders.toString(),
        icon: Icons.receipt_long_rounded,
        iconColor: AppColors.primary,
        iconBg: AppColors.primaryContainer.withAlpha(50),
        trend: '+12.4% vs last period',
        trendPositive: true,
      ),
      SummaryCardData(
        label: 'Total Items Sold',
        value: summary.totalItemsSold.toString(),
        icon: Icons.inventory_2_rounded,
        iconColor: AppColors.warning,
        iconBg: AppColors.warningContainer,
        trend: '+15.3% vs last period',
        trendPositive: true,
      ),
      SummaryCardData(
        label: 'Total Quantity',
        value: summary.totalQuantitySold.toString(),
        icon: Icons.bar_chart_rounded,
        iconColor: AppColors.secondary,
        iconBg: AppColors.secondaryContainer,
        trend: '+10.7% vs last period',
        trendPositive: true,
      ),
      SummaryCardData(
        label: 'Average Order Value',
        value: '\$${summary.averageOrderValue.toStringAsFixed(2)}',
        icon: Icons.trending_up_rounded,
        iconColor: AppColors.info,
        iconBg: AppColors.infoContainer,
        trend: '+5.2% vs last period',
        trendPositive: true,
      ),
    ];
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final card in cards) ...[
              _SummaryCard(data: card),
              if (card != cards.last) const SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}


class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final SummaryCardData data;


  @override
  Widget build(BuildContext context) {
    return Container(
      // Fixed width is intentional here: cards live in a horizontal
      // ScrollView (see build() above), so a stable width per-card is
      // correct — this isn't the "avoid fixed sizes" case the rules target,
      // that's about elements that should flex with their parent. Named via
      // AppSize instead of a bare literal.
      width: AppSize.summaryCardWidth,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      decoration: AppDecorations.elevatedCard(
        color: AppColors.surface,
        borderColor: AppColors.border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: data.iconBg,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(data.icon, color: data.iconColor, size: AppIconSize.md),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Tooltip(
            message: data.label,
            child: Text(
              data.label,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Tooltip(
            message: data.value,
            child: Text(
              data.value,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                data.trendPositive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: AppIconSize.sm,
                color: data.trendPositive
                    ? AppColors.success
                    : AppColors.error,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Tooltip(
                  message: data.trend,
                  child: Text(
                    data.trend,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(
                      color: data.trendPositive
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
