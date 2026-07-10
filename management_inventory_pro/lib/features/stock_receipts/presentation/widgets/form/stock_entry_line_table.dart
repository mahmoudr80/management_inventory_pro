import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_decoration.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_line_model.dart';
import '../entry_line_row.dart';

class StockEntryLineTable extends StatelessWidget {
  const StockEntryLineTable({
    super.key,
    required this.lines,
    required this.onLineChanged,
    required this.onRemoveLine,
    required this.onAddLine,
  });

  final List<StockEntryLineModel> lines;
  final Function(int, StockEntryLineModel) onLineChanged;
  final Function(int) onRemoveLine;
  final VoidCallback onAddLine;

  @override
  Widget build(BuildContext context) {
    final Widget tableContent = Column(
      children: [
        // Table header row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 32, child: Text('#', style: AppTextStyles.labelCaps)),
              Expanded(
                flex: 4,
                child: Text('PRODUCT NAME / SKU', style: AppTextStyles.labelCaps),
              ),
              Expanded(
                flex: 2,
                child: Center(child: Text('QTY', style: AppTextStyles.labelCaps)),
              ),
              Expanded(
                flex: 2,
                child: Center(child: Text('COST PRICE', style: AppTextStyles.labelCaps)),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('TOTAL', style: AppTextStyles.labelCaps),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
        Divider(height: 1, color: context.colors.outlineVariant),
        // Lines
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lines.length,
          separatorBuilder: (_, _) => Divider(height: 1, color: context.colors.outlineVariant),
          itemBuilder: (_, index) => EntryLineRow(
            index: index,
            line: lines[index],
            onChanged: (updated) => onLineChanged(index, updated),
            onRemove: () => onRemoveLine(index),
          ),
        ),
        // Add row button
        Divider(height: 1, color: context.colors.outlineVariant),
        InkWell(
          onTap: onAddLine,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.add, color: context.colors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Start typing to add a product...',
                  style: AppTextStyles.bodyMd.copyWith(color: context.colors.outline),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 650) {
          final ScrollController scrollController = ScrollController();
          return Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 650,
                child: Container(
                  decoration: AppDecorations.card(),
                  child: tableContent,
                ),
              ),
            ),
          );
        }
        return Container(
          decoration: AppDecorations.card(),
          child: tableContent,
        );
      },
    );
  }
}