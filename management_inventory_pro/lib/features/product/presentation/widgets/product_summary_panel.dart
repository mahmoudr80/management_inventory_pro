import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/features/product/presentation/widgets/preview_row.dart';
import 'package:management_inventory_pro/features/product/presentation/widgets/side_card.dart';

import '../../../../core/components/status_chip.dart';
import 'check_row.dart';

class ProductSummaryPanel extends StatelessWidget {
  const ProductSummaryPanel({super.key, required this.sell, required this.nameController,
    required this.skuController, this.selectedCategoryId, required this.stock, required this.previewStatusText, required this.previewStatus});
final double sell;
final double stock;
final TextEditingController nameController;
final TextEditingController skuController;
final int? selectedCategoryId;
final String previewStatusText;
final StatusType previewStatus;
  @override
  Widget build(BuildContext context) {
      final cs = Theme.of(context).colorScheme;
      bool nameOk = nameController.text.trim().isNotEmpty;
      bool skuOk = skuController.text.trim().isNotEmpty;
      bool catOk = selectedCategoryId != null;
      bool priceOk = sell > 0;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Checklist
          SideCard(//c
            title: 'Completion checklist',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckRow(label: 'Product name',done:  nameOk),
                CheckRow(label:'SKU',done:  skuOk),
                CheckRow(label:'Category', done: catOk),
                CheckRow(label:'Selling price', done: priceOk),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Preview
          SideCard(
            title: 'Live preview',
            child: Column(
              children: [
                PreviewRow(label: 'Name',
                   value:  nameController.text.trim().isEmpty
                        ? '—'
                        : nameController.text.trim()),
                PreviewRow(label: 'SKU',
                   value:  skuController.text.trim().isEmpty
                        ? '—'
                        : skuController.text.trim(),
                    mono: true),
                PreviewRow(label:'Stock',
                  value:  stock > 0 ? '${stock.toInt()} units' : '—'),
                PreviewRow(label: 'Price',
                  value:  sell > 0 ? '\$${sell.toStringAsFixed(2)}' : '—'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Row(
                    children: [
                      Text('Status',
                          style: TextStyle(
                              fontSize: 11.sp.clamp(10, 13),
                              color: cs.onSurfaceVariant)),
                      const Spacer(),
                      StatusChip(
                        label: previewStatusText,
                        type: previewStatus,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

