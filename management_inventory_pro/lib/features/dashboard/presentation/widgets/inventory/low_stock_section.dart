import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme_extension.dart';
import '../../theme/dashboard_theme_extension.dart';
import '../../../data/models/low_stock_product.dart';
import '../common/dashboard_card.dart';
import '../common/loading_card.dart';
import '../common/section_header.dart';
import 'low_stock_table.dart';

class LowStockSection extends StatelessWidget {
  const LowStockSection({
    super.key,
    required this.products,
    required this.isLoading,
    required this.onRestock,
  });

  final List<LowStockProductRef> products;
  final bool isLoading;
  final void Function(LowStockProductRef) onRestock;

  @override
  Widget build(BuildContext context) {
    if (isLoading && products.isEmpty) return const LoadingCard(height: 200);

    final coreColors = context.colors;
    final dashColors = context.dashboardColors;

    return DashboardCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: SectionHeader(
              title: 'Low Stock Alerts',
              leadingIcon: Icons.notifications_active_outlined,
              leadingIconColor: coreColors.error,
              trailing: products.isEmpty
                  ? null
                  : Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: dashColors.errorContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${products.length} ACTION ITEMS',
                  style: TextStyle(
                    color: coreColors.error,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.08,
                  ),
                ),
              ),
            ),
          ),
          LowStockTable(products: products, onRestock: onRestock),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}