// lib/features/reports/presentation/screens/stock_adjustment_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/models/stock_adjustment_history_model.dart';
import '../../data/services/report_export_service.dart';
import '../cubit/base_report_state.dart';
import '../cubit/stock_adjustment_history_cubit.dart';
import '../widgets/report_breadcrumb.dart';
import '../widgets/report_data_table.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_pagination_bar.dart';
import '../widgets/report_status_pill.dart';
import '../widgets/report_summary_cards.dart';
import '../widgets/report_table_search_field.dart';
import '../widgets/report_workspace.dart';

class StockAdjustmentHistoryScreen extends StatefulWidget {
  const StockAdjustmentHistoryScreen({super.key});

  @override
  State<StockAdjustmentHistoryScreen> createState() => _StockAdjustmentHistoryScreenState();
}

class _StockAdjustmentHistoryScreenState extends State<StockAdjustmentHistoryScreen> {
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    context.read<StockAdjustmentHistoryCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StockAdjustmentHistoryCubit>();

    return BlocBuilder<StockAdjustmentHistoryCubit, BaseReportState<StockAdjustmentHistoryData>>(
      builder: (context, state) {
        final data = state.data;
        final isLoading = state.isLoading;

        return ReportWorkspace(
          title: 'Stock Adjustment History',
          subtitle: 'Manual stock corrections and their inventory value impact.',
          breadcrumb: const ReportBreadcrumb(currentLabel: 'Stock Adjustment History'),
          headerActions: [
            OutlinedButton.icon(
              onPressed: isLoading ? null : cubit.refresh,
              icon: const Icon(Icons.refresh, size: AppIconSize.sm),
              label: const Text('Refresh'),
            ),
            OutlinedButton.icon(
              onPressed: data == null || _exporting ? null : () => _export(data),
              icon: const Icon(Icons.download_outlined, size: AppIconSize.sm),
              label: Text(_exporting ? 'Exporting…' : 'Export CSV'),
            ),
          ],
          filterBar: ReportFilterBar(
            selectedRange: state.filters.dateRange,
            onDateRangeChanged: cubit.updateDateRange,
            onRefresh: cubit.refresh,
            onReset: cubit.resetFilters,
          ),
          summaryCards: ReportSummaryCards(
            cards: [
              ReportSummaryCardData(label: 'Adjustments', value: '${data?.summary.adjustments ?? 0}'),
              ReportSummaryCardData(
                label: 'Inventory Value Impact',
                value: _money(data?.summary.inventoryValueImpact ?? 0),
                valueColor: (data?.summary.inventoryValueImpact ?? 0) >= 0
                    ? context.colors.success
                    : context.colors.error,
              ),
            ],
          ),
          table: ReportDataTable<StockAdjustmentHistoryRow>(
            title: 'Adjustment History',
            headerTrailing: ReportTableSearchField(
              hint: 'Search adjustment #...',
              onChanged: cubit.updateSearch,
            ),
            isLoading: isLoading,
            isError: state.isError,
            errorMessage: state.errorMessage,
            onRetry: cubit.refresh,
            rows: data?.rows ?? const [],
            columns: [
              ReportTableColumn<StockAdjustmentHistoryRow>(
                label: 'Adjustment #',
                cellBuilder: (context, row) =>
                    Text(row.adjustmentNumber, style: AppTextStyles.dataMono.copyWith(color: context.colors.primary)),
              ),
              ReportTableColumn<StockAdjustmentHistoryRow>(
                label: 'Reason',
                cellBuilder: (context, row) => Text(row.reason),
              ),
              ReportTableColumn<StockAdjustmentHistoryRow>(
                label: 'Items',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text('${row.items}', style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<StockAdjustmentHistoryRow>(
                label: 'Value Impact',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text(
                  _money(row.valueImpact),
                  style: AppTextStyles.dataMono.copyWith(
                    color: row.valueImpact >= 0 ? context.colors.success : context.colors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ReportTableColumn<StockAdjustmentHistoryRow>(
                label: 'Created By',
                cellBuilder: (context, row) => Text(row.createdBy),
              ),
              ReportTableColumn<StockAdjustmentHistoryRow>(
                label: 'Status',
                align: ReportColumnAlign.center,
                cellBuilder: (context, row) => ReportStatusPill.generic(context, row.status),
              ),
              ReportTableColumn<StockAdjustmentHistoryRow>(
                label: 'Date',
                cellBuilder: (context, row) => Text(_date(row.date), style: AppTextStyles.dataMono),
              ),
            ],
          ),
          pagination: data == null
              ? null
              : ReportPaginationBar(
                  currentPage: cubit.currentPage,
                  totalPages:
                      (data.totalEntries / StockAdjustmentHistoryCubit.pageSize).ceil().clamp(1, 999999),
                  totalEntries: data.totalEntries,
                  pageSize: StockAdjustmentHistoryCubit.pageSize,
                  onPageChanged: cubit.changePage,
                ),
        );
      },
    );
  }

  Future<void> _export(StockAdjustmentHistoryData data) async {
    setState(() => _exporting = true);
    try {
      await ReportExportService.exportCsv(
        fileNameWithoutExtension: 'stock_adjustment_history',
        headers: const ['Adjustment #', 'Reason', 'Items', 'Value Impact', 'Created By', 'Status', 'Date'],
        rows: [
          for (final row in data.rows)
            [
              row.adjustmentNumber,
              row.reason,
              '${row.items}',
              row.valueImpact.toStringAsFixed(2),
              row.createdBy,
              row.status,
              _date(row.date),
            ],
        ],
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

String _money(double value) {
  final isNegative = value < 0;
  final fixed = value.abs().toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  return '${isNegative ? '-' : ''}\$$whole.${parts[1]}';
}

String _date(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${date.year}-${two(date.month)}-${two(date.day)}';
}
