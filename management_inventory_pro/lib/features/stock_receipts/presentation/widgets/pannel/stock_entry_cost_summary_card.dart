import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_model.dart';

class StockEntryCostSummaryCard extends StatelessWidget {
  const StockEntryCostSummaryCard({super.key, required this.entry});

  final StockEntryModel entry;

  static final _currFmt =
      NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    // Prefer denormalized totals when available, fall back to summing lines.
    final totalItems = entry.totalItems ??
        entry.lines.length;
    final totalQty = entry.totalQuantity ??
        entry.lines.fold<double>(0, (s, l) => s + l.quantity);
    final totalCost = entry.totalCost ??
        entry.lines.fold<double>(0, (s, l) => s + l.lineTotal);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cost Summary',
            style: AppTextStyles.bodySmall.copyWith(fontSize: 5.sp),
          ),
          SizedBox(height: 10.h),

          _SummaryRow(label: 'Total Items', value: totalItems.toString()),
          _SummaryRow(
            label: 'Total Quantity',
            value: totalQty % 1 == 0
                ? totalQty.toInt().toString()
                : totalQty.toStringAsFixed(2),
          ),
          // _SummaryRow(
          //   label: 'Subtotal',
          //   value: _currFmt.format(totalCost),
          // ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const Divider(height: 1, color: AppColors.outlineVariant),
          ),

          _SummaryRow(
            label: 'Total Cost',
            value: _currFmt.format(totalCost),
            labelStyle: AppTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
            valueStyle: AppTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (labelStyle ??
                  AppTextStyles.bodySm).copyWith(color: AppColors.outline,fontSize: 4.sp),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: valueStyle ??
                AppTextStyles.dataMono.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 4.sp,
                  color: AppColors.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
