import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/table/stock_entry_table_footer.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/table/stock_entry_table_header.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/table/stock_entry_table_row.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/stock_entry_model.dart';
class StockEntryTable extends StatelessWidget {
  final List<StockEntryModel> entries;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final bool isLoadingMore;
  final ValueChanged<StockEntryModel> onEdit;
  final ValueChanged<StockEntryModel> onDelete;
  final VoidCallback onLoadMore;

  const StockEntryTable({
    super.key,
    required this.entries,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.isLoadingMore,
    required this.onEdit,
    required this.onDelete,
    required this.onLoadMore,
  });

  bool get _hasMore => (currentPage * pageSize) < totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Table header ──────────────────────────────────────────────────
          TableHeader(),
          const Divider(height: 1, color: AppColors.outlineVariant),
          // ── Rows ──────────────────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              itemCount: entries.length + (_hasMore || isLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.outlineVariant),
              itemBuilder: (context, index) {
                if (index == entries.length) {
                  return FooterRow(
                    isLoading: isLoadingMore,
                    loadedCount: entries.length,
                    totalCount: totalCount,
                    onLoadMore: onLoadMore,
                  );
                }
                return EntryRow(
                  entry: entries[index],
                  onEdit: () => onEdit(entries[index]),
                  onDelete: () => onDelete(entries[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
