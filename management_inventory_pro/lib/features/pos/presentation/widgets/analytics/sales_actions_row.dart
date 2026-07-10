import 'package:flutter/material.dart';
import 'package:management_inventory_pro/features/pos/presentation/widgets/analytics/sales_action_button.dart';

class SalesActionsRow extends StatelessWidget {
  const SalesActionsRow({super.key, this.onViewAnalytics, this.onViewBestSellers});
  final VoidCallback? onViewAnalytics;
  final VoidCallback? onViewBestSellers;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SalesActionButton(
          label: 'View Analytics',
          icon: Icons.query_stats_rounded,
          filled: true,
          onTap: onViewAnalytics,
        ),
        SalesActionButton(
          label: 'Best Sellers',
          icon: Icons.star_outline_rounded,
          filled: false,
          onTap: onViewBestSellers,
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
