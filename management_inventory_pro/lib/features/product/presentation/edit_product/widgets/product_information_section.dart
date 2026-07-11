import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/widgets/custom_text_field.dart';
import 'package:management_inventory_pro/features/category/data/models/category_model.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/product_section_card.dart';
import 'package:management_inventory_pro/features/unit/data/models/unit_model.dart';

import 'category_select_dropdown.dart';
import 'unit_select_dropdown.dart';

/// Basic information section for Edit Product: name, SKU, barcode,
/// category, unit.
///
/// Structurally mirrors Add Product's BasicInformationSection (same
/// ProductSectionCard shell, same field set) minus the "Auto-gen SKU"
/// action, which only makes sense when creating a brand-new product.
class ProductInformationSection extends StatelessWidget {
  const ProductInformationSection({
    super.key,
    required this.nameController,
    required this.skuController,
    required this.barcodeController,
    required this.categories,
    required this.units,
    required this.selectedCategoryId,
    required this.selectedUnitId,
    required this.onCategoryChanged,
    required this.onUnitChanged,
  });

  final TextEditingController nameController;
  final TextEditingController skuController;
  final TextEditingController barcodeController;
  final List<CategoryModel> categories;
  final List<UnitModel> units;
  final int? selectedCategoryId;
  final int? selectedUnitId;
  final ValueChanged<int?> onCategoryChanged;
  final ValueChanged<int?> onUnitChanged;

  @override
  Widget build(BuildContext context) {
    return ProductSectionCard(
      icon: Icons.info_outline_rounded,
      title: 'Basic information',
      children: [
        CustomTextField(
          label: 'Product name *',
          controller: nameController,
          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'SKU',
          controller: skuController,
          helperText: 'Must stay unique across products',
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Barcode (EAN / UPC)',
          controller: barcodeController,
          helperText: 'Must stay unique across products',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CategorySelectDropdown(
                categories: categories,
                selectedId: selectedCategoryId,
                onChanged: onCategoryChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: UnitSelectDropdown(
                units: units,
                selectedId: selectedUnitId,
                onChanged: onUnitChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
