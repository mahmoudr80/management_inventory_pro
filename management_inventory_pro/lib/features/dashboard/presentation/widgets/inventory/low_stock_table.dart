import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../data/models/low_stock_product.dart';
import '../common/empty_state.dart';
import 'low_stock_row.dart';

class LowStockTable extends StatelessWidget {
  const LowStockTable({
    super.key,
    required this.products,
    required this.onRestock,
  });

  final List<LowStockProductRef> products;
  final void Function(LowStockProductRef) onRestock;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const EmptyState(
        message: 'No low stock products. Great job!',
        icon: Icons.check_circle_outline_rounded,
      );
    }

    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final double minTableWidth = 650.0;
        return Scrollbar(
          child: SingleChildScrollView(
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
                    ...products.map(
                      (p) => LowStockRow(product: p, onRestock: () => onRestock(p)),
                    ),
                  ],
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
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _H(label: 'Product', px: 20, align: TextAlign.left),
          ),
          SizedBox(width: 100, child: _H(label: 'Current', align: TextAlign.center)),
          SizedBox(width: 100, child: _H(label: 'Minimum', align: TextAlign.center)),
          const SizedBox(width: 20 + 80 + 20), // status chip space
          const SizedBox(width: 100), // action space
        ],
      ),
    );
  }
}

class _H extends StatelessWidget {
  const _H({required this.label, this.px = 0, this.align = TextAlign.left});
  final String label;
  final double px;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: px),
      child: Text(
        label.toUpperCase(),
        textAlign: align,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.08,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
