import 'package:flutter/material.dart';
import 'package:management_inventory_pro/features/pos/presentation/widgets/analytics/sales_actions_row.dart';
import 'package:management_inventory_pro/features/pos/presentation/widgets/analytics/sales_insight_header.dart';
import 'package:management_inventory_pro/features/pos/presentation/widgets/analytics/sales_stat_block.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/top_selling_product.dart';
import 'sales_trend_badge.dart';
import 'top_selling_product_tile.dart';

class SalesInsightCard extends StatefulWidget {
  final int totalUnitsSoldToday;
  final double totalSalesToday;
  final double trendPercent;
  final List<TopSellingProduct> topProducts;
  final VoidCallback? onViewAnalytics;
  final VoidCallback? onViewBestSellers;

  const SalesInsightCard({
    super.key,
    this.totalUnitsSoldToday = 1284,
    this.totalSalesToday = 9842.50,
    this.trendPercent = 12,
    this.topProducts = const [
      TopSellingProduct(name: 'Coca-Cola 330ml', soldUnits: 248),
      TopSellingProduct(name: 'Lays Chips', soldUnits: 194),
      TopSellingProduct(name: 'Mineral Water', soldUnits: 162),
    ],
    this.onViewAnalytics,
    this.onViewBestSellers,
  });

  @override
  State<SalesInsightCard> createState() => _SalesInsightCardState();
}

class _SalesInsightCardState extends State<SalesInsightCard> {
  @override
  Widget build(BuildContext context) {
    final maxUnits = widget.topProducts.isEmpty
        ? 0
        : widget.topProducts.map((p) => p.soldUnits).reduce((a, b) => a > b ? a : b);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F1B3D), Color(0xFF0041C8)],
              ),
            ),
          ),
          Positioned(
            right: -26,
            top: -26,
            child: Icon(
              Icons.insights_rounded,
              size: 150,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.cardPadding,horizontal:
            AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                SalesInsightHeader(),
                const SizedBox(height: AppSpacing.md),
                // Stats row
                SalesStatBlock(totalUnitsSoldToday: widget.totalUnitsSoldToday,
                  totalSalesToday: widget.totalSalesToday,),
                const SizedBox(height: AppSpacing.md),
                SalesTrendBadge(percent: widget.trendPercent, light: true),
                const SizedBox(height: AppSpacing.md),
                Tooltip(message:  'TOP 3 PRODUCTS',
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    'TOP 3 PRODUCTS',
                    style: AppTextStyles.labelCaps.copyWith(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Column(
                  children: [
                    for (int i = 0; i < widget.topProducts.length; i++) ...[
                      TopSellingProductTile(
                        product: widget.topProducts[i],
                        rank: i + 1,
                        maxUnits: maxUnits,
                      ),
                      if (i != widget.topProducts.length - 1) const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SalesActionsRow(onViewAnalytics: widget.onViewAnalytics,onViewBestSellers: widget.onViewBestSellers,)

              ],
            ),
          ),
        ],
      ),
    );
  }
}



