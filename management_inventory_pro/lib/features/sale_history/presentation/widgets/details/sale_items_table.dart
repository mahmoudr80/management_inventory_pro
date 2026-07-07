import 'package:flutter/material.dart';
import '../../../data/models/sale_item_model.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

class SaleItemsTable extends StatefulWidget {
  const SaleItemsTable({super.key, required this.items});
  final List<SaleItemModel> items;

  @override
  State<SaleItemsTable> createState() => _SaleItemsTableState();
}

class _SaleItemsTableState extends State<SaleItemsTable> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 400,
                  maxWidth: constraints.maxWidth > 400 ? constraints.maxWidth : 400,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
                      ),
                      child: Row(
                        children: [
                          _buildHeaderCell('Product', flex: 4),
                          _buildHeaderCell('Unit Price', flex: 2),
                          _buildHeaderCell('Qty', flex: 1),
                          _buildHeaderCell('Total', flex: 2),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.border),

                    // Rows
                    ...items.asMap().entries.map((entry) {
                      final i = entry.key;
                      final item = entry.value;
                      return Column(
                        children: [
                          _ItemRow(item: item),
                          if (i < items.length - 1)
                            const Divider(height: 1, color: AppColors.border),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildHeaderCell(String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.labelCaps.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}


class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});
  final SaleItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          // Product name
          Expanded(
            flex: 4,
            child: Tooltip(
              message: item.product.name,
              child: Text(
                item.product.name,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMd.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Unit price (sellingPrice)
          Expanded(
            flex: 2,
            child: Tooltip(
              message: '\$${item.sellingPrice.toStringAsFixed(2)}',
              child: Text(
                '\$${item.sellingPrice.toStringAsFixed(2)}',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          // Quantity
          Expanded(
            flex: 1,
            child: Text(
              item.quantity.toString(),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // Total (computed getter)
          Expanded(
            flex: 2,
            child: Tooltip(
              message: '\$${item.total.toStringAsFixed(2)}',
              child: Text(
                '\$${item.total.toStringAsFixed(2)}',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMd.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
