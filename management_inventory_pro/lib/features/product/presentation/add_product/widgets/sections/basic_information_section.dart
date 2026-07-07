import 'package:flutter/material.dart';

import '../../../../../../core/widgets/custom_text_field.dart';
import '../category_dropdown.dart';
import '../product_section_card.dart';
import '../unit_dropdown.dart';

class BasicInformationSection extends StatelessWidget {
  const BasicInformationSection({
    super.key,
    required this.onCategoryChanged,
    required this.nameController,
    required this.skuController,
    required this.barcodeController,
    required this.onUnitChanged,
    this.onGenerateSku,
  });

  final ValueChanged<int?> onCategoryChanged;
  final ValueChanged<int?> onUnitChanged;
  final VoidCallback? onGenerateSku;
  final TextEditingController nameController;
  final TextEditingController skuController;
  final TextEditingController barcodeController;

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
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomTextField(
                label: 'SKU *',
                controller: skuController,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: onGenerateSku,
              icon: const Icon(Icons.auto_fix_high, size: 16),
              label: const Text(
                'Auto-gen',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Barcode (EAN / UPC)',
          controller: barcodeController,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CategoryDropdownWidget(
                onChanged: (id) {
                  onCategoryChanged(int.tryParse(id ?? ''));
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: UnitDropdownWidget(
                onChanged: (id) {
                  onUnitChanged(int.tryParse(id ?? ''));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
