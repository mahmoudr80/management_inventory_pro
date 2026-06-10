import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/custom_text_field.dart';
import '../product_section_card.dart';

class InventorySection extends StatelessWidget {
  const InventorySection({super.key, required this.initialStockController,
    required this.minStockController}) ;
final TextEditingController initialStockController;
final TextEditingController minStockController;
  @override
  Widget build(BuildContext context) {
    return  ProductSectionCard(
      icon: Icons.inventory_2_outlined,
      title: 'Inventory',
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Initial stock',
                controller: initialStockController,
                keyboardType: TextInputType.number,
                helperText: 'Current quantity on hand',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextField(
                label: 'Minimum stock',
                controller: minStockController,
                keyboardType: TextInputType.number,
                helperText: 'Triggers reorder alert',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
