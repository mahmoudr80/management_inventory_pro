import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../data/models/top_selling_product.dart';
import '../common/empty_state.dart';
import 'top_selling_row.dart';

class TopSellingTable extends StatefulWidget {
  const TopSellingTable({
    super.key,
    required this.products,
  });

  final List<TopSellingProductRef> products;

  @override
  State<TopSellingTable> createState() => _TopSellingTableState();
}

class _TopSellingTableState extends State<TopSellingTable> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const EmptyState(
        message: 'No sales data available yet.',
        icon: Icons.bar_chart_rounded,
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
                      ...widget.products.take(5).toList().asMap().entries.map(
                            (e) => TopSellingRow(product: e.value, rank: e.key + 1),
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
            child: _HeaderCell(label: 'Product', align: TextAlign.left),
          ),
          SizedBox(
            width: 100,
            child: _HeaderCell(label: 'Units Sold', align: TextAlign.right),
          ),
          SizedBox(
            width: 120,
            child: _HeaderCell(label: 'Revenue', align: TextAlign.right),
          ),
          const SizedBox(width: 16),
          const Expanded(child: _HeaderCell(label: 'Performance')),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label, this.align = TextAlign.left});
  final String label;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label.toUpperCase(),
      textAlign: align,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        letterSpacing: 0.08,
        fontWeight: FontWeight.w600,
        fontSize: 10,
      ),
    );
  }
}
