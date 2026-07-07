import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_adjustment_item_model.dart';
import 'adjustment_quantity_field.dart';
import 'current_stock_widget.dart';
import 'inventory_value_widget.dart';
import 'new_stock_widget.dart';
import 'product_information.dart';
import 'row_actions.dart';

class AdjustmentRow extends StatelessWidget {
  final int index;
  final StockAdjustmentItemModel item;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<int> onQtyChanged;
  final VoidCallback onDelete;

  const AdjustmentRow({
    super.key,
    required this.index,
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.onQtyChanged,
    required this.onDelete,
  });

  Color get _rowBg {
    if (item.isNegativeInventory) {
      return AppColors.errorContainer.withOpacity(0.2);
    }
    if (isSelected) return AppColors.surfaceContainer;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    // Row height is fixed to keep the table scannable — there's no
    // design-system token for this taller, multi-column row, so it's
    // kept as an explicit constant here rather than a magic number
    // scattered through the layout.
    const double rowHeight = 56;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimation.fast,
        height: rowHeight,
        decoration: BoxDecoration(
          color: _rowBg,
          border: Border(
            bottom:
                BorderSide(color: AppColors.outlineVariant.withOpacity(0.5)),
            left: isSelected
                ? const BorderSide(
                    color: AppColors.primary, width: AppBorder.thick)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 24,
              child: Text(
                '${index + 1}',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(flex: 2, child: ProductInformation(item: item)),
            Expanded(
              flex: 1,
              child: Align(
                child: Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: CurrentStockWidget(
                    currentStock: item.currentStock,
                    unit: item.unit ?? '',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: AdjustmentQuantityField(
                  item: item,
                  onChanged: onQtyChanged,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: NewStockWidget(item: item),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: InventoryValueWidget(item: item),
              ),
            ),
            SizedBox(
              width: 48,
              child: Center(child: RowActions(onDelete: onDelete)),
            ),
          ],
        ),
      ),
    );
  }
}
