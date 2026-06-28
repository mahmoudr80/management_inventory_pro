import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/top_selling_product.dart';

class TopSellingRow extends StatelessWidget {
  const TopSellingRow({
    super.key,
    required this.product,
    required this.rank,
  });

  final TopSellingProductRef product;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final egp = NumberFormat('#,###', 'en_US');

    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          _ProductCell(product: product, rank: rank),
          SizedBox(
            width: 100,
            child: Text(
              '${product.unitsSold}',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'JetBrains Mono',
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              '${egp.format(product.revenue)} EGP',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'JetBrains Mono',
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: _PerformanceBar(value: product.performancePercent)),
        ],
      ),
    );
  }
}

class _ProductCell extends StatelessWidget {
  const _ProductCell({required this.product, required this.rank});
  final TopSellingProductRef product;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      flex: 3,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'SKU: ${product.sku}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontFamily: 'JetBrains Mono',
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceBar extends StatelessWidget {
  const _PerformanceBar({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
