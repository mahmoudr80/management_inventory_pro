// lib/features/reports/presentation/screens/out_of_stock_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/datasource/out_of_stock_local_datasource.dart';
import '../../data/models/out_of_stock_model.dart';
import '../../data/services/report_export_service.dart';
import '../cubit/base_report_state.dart';
import '../cubit/out_of_stock_cubit.dart';
import '../widgets/report_breadcrumb.dart';
import '../widgets/report_data_table.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_pagination_bar.dart';
import '../widgets/report_select_filter.dart';
import '../widgets/report_summary_cards.dart';
import '../widgets/report_table_search_field.dart';
import '../widgets/report_workspace.dart';

/// No chart, per the Phase 2 spec ("Out Of Stock: No chart.").
class OutOfStockScreen extends StatefulWidget {
  const OutOfStockScreen({super.key});

  @override
  State<OutOfStockScreen> createState() => _OutOfStockScreenState();
}

class _OutOfStockScreenState extends State<OutOfStockScreen> {
  bool _exporting = false;
  List<ReportSelectOption> _supplierOptions = const [];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<OutOfStockCubit>();
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
    final cubit = context.read<OutOfStockCubit>();

    return BlocBuilder<OutOfStockCubit, BaseReportState<OutOfStockData>>(
      builder: (context, state) {
        final data = state.data;
        final isLoading = state.isLoading;

        return ReportWorkspace(
          title: 'Out of Stock',
          subtitle: 'Products with zero current stock.',
          breadcrumb: const ReportBreadcrumb(currentLabel: 'Out of Stock'),
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
                selectedValue: state.filters.extraValue(OutOfStockLocalDataSource.supplierFilterKey),
                options: _supplierOptions,
                onChanged: (value) =>
                    cubit.updateExtraFilter(OutOfStockLocalDataSource.supplierFilterKey, value),
              ),
            ],
          ),
          summaryCards: ReportSummaryCards(
            cards: [
              ReportSummaryCardData(
                label: 'Out of Stock Products',
                value: '${data?.summary.outOfStockCount ?? 0}',
                icon: Icons.error_outline_rounded,
                valueColor: context.colors.error,
              ),
            ],
          ),
          table: ReportDataTable<OutOfStockRow>(
            title: 'Out of Stock Products',
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
              ReportTableColumn<OutOfStockRow>(
                label: 'Product',
                cellBuilder: (context, row) => Text(row.productName),
              ),
              ReportTableColumn<OutOfStockRow>(
                label: 'Category',
                cellBuilder: (context, row) => Text(row.category),
              ),
              ReportTableColumn<OutOfStockRow>(
                label: 'Supplier',
                cellBuilder: (context, row) => Text(row.supplierName ?? '-'),
              ),
              ReportTableColumn<OutOfStockRow>(
                label: 'Last Sale',
                cellBuilder: (context, row) => Text(row.lastSale == null ? 'Never' : _date(row.lastSale!), style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<OutOfStockRow>(
                label: 'Days Out of Stock',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text(
                  '${row.daysOutOfStock}',
                  style: AppTextStyles.dataMono.copyWith(color: context.colors.error, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          pagination: data == null
              ? null
              : ReportPaginationBar(
                  currentPage: cubit.currentPage,
                  totalPages: (data.totalEntries / OutOfStockCubit.pageSize).ceil().clamp(1, 999999),
                  totalEntries: data.totalEntries,
                  pageSize: OutOfStockCubit.pageSize,
                  onPageChanged: cubit.changePage,
                ),
        );
      },
    );
  }

  Future<void> _export(OutOfStockData data) async {
    setState(() => _exporting = true);
    try {
      await ReportExportService.exportCsv(
        fileNameWithoutExtension: 'out_of_stock',
        headers: const ['Product', 'Category', 'Supplier', 'Last Sale', 'Days Out of Stock'],
        rows: [
          for (final row in data.rows)
            [
              row.productName,
              row.category,
              row.supplierName ?? '-',
              row.lastSale == null ? 'Never' : _date(row.lastSale!),
              '${row.daysOutOfStock}',
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
