import 'package:flutter/material.dart';
import '../../../../core/widgets/product_selector.dart';
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


  @override
  Widget build(BuildContext context) {

    return ProductSelector(
      selected: selected,
      onChanged: onChanged,
    );
  }
}
