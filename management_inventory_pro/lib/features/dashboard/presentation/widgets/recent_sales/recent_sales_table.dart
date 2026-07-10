import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../data/models/recent_sale.dart';
import '../common/empty_state.dart';
import 'recent_sale_row.dart';

class RecentSalesTable extends StatefulWidget {
  const RecentSalesTable({
    super.key,
    required this.sales,
    required this.onSelectSale,
  });

  final List<RecentSaleRef> sales;
  final void Function(RecentSaleRef) onSelectSale;

  @override
  State<RecentSalesTable> createState() => _RecentSalesTableState();
}

class _RecentSalesTableState extends State<RecentSalesTable> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sales.isEmpty) {
      return const EmptyState(
        message: 'No recent sales.',
        icon: Icons.receipt_long_outlined,
      );
    }

    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final double minTableWidth = 550.0;
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Scrollbar(
            controller: _horizontalController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                ),
                child: SizedBox(
                  width: math.max(minTableWidth, constraints.maxWidth),
                  child: Column(
                    children: [
                      _TableHeader(theme: theme),
                      ...widget.sales.take(8).map(
                            (s) => RecentSaleRow(sale: s, onTap: () => widget.onSelectSale(s)),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
              child: Tooltip(
                message: 'SALE ID',
                child: Text(
                    overflow: TextOverflow.ellipsis,
                    'SALE ID', style: style.copyWith(color: color)),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Tooltip(
                message: 'DATE',
                child: Text(
                    overflow: TextOverflow.ellipsis,
                    'DATE', style: style.copyWith(color: color)),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Tooltip(
              message: 'CASHIER',
              child: Text(
                  overflow: TextOverflow.ellipsis,
                  'CASHIER', style: style.copyWith(color: color)),
            ),
          )),
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Tooltip(
                message: 'AMOUNT',
                child: Text(
                    overflow: TextOverflow.ellipsis,
                    'AMOUNT',
                    textAlign: TextAlign.right,
                    style: style.copyWith(color: color)),
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Tooltip(
                message: 'STATUS',
                child: Text(
                    overflow: TextOverflow.ellipsis,
                    'STATUS',
                    textAlign: TextAlign.center,
                    style: style.copyWith(color: color)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
