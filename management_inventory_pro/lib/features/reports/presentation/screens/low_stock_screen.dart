// lib/features/reports/presentation/screens/low_stock_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/datasource/low_stock_local_datasource.dart';
import '../../data/models/low_stock_model.dart';
import '../../data/services/report_export_service.dart';
import '../cubit/base_report_state.dart';
import '../cubit/low_stock_cubit.dart';
import '../widgets/report_breadcrumb.dart';
import '../widgets/report_data_table.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_pagination_bar.dart';
import '../widgets/report_select_filter.dart';
import '../widgets/report_summary_cards.dart';
import '../widgets/report_table_search_field.dart';
import '../widgets/report_workspace.dart';

/// No chart, per the Phase 2 spec ("Low Stock: No chart.") — `chart` is
/// simply left null on [ReportWorkspace], which already treats it as
/// optional.
class LowStockScreen extends StatefulWidget {
  const LowStockScreen({super.key});

  @override
  State<LowStockScreen> createState() => _LowStockScreenState();
}

class _LowStockScreenState extends State<LowStockScreen> {
  bool _exporting = false;
  List<ReportSelectOption> _supplierOptions = const [];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<LowStockCubit>();
    cubit.load();
    cubit.repository.fetchSupplierOptions().then((options) {
      if (!mounted) return;
      setState(() {
        _supplierOptions = [
          for (final (value, label) in options) ReportSelectOption(value: value, label: label),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LowStockCubit>();

    return BlocBuilder<LowStockCubit, BaseReportState<LowStockData>>(
      builder: (context, state) {
        final data = state.data;
        final isLoading = state.isLoading;

        return ReportWorkspace(
          title: 'Low Stock',
          subtitle: 'Products at or below their minimum stock threshold.',
          breadcrumb: const ReportBreadcrumb(currentLabel: 'Low Stock'),
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
            trailing: [
              ReportSelectFilter(
                label: 'Suppliers',
                selectedValue: state.filters.extraValue(LowStockLocalDataSource.supplierFilterKey),
                options: _supplierOptions,
                onChanged: (value) =>
                    cubit.updateExtraFilter(LowStockLocalDataSource.supplierFilterKey, value),
              ),
            ],
          ),
          summaryCards: ReportSummaryCards(
            cards: [
              ReportSummaryCardData(
                label: 'Low Stock Products',
                value: '${data?.summary.lowStockCount ?? 0}',
                icon: Icons.warning_amber_rounded,
                valueColor: context.colors.warning,
              ),
            ],
          ),
          table: ReportDataTable<LowStockRow>(
            title: 'Low Stock Products',
            headerTrailing: ReportTableSearchField(
              hint: 'Search product...',
              onChanged: cubit.updateSearch,
            ),
            isLoading: isLoading,
            isError: state.isError,
            errorMessage: state.errorMessage,
            onRetry: cubit.refresh,
            rows: data?.rows ?? const [],
            columns: [
              ReportTableColumn<LowStockRow>(
                label: 'Product',
                cellBuilder: (context, row) => Text(row.productName),
              ),
              ReportTableColumn<LowStockRow>(
                label: 'Category',
                cellBuilder: (context, row) => Text(row.category),
              ),
              ReportTableColumn<LowStockRow>(
                label: 'Current Stock',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text(
                  row.currentStock.toStringAsFixed(0),
                  style: AppTextStyles.dataMono.copyWith(color: context.colors.warning, fontWeight: FontWeight.w700),
                ),
              ),
              ReportTableColumn<LowStockRow>(
                label: 'Minimum Stock',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text(row.minimumStock.toStringAsFixed(0), style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<LowStockRow>(
                label: 'Supplier',
                cellBuilder: (context, row) => Text(row.supplierName ?? '-'),
              ),
              ReportTableColumn<LowStockRow>(
                label: 'Last Stock Entry',
                cellBuilder: (context, row) =>
                    Text(row.lastStockEntry == null ? '-' : _date(row.lastStockEntry!), style: AppTextStyles.dataMono),
              ),
            ],
          ),
          pagination: data == null
              ? null
              : ReportPaginationBar(
                  currentPage: cubit.currentPage,
                  totalPages: (data.totalEntries / LowStockCubit.pageSize).ceil().clamp(1, 999999),
                  totalEntries: data.totalEntries,
                  pageSize: LowStockCubit.pageSize,
                  onPageChanged: cubit.changePage,
                ),
        );
      },
    );
  }

  Future<void> _export(LowStockData data) async {
    setState(() => _exporting = true);
    try {
      await ReportExportService.exportCsv(
        fileNameWithoutExtension: 'low_stock',
        headers: const ['Product', 'Category', 'Current Stock', 'Minimum Stock', 'Supplier', 'Last Stock Entry'],
        rows: [
          for (final row in data.rows)
            [
              row.productName,
              row.category,
              row.currentStock.toStringAsFixed(0),
              row.minimumStock.toStringAsFixed(0),
              row.supplierName ?? '-',
              row.lastStockEntry == null ? '-' : _date(row.lastStockEntry!),
            ],
        ],
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

String _date(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${date.year}-${two(date.month)}-${two(date.day)}';
}
