import 'package:flutter/material.dart';

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
    if (isLoading) return const LoadingCard(height: 200);

    final theme = Theme.of(context);
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
              leadingIconColor: const Color(0xFFBA1A1A),
              trailing: products.isEmpty
                  ? null
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDAD6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${products.length} ACTION ITEMS',
                        style: const TextStyle(
                          color: Color(0xFFBA1A1A),
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
