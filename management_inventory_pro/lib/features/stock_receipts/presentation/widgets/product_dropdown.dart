import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/product/presentation/products/cubit/product_cubit.dart';

import '../../../../core/widgets/search_select_dropdown.dart';
import '../../data/models/product_ref.dart';

/// Search-and-select dropdown for products — same pattern as
/// SupplierDropdown, just pointed at ProductRef.
///
/// Falls back to mock data when no real product list is injected, so it
/// can be dropped into a screen and tried out before a catalog API exists.
class ProductDropdown extends StatelessWidget {
  final ProductRef? selected;
  final List<ProductRef>? products;
  final ValueChanged<ProductRef?> onChanged;

  const ProductDropdown({
    super.key,
    required this.onChanged,
    this.selected,
    this.products,
  });

  // Mock data used until a real product catalog is wired in.
  static const _stubs = [
    ProductRef(id: 'prod-1', name: 'Wireless Mouse', sku: 'WM-2031'),
    ProductRef(id: 'prod-2', name: 'Mechanical Keyboard', sku: 'MK-1147'),
    ProductRef(id: 'prod-3', name: 'USB-C Hub', sku: 'UCH-0892'),
    ProductRef(id: 'prod-4', name: '27" Monitor', sku: 'MON-2756'),
    ProductRef(id: 'prod-5', name: 'Laptop Stand', sku: 'LS-0341'),
    ProductRef(id: 'prod-6', name: 'Webcam 1080p', sku: 'WC-1080'),
  ];

  @override
  Widget build(BuildContext context) {
    final items = products?.isNotEmpty == true ? products! : _stubs;

    return BlocBuilder<ProductCubit,ProductState>(
      builder: (context, state) {
        if(state is ProductSuccess){
          return SearchSelectDropdown<ProductRef>(
            selected: selected,
            items: state.allProducts.map((e) => ProductRef.fromProductModel(e),).toList(),
            onChanged: onChanged,
            labelBuilder: (p) => p.name,
            // Lets typing a SKU find the product even though the SKU isn't
            // part of the visible label.
            searchTextBuilder: (p) => '${p.name} ${p.sku ?? ''}',
            itemIcon: Icons.inventory_2_outlined,
            placeholder: 'select product',
            searchHint: 'Search products or SKU…',
            emptyText: 'No products found.',
          );
        }
        return SearchSelectDropdown<ProductRef>(
          selected: selected,
          items: items,
          onChanged: onChanged,
          labelBuilder: (p) => p.name,
          // Lets typing a SKU find the product even though the SKU isn't
          // part of the visible label.
          searchTextBuilder: (p) => '${p.name} ${p.sku ?? ''}',
          itemIcon: Icons.inventory_2_outlined,
          placeholder: 'select product',
          searchHint: 'Search products or SKU…',
          emptyText: 'No products found.',
        );

      },
    );
  }
}
