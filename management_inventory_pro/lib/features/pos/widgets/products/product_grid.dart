import 'package:flutter/material.dart';
import '../../models/pos_product.dart';
import 'product_card.dart';
import '../analytics/sales_insight_card.dart';

class ProductGrid extends StatelessWidget {
  final List<PosProduct> products;
  final String? selectedId;
  final void Function(PosProduct) onProductTap;
  final VoidCallback? onViewAnalytics;
  final VoidCallback? onViewBestSellers;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    this.selectedId,
    this.onViewAnalytics,
    this.onViewBestSellers,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Text(
            'No products found',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Split products: first row of 4, then bento tile + remaining grid.
    final topRow = products.take(4).toList();
    final rest = products.skip(4).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductRow(products: topRow, onTap: onProductTap, selectedId: selectedId),
          const SizedBox(height: 16),
          SizedBox(
            height: 600,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 560),
                    child: SalesInsightCard(
                      onViewAnalytics: onViewAnalytics,
                      onViewBestSellers: onViewBestSellers,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: _ProductWrapGrid(
                    products: rest,
                    columns: 3,
                    onTap: onProductTap,
                    selectedId: selectedId,
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

class _ProductRow extends StatelessWidget {
  final List<PosProduct> products;
  final void Function(PosProduct) onTap;
  final String? selectedId;

  const _ProductRow({
    required this.products,
    required this.onTap,
    this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < products.length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          Expanded(
            child: ProductCard(
              product: products[i],
              selected: products[i].id == selectedId,
              onTap: () => onTap(products[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProductWrapGrid extends StatelessWidget {
  final List<PosProduct> products;
  final int columns;
  final void Function(PosProduct) onTap;
  final String? selectedId;

  const _ProductWrapGrid({
    required this.products,
    required this.columns,
    required this.onTap,
    this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 16.0;
        final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final p in products)
              SizedBox(
                width: cardWidth,
                child: ProductCard(
                  product: p,
                  selected: p.id == selectedId,
                  onTap: () => onTap(p),
                ),
              ),
          ],
        );
      },
    );
  }
}
