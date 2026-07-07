import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_line_model.dart';

class StockEntryLinesTable extends StatelessWidget {
  const StockEntryLinesTable({super.key, required this.lines});

  final List<StockEntryLineModel> lines;

  static final _currFmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Center(
          child: Text(
            'No line items',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
          ),
        ),
      );
    }

    final Widget tableContent = Column(
      children: [
        // ── Header ─────────────────────────────────────────────────────
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: const Row(
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
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 450) {
          final ScrollController scrollController = ScrollController();
          return Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 450,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: tableContent,
                ),
              ),
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: tableContent,
        );
      },
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
        style: AppTextStyles.labelCaps.copyWith(fontSize: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Product name
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: line.product.name,
                  child: Text(
                    line.product.name,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (line.product.sku != null)
                  Tooltip(
                    message: line.product.sku!,
                    child: Text(
                      line.product.sku!,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
                    ),
                  ),
              ],
            ),
          ),
          // Unit cost
          Expanded(
            flex: 2,
            child: Tooltip(
              message: currFmt.format(line.unitCost),
              child: Text(
                currFmt.format(line.unitCost),
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.dataMono.copyWith(color: AppColors.outline),
              ),
            ),
          ),
          // Unit name
          Expanded(
            flex: 2,
            child: Tooltip(
              message: line.unitSymbol ?? '—',
              child: Text(
                line.unitSymbol ?? '—',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
              ),
            ),
          ),
          // Quantity
          Expanded(
            flex: 1,
            child: Tooltip(
              message: line.quantity.toString(),
              child: Text(
                line.quantity.toString(),
                style: AppTextStyles.dataMono,
              ),
            ),
          ),
          // Line total
          Expanded(
            flex: 2,
            child: Tooltip(
              message: currFmt.format(line.lineTotal),
              child: Text(
                currFmt.format(line.lineTotal),
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.dataMono.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
