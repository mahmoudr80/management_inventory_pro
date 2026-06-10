import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/custom_text_field.dart';
import '../category_drop_down.dart';
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
        SizedBox(height: 12.h),
        CustomTextField(
          label: 'Barcode (EAN / UPC)',
          controller: barcodeController,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CategoryDropdownWidget(
                onChanged: (id) {
                  onCategoryChanged(int.tryParse(id ?? ''));
                },
              ),
            ),
            SizedBox(width: 12.w),
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
