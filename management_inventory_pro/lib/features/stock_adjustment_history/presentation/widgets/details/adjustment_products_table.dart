import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_adjustment_model.dart';
import 'adjustment_product_row.dart';

class AdjustmentProductsTable extends StatefulWidget {
  const AdjustmentProductsTable({
    super.key,
    required this.products,
    this.collapsedCount = 4,
  });

  final List<ProductAdjustmentModel> products;
  final int collapsedCount;

  @override
  State<AdjustmentProductsTable> createState() =>
      _AdjustmentProductsTableState();
}

class _AdjustmentProductsTableState extends State<AdjustmentProductsTable> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasMore = widget.products.length > widget.collapsedCount;
    final visibleProducts = _expanded || !hasMore
        ? widget.products
        : widget.products.take(widget.collapsedCount).toList();
    final remaining = widget.products.length - widget.collapsedCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ADJUSTED PRODUCTS (${widget.products.length})',
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.labelCaps,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.colors.outlineVariant, width: AppBorder.thin),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                color: context.colors.surfaceContainerLow,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Tooltip(
                        message: 'Product',
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          'Product',
                          style: AppTextStyles.bodySm.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Tooltip(
                        message: 'Adjustment',
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          'Adjustment',
                          textAlign: TextAlign.right,
                          style: AppTextStyles.bodySm.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Tooltip(
                        message: 'New Stock',
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          'New Stock',
                          textAlign: TextAlign.right,
                          style: AppTextStyles.bodySm.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: context.colors.outlineVariant, width: AppBorder.thin),
                  ),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < visibleProducts.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: AppBorder.thin,
                          color: context.colors.outlineVariant,
                        ),
                      AdjustmentProductRow(product: visibleProducts[i]),
                    ],
                  ],
                ),
              ),
              if (hasMore)
                InkWell(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Container(
                    width: double.infinity,
                    color: context.colors.surfaceContainerLow,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    alignment: Alignment.center,
                    child: Tooltip(
                      message: _expanded
                          ? 'View less'
                          : 'View $remaining more products',
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        _expanded
                            ? 'View less'
                            : 'View $remaining more products',
                        style: AppTextStyles.bodySm.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}