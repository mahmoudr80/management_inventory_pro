import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/components/status_chip.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/preview_row.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/side_card.dart';

/// Read-only summary shown beside the Edit Product form: product id,
/// creation date, current stock, and status.
///
/// None of these are editable here by design — Edit Product changes
/// master data only, never the product's identity, history, or
/// inventory quantity.
class ProductReadOnlyInfoCard extends StatelessWidget {
  const ProductReadOnlyInfoCard({
    super.key,
    required this.id,
    required this.createdAt,
    required this.currentStock,
    required this.statusText,
    required this.status,
  });

  final String id;
  final String? createdAt;
  final double currentStock;
  final String statusText;
  final StatusType status;

  String get _stockText {
    final isWhole = currentStock.truncateToDouble() == currentStock;
    return '${currentStock.toStringAsFixed(isWhole ? 0 : 2)} units';
  }

  @override
  Widget build(BuildContext context) {
    return SideCard(
      title: 'Product info (read-only)',
      child: Column(
        children: [
          PreviewRow(label: 'Product ID', value: id, mono: true),
          PreviewRow(
            label: 'Created',
            value: createdAt == null || createdAt!.isEmpty
                ? '—'
                : createdAt!.split(' ').first,
          ),
          PreviewRow(label: 'Current stock', value: _stockText),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                StatusChip(label: statusText, type: status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
