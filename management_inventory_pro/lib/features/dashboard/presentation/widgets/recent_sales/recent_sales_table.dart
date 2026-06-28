import 'package:flutter/material.dart';

import '../../../data/models/recent_sale.dart';
import '../common/empty_state.dart';
import 'recent_sale_row.dart';

class RecentSalesTable extends StatelessWidget {
  const RecentSalesTable({
    super.key,
    required this.sales,
    required this.onSelectSale,
  });

  final List<RecentSaleRef> sales;
  final void Function(RecentSaleRef) onSelectSale;

  @override
  Widget build(BuildContext context) {
    if (sales.isEmpty) {
      return const EmptyState(
        message: 'No recent sales.',
        icon: Icons.receipt_long_outlined,
      );
    }

    final theme = Theme.of(context);
    return Column(
      children: [
        _TableHeader(theme: theme),
        ...sales.take(8).map(
              (s) => RecentSaleRow(sale: s, onTap: () => onSelectSale(s)),
            ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.08,
    );
    final color = theme.colorScheme.onSurfaceVariant;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('SALE ID', style: style.copyWith(color: color)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('DATE', style: style.copyWith(color: color)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('CASHIER', style: style.copyWith(color: color)),
            ),
          ),
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('AMOUNT',
                  textAlign: TextAlign.right,
                  style: style.copyWith(color: color)),
            ),
          ),
          SizedBox(
            width: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('STATUS',
                  textAlign: TextAlign.center,
                  style: style.copyWith(color: color)),
            ),
          ),
        ],
      ),
    );
  }
}
