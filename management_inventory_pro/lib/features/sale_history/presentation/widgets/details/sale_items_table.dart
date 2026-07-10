import 'package:flutter/material.dart';
import '../../../data/models/sale_item_model.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
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
        border: Border.all(color: context.colors.border),
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: context.colors.background,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
                      ),
                      child: Row(
                        children: [
                          _buildHeaderCell(context, 'Product', flex: 4),
                          _buildHeaderCell(context, 'Unit Price', flex: 2),
                          _buildHeaderCell(context, 'Qty', flex: 1),
                          _buildHeaderCell(context, 'Total', flex: 2),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: context.colors.border),

                    ...items.asMap().entries.map((entry) {
                      final i = entry.key;
                      final item = entry.value;
                      return Column(
                        children: [
                          _ItemRow(item: item),
                          if (i < items.length - 1)
                            Divider(height: 1, color: context.colors.border),
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


  Widget _buildHeaderCell(BuildContext context, String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.labelCaps.copyWith(
          color: context.colors.textSecondary,
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
          Expanded(
            flex: 2,
            child: Tooltip(
              message: '\$${item.sellingPrice.toStringAsFixed(2)}',
              child: Text(
                '\$${item.sellingPrice.toStringAsFixed(2)}',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMd.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.quantity.toString(),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMd.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
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