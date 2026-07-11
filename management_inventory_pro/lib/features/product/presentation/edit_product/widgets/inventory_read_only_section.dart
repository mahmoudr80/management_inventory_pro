import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/widgets/custom_text_field.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/product_section_card.dart';

/// Inventory section for Edit Product.
///
/// Current stock is DISPLAY-ONLY here — Product Master Data edits must
/// never move inventory. The only quantity-adjacent value this section
/// lets the user touch is the *minimum stock threshold* (a reorder-alert
/// setting, not a quantity). Actual stock levels only ever change
/// through Stock Entry / Stock Adjustment.
class InventoryReadOnlySection extends StatelessWidget {
  const InventoryReadOnlySection({
    super.key,
    required this.currentStock,
    required this.unitLabel,
    required this.minStockController,
  });

  final double currentStock;
  final String? unitLabel;
  final TextEditingController minStockController;

  String get _stockText {
    final isWhole = currentStock.truncateToDouble() == currentStock;
    final number = currentStock.toStringAsFixed(isWhole ? 0 : 2);
    return unitLabel == null || unitLabel!.isEmpty ? number : '$number $unitLabel';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ProductSectionCard(
      icon: Icons.inventory_2_outlined,
      title: 'Inventory',
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current stock',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Text(
                      _stockText,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Adjust via Stock Entry or Stock Adjustment',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
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
