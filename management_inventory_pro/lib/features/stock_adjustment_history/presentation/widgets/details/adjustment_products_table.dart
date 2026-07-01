import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  State<AdjustmentProductsTable> createState() => _AdjustmentProductsTableState();
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
          style: AppTextStyles.labelCaps,
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.outlineVariant),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                color: AppColors.surfaceContainerLow,
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text('Product', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant))),
                    Expanded(flex: 2, child: Text('Adjustment', textAlign: TextAlign.right, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant))),
                    Expanded(flex: 2, child: Text('New Stock', textAlign: TextAlign.right, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant))),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.outlineVariant)),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < visibleProducts.length; i++) ...[
                      if (i > 0) Divider(height: 1, color: AppColors.outlineVariant),
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
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    alignment: Alignment.center,
                    child: Text(
                      _expanded ? 'View less' : 'View $remaining more products',
                      style: AppTextStyles.bodySm.copyWith(
                        fontSize: 5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
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
