import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/widgets/search_select_dropdown.dart';
import '../../features/stock_receipts/data/models/product_ref.dart';

class ProductDropdown extends StatelessWidget {
  final ProductRef? selected;
  final List<ProductRef> products;
  final ValueChanged<ProductRef?> onChanged;

  const ProductDropdown({
    super.key,
    required this.products,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return  SearchSelectDropdown<ProductRef>(
      selected: selected,
      items: products,
      onChanged: onChanged,
      labelBuilder: (p) => p.name,
      searchTextBuilder: (p) => '${p.name} ${p.sku ?? ''}',
      subtitleBuilder: (p) => p.sku ?? '',
      itemIcon: Icons.inventory_2_outlined,
      placeholder: 'Select product',
      searchHint: 'Search products or SKU...',
      emptyText: 'No products found.',
    );
  }
}