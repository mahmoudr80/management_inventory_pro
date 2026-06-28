import 'package:flutter/material.dart';
import '../../../data/models/recent_sale.dart';
import '../common/dashboard_card.dart';
import '../common/loading_card.dart';
import '../common/section_header.dart';
import 'recent_sales_table.dart';

class RecentSalesSection extends StatelessWidget {
  const RecentSalesSection({
    super.key,
    required this.sales,
    required this.isLoading,
    required this.onSelectSale,
  });

  final List<RecentSaleRef> sales;
  final bool isLoading;
  final void Function(RecentSaleRef) onSelectSale;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const LoadingCard(height: 300);

    return DashboardCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SectionHeader(
              title: 'Recent Sales',
              trailing: IconButton(
                icon: const Icon(Icons.more_horiz, size: 18),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          RecentSalesTable(sales: sales, onSelectSale: onSelectSale),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
