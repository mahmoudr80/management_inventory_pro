import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    if (item.isNegativeInventory) return const Color(0xFFFFDAD6).withOpacity(0.2);
    if (isSelected) return const Color(0xFFEAEDFF);
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 56.h,
        decoration: BoxDecoration(
          color: _rowBg,
          border: Border(
            bottom: BorderSide(color: const Color(0xFFC3C5D9).withOpacity(0.5)),
            left: isSelected
                ? const BorderSide(color: Color(0xFF0041C8), width: 2)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 5.w),
            SizedBox(
              width: 8.w,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 5.sp,
                  color: const Color(0xFF737688),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(flex: 2, child: ProductInformation(item: item)),
            Expanded(
              flex: 1,
              child: Align(
                child: Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: CurrentStockWidget(
                    currentStock: item.currentStock,
                    unit: item.unit??'',
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
                padding: EdgeInsets.only(right: 2.w),
                child: NewStockWidget(item: item),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: InventoryValueWidget(item: item),
              ),
            ),
            SizedBox(
              width: 15.w,
              child: Center(child: RowActions(onDelete: onDelete)),
            ),
          ],
        ),
      ),
    );
  }
}
