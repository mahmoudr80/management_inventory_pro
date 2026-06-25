import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_line_model.dart';

class StockEntryLinesTable extends StatelessWidget {
  const StockEntryLinesTable({super.key, required this.lines});

  final List<StockEntryLineModel> lines;

  static final _currFmt =
      NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Center(
          child: Text(
            'No line items',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.outline,fontSize: 5.sp),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Container(
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
            ),
            child: Row(
              children: [
                _HeaderCell('Product', flex: 4),
                _HeaderCell('Cost', flex: 2),
                _HeaderCell('Unit', flex: 2),
                _HeaderCell('Qty', flex: 1),
                _HeaderCell('Total', flex: 2),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),

          // ── Rows ───────────────────────────────────────────────────────
          ...lines.asMap().entries.map((e) {
            return Column(
              children: [
                _LineRow(line: e.value, currFmt: _currFmt),
                if (e.key < lines.length - 1)
                  const Divider(height: 1, color: AppColors.outlineVariant),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label, {this.flex = 1});
  final String label;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label.toUpperCase(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 3.sp,fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({required this.line, required this.currFmt});
  final StockEntryLineModel line;
  final NumberFormat currFmt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
      child: Row(
        children: [
          // Product name
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.product.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMd
                      .copyWith(fontWeight: FontWeight.w600,fontSize: 4.sp),
                ),
                if (line.product.sku != null)
                  Text(
                    line.product.sku!,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm
                        .copyWith(color: AppColors.outline, fontSize: 3.sp),
                  ),
              ],
            ),
          ),
          // Unit cost
          Expanded(
            flex: 2,
            child: Text(
              currFmt.format(line.unitCost),
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.dataMono
                  .copyWith(color: AppColors.outline, fontSize: 4.sp),
            ),
          ),
          // Unit name
          Expanded(
            flex: 2,
            child: Text(
              line.unitSymbol ?? '—',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.outline,fontSize: 4.sp),
            ),
          ),
          // Quantity
          Expanded(
            flex: 1,
            child: Text(
              line.quantity.toString(),
              style: AppTextStyles.dataMono.copyWith(fontSize: 4.sp),
            ),
          ),
          // Line total
          Expanded(
            flex: 2,
            child: Text(
              currFmt.format(line.lineTotal),
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.dataMono.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
                fontSize: 4.sp
              ),
            ),
          ),
        ],
      ),
    );
  }
}
