import 'package:flutter/material.dart';

import '../../../data/models/product_model.dart';
import 'product_grid_card.dart';

/// Adaptive product grid for desktop widths.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.onDelete,
    required this.onEdit,
    this.controller,
  });

  final List<ProductModel> products;
  final ValueChanged<String> onDelete;
  final ValueChanged<String> onEdit;
  final ScrollController? controller;

  static int _columnsForWidth(double width) {
    if (width >= 1600) return 7;
    if (width >= 1300) return 6;
    if (width >= 1100) return 5;
    if (width >= 900) return 4;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _columnsForWidth(constraints.maxWidth);

        return GridView.builder(
          key: ValueKey(crossAxisCount),
          controller: controller,
          padding: const EdgeInsets.only(bottom: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: crossAxisCount==3?1.1:0.9,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductGridCard(
              key: ValueKey(product.id),
              product: product,
              onDelete: () => onDelete(product.id),
              onEdit: () => onEdit(product.id),
            );
          },
        );
      },
    );
  }
}
