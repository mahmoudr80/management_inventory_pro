// lib/features/reports/presentation/screens/inventory_valuation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/datasource/inventory_valuation_local_datasource.dart';
import '../../data/models/inventory_valuation_model.dart';
import '../../data/services/report_export_service.dart';
import '../cubit/base_report_state.dart';
import '../cubit/inventory_valuation_cubit.dart';
import '../widgets/category_value_pie_chart.dart';
import '../widgets/report_breadcrumb.dart';
import '../widgets/report_chart_card.dart';
import '../widgets/report_data_table.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_pagination_bar.dart';
import '../widgets/report_select_filter.dart';
import '../widgets/report_status_pill.dart';
import '../widgets/report_summary_cards.dart';
import '../widgets/report_table_search_field.dart';
import '../widgets/report_workspace.dart';

class InventoryValuationScreen extends StatefulWidget {
  const InventoryValuationScreen({super.key});

  @override
  State<InventoryValuationScreen> createState() => _InventoryValuationScreenState();
}

class _InventoryValuationScreenState extends State<InventoryValuationScreen> {
  static const _columnKeys = <String?>[null, null, 'stock', 'cost', 'value', null];

  bool _exporting = false;
  List<ReportSelectOption> _categoryOptions = const [];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<InventoryValuationCubit>();
    cubit.load();
    // Phase 3: category options are a system-wide dictionary lookup, not
    // part of the report's own paginated result — fetched once here
    // rather than re-queried on every load().
    cubit.repository.fetchCategoryOptions().then((options) {
      if (!mounted) return;
      setState(() {
        _categoryOptions = [
          for (final (value, label) in options) ReportSelectOption(value: value, label: label),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InventoryValuationCubit>();

    return BlocBuilder<InventoryValuationCubit, BaseReportState<InventoryValuationData>>(
      builder: (context, state) {
        final data = state.data;
        final isLoading = state.isLoading;

        return ReportWorkspace(
          title: 'Inventory Valuation',
          subtitle: 'Current stock value across all active products.',
          breadcrumb: const ReportBreadcrumb(currentLabel: 'Inventory Valuation'),
          bentoChart: true,
          headerActions: [
            OutlinedButton.icon(
              onPressed: isLoading ? null : cubit.refresh,
              icon: const Icon(Icons.refresh, size: AppIconSize.sm),
              label: const Text('Refresh Data'),
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
            trailing: [
              ReportSelectFilter(
                label: 'Categories',
                selectedValue: state.filters.extraValue(
                  InventoryValuationLocalDataSource.categoryFilterKey,
                ),
                options: _categoryOptions,
                onChanged: (value) => cubit.updateExtraFilter(
                  InventoryValuationLocalDataSource.categoryFilterKey,
                  value,
                ),
              ),
            ],
          ),
          summaryCards: ReportSummaryCards(
            cards: [
              ReportSummaryCardData(label: 'Total Inventory Value', value: _money(data?.summary.totalValue ?? 0)),
              ReportSummaryCardData(label: 'Active SKUs', value: '${data?.summary.activeSkus ?? 0}'),
              ReportSummaryCardData(label: 'Low Stock Items', value: '${data?.summary.lowStockCount ?? 0}'),
              ReportSummaryCardData(label: 'Out of Stock', value: '${data?.summary.outOfStockCount ?? 0}'),
            ],
          ),
          chart: ReportChartCard(
            title: 'Value by Category',
            height: 400,
            isLoading: isLoading,
            isEmpty: (data?.categoryBreakdown ?? const []).isEmpty,
            child: CategoryValuePieChart(
              slices: data?.categoryBreakdown ?? const [],
              totalValue: data?.summary.totalValue ?? 0,
            ),
          ),
          table: ReportDataTable<InventoryValuationRow>(
            title: 'Top Value Items',
            headerTrailing: ReportTableSearchField(
              hint: 'Search SKU or product...',
              onChanged: cubit.updateSearch,
            ),
            maxHeight: 400,
            isLoading: isLoading,
            isError: state.isError,
            errorMessage: state.errorMessage,
            onRetry: cubit.refresh,
            rows: data?.rows ?? const [],
            sortColumnIndex: _sortIndex(cubit.sortColumn),
            sortAscending: cubit.sortAscending,
            onSort: (index) {
              final key = _columnKeys[index];
              if (key != null) cubit.changeSort(key);
            },
            columns: [
              ReportTableColumn<InventoryValuationRow>(
                label: 'SKU',
                cellBuilder: (context, row) =>
                    Text(row.sku, style: AppTextStyles.dataMono.copyWith(fontWeight: FontWeight.w600)),
              ),
              ReportTableColumn<InventoryValuationRow>(
                label: 'Product Name',
                cellBuilder: (context, row) => Text(row.productName),
              ),
              ReportTableColumn<InventoryValuationRow>(
                label: 'Stock',
                align: ReportColumnAlign.right,
                sortable: true,
                cellBuilder: (context, row) => Text(row.currentStock.toStringAsFixed(0), style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<InventoryValuationRow>(
                label: 'Cost/Unit',
                align: ReportColumnAlign.right,
                sortable: true,
                cellBuilder: (context, row) => Text(_money(row.costPrice), style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<InventoryValuationRow>(
                label: 'Total Val',
                align: ReportColumnAlign.right,
                sortable: true,
                cellBuilder: (context, row) =>
                    Text(_money(row.totalValue), style: AppTextStyles.dataMono.copyWith(fontWeight: FontWeight.w700)),
              ),
              ReportTableColumn<InventoryValuationRow>(
                label: 'Status',
                align: ReportColumnAlign.center,
                cellBuilder: (context, row) => ReportStatusPill.stockStatus(context, row.status, dotOnly: true),
              ),
            ],
          ),
          pagination: data == null
              ? null
              : ReportPaginationBar(
                  currentPage: cubit.currentPage,
                  totalPages: (data.totalEntries / InventoryValuationCubit.pageSize).ceil().clamp(1, 999999),
                  totalEntries: data.totalEntries,
                  pageSize: InventoryValuationCubit.pageSize,
                  onPageChanged: cubit.changePage,
                ),
        );
      },
    );
  }

  int? _sortIndex(String? key) {
    if (key == null) return null;
    final index = _columnKeys.indexOf(key);
    return index == -1 ? null : index;
  }

  /// Exports the currently loaded page — see ReportExportService's doc
  /// comment on why "export everything matching the filters" is a
  /// follow-up, not this pass.
  Future<void> _export(InventoryValuationData data) async {
    setState(() => _exporting = true);
    try {
      await ReportExportService.exportCsv(
        fileNameWithoutExtension: 'inventory_valuation',
        headers: const ['SKU', 'Product Name', 'Stock', 'Cost/Unit', 'Total Value', 'Status'],
        rows: [
          for (final row in data.rows)
            [
              row.sku,
              row.productName,
              row.currentStock.toStringAsFixed(0),
              row.costPrice.toStringAsFixed(2),
              row.totalValue.toStringAsFixed(2),
              row.status.name,
            ],
        ],
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

String _money(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  return '\$$whole.${parts[1]}';
}
