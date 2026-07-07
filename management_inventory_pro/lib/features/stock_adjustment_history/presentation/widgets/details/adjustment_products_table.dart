import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/product_adjustment_model.dart';
import 'adjustment_product_row.dart';

/// Scrollable-by-content table of products affected by the selected
/// adjustment. Shows the first [collapsedCount] rows with a "View N more
/// products" toggle, matching the reference design.
///
/// Local expand/collapse state only — no business logic — so it stays a
/// `StatefulWidget`. Give this widget a `ValueKey(adjustment.id)` from the
/// parent so the expand state resets when the selected adjustment changes.
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
            border: Border.all(color: AppColors.outlineVariant, width: AppBorder.thin),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                color: AppColors.surfaceContainerLow,
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
                            color: AppColors.onSurfaceVariant,
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
                            color: AppColors.onSurfaceVariant,
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
                            color: AppColors.onSurfaceVariant,
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
                    top: BorderSide(color: AppColors.outlineVariant, width: AppBorder.thin),
                  ),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < visibleProducts.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: AppBorder.thin,
                          color: AppColors.outlineVariant,
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
                    color: AppColors.surfaceContainerLow,
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
                          color: AppColors.primary,
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
