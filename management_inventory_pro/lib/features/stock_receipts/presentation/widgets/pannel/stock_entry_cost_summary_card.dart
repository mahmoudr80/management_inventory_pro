import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_model.dart';

class StockEntryCostSummaryCard extends StatelessWidget {
  const StockEntryCostSummaryCard({super.key, required this.entry});

  final StockEntryModel entry;

  static final _currFmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    final totalItems = entry.totalItems ?? entry.lines.length;
    final totalQty = entry.totalQuantity ??
        entry.lines.fold<double>(0, (s, l) => s + l.quantity);
    final totalCost = entry.totalCost ??
        entry.lines.fold<double>(0, (s, l) => s + l.lineTotal);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cost Summary',
            style: AppTextStyles.labelCaps,
          ),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Total Items', value: totalItems.toString()),
          _SummaryRow(
            label: 'Total Quantity',
            value: totalQty % 1 == 0
                ? totalQty.toInt().toString()
                : totalQty.toStringAsFixed(2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: context.colors.outlineVariant),
          ),
          _SummaryRow(
            label: 'Total Cost',
            value: _currFmt.format(totalCost),
            labelStyle: AppTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.onSurface,
            ),
            valueStyle: AppTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.primary,
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Tooltip(
              message: label,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (labelStyle ?? AppTextStyles.bodySm).copyWith(
                  color: context.colors.outline,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: value,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: valueStyle ??
                  AppTextStyles.dataMono.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}