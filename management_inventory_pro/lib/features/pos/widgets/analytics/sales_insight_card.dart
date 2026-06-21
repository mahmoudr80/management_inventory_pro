import 'package:flutter/material.dart';
import 'package:management_inventory_pro/features/pos/widgets/analytics/sales_action_button.dart';
import 'package:management_inventory_pro/features/pos/widgets/analytics/sales_actions_row.dart';
import 'package:management_inventory_pro/features/pos/widgets/analytics/sales_insight_header.dart';
import 'package:management_inventory_pro/features/pos/widgets/analytics/sales_stat_block.dart';
import '../../models/top_selling_product.dart';
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
      borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                SalesInsightHeader(),
                const SizedBox(height: 18),
                // Stats row
                SalesStatBlock(totalUnitsSoldToday: widget.totalUnitsSoldToday,
                  totalSalesToday: widget.totalSalesToday,),
                const SizedBox(height: 10),
                SalesTrendBadge(percent: widget.trendPercent, light: true),
                const SizedBox(height: 18),
                const Text(
                  'TOP 3 PRODUCTS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    for (int i = 0; i < widget.topProducts.length; i++) ...[
                      TopSellingProductTile(
                        product: widget.topProducts[i],
                        rank: i + 1,
                        maxUnits: maxUnits,
                      ),
                      if (i != widget.topProducts.length - 1) const SizedBox(height: 8),
                    ],
                  ],
                ),
                const SizedBox(height: 18),
                SalesActionsRow(onViewAnalytics: widget.onViewAnalytics,onViewBestSellers: widget.onViewBestSellers,)

              ],
            ),
          ),
        ],
      ),
    );
  }
}



