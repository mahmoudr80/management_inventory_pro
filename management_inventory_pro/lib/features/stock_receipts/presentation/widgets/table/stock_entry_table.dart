import 'package:flutter/material.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/table/stock_entry_table_footer.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/table/stock_entry_table_header.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/table/stock_entry_table_row.dart';

import '../../../../../core/theme/app_theme_extension.dart';
import '../../../data/models/stock_entry_model.dart';

class StockEntryTable extends StatelessWidget {
  final List<StockEntryModel> entries;
  final StockEntryModel? selectedEntry;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final bool isLoadingMore;
  final ValueChanged<StockEntryModel> onSelect;
  final ValueChanged<StockEntryModel> onEdit;
  final ValueChanged<StockEntryModel> onDelete;
  final VoidCallback onLoadMore;

  const StockEntryTable({
    super.key,
    required this.entries,
    this.selectedEntry,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.isLoadingMore,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
    required this.onLoadMore,
  });

  bool get _hasMore => (currentPage * pageSize) < totalCount;

  @override
  Widget build(BuildContext context) {
    Widget buildTableContent() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Table header ──────────────────────────────────────────────
          const TableHeader(),
          Divider(height: 1, color: context.colors.outlineVariant),

          // ── Rows ──────────────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              itemCount: entries.length + (_hasMore || isLoadingMore ? 1 : 0),
              separatorBuilder: (_, _) =>
                  Divider(height: 1, color: context.colors.outlineVariant),
              itemBuilder: (context, index) {
                if (index == entries.length) {
                  return FooterRow(
                    isLoading: isLoadingMore,
                    loadedCount: entries.length,
                    totalCount: totalCount,
                    onLoadMore: onLoadMore,
                  );
                }
                final entry = entries[index];
                return EntryRow(
                  entry: entry,
                  isSelected: selectedEntry?.id == entry.id,
                  onTap: () => onSelect(entry),
                  onEdit: () => onEdit(entry),
                  onDelete: () => onDelete(entry),
                );
              },
            ),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          final ScrollController scrollController = ScrollController();
          return Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 800,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.colors.outlineVariant),
                  ),
                  child: buildTableContent(),
                ),
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.colors.outlineVariant),
          ),
          child: buildTableContent(),
        );
      },
    );
  }
}