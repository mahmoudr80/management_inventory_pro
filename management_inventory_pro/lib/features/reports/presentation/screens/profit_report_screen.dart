// lib/features/reports/presentation/screens/profit_report_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/models/profit_report_model.dart';
import '../../data/services/report_export_service.dart';
import '../cubit/base_report_state.dart';
import '../cubit/profit_report_cubit.dart';
import '../widgets/report_breadcrumb.dart';
import '../widgets/report_data_table.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_pagination_bar.dart';
import '../widgets/report_summary_cards.dart';
import '../widgets/report_table_search_field.dart';
import '../widgets/report_workspace.dart';

class ProfitReportScreen extends StatefulWidget {
  const ProfitReportScreen({super.key});

  @override
  State<ProfitReportScreen> createState() => _ProfitReportScreenState();
}

class _ProfitReportScreenState extends State<ProfitReportScreen> {
  static const _columnKeys = <String?>[null, 'revenue', 'cost', 'profit', null];

  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfitReportCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfitReportCubit>();

    return BlocBuilder<ProfitReportCubit, BaseReportState<ProfitReportData>>(
      builder: (context, state) {
        final data = state.data;
        final isLoading = state.isLoading;

        return ReportWorkspace(
          title: 'Profit Report',
          subtitle: 'Margin analysis per invoice for the selected period.',
          breadcrumb: const ReportBreadcrumb(currentLabel: 'Profit Report'),
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
              ReportSummaryCardData(label: 'Revenue', value: _money(data?.summary.revenue ?? 0)),
              ReportSummaryCardData(label: 'Cost', value: _money(data?.summary.cost ?? 0)),
              ReportSummaryCardData(
                label: 'Profit',
                value: _money(data?.summary.profit ?? 0),
                valueColor: context.colors.success,
              ),
              ReportSummaryCardData(
                label: 'Profit Margin',
                value: '${(data?.summary.marginPercent ?? 0).toStringAsFixed(1)}%',
              ),
            ],
          ),
          table: ReportDataTable<ProfitReportRow>(
            title: 'Profit by Invoice',
            headerTrailing: ReportTableSearchField(
              hint: 'Search invoice #...',
              onChanged: cubit.updateSearch,
            ),
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
              ReportTableColumn<ProfitReportRow>(
                label: 'Invoice',
                cellBuilder: (context, row) => Text(
                  row.invoiceId,
                  style: AppTextStyles.dataMono.copyWith(color: context.colors.primary),
                ),
              ),
              ReportTableColumn<ProfitReportRow>(
                label: 'Revenue',
                align: ReportColumnAlign.right,
                sortable: true,
                cellBuilder: (context, row) => Text(_money(row.revenue), style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<ProfitReportRow>(
                label: 'Cost',
                align: ReportColumnAlign.right,
                sortable: true,
                cellBuilder: (context, row) => Text(_money(row.cost), style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<ProfitReportRow>(
                label: 'Profit',
                align: ReportColumnAlign.right,
                sortable: true,
                cellBuilder: (context, row) => Text(
                  _money(row.profit),
                  style: AppTextStyles.dataMono.copyWith(
                    color: row.profit >= 0 ? context.colors.success : context.colors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ReportTableColumn<ProfitReportRow>(
                label: 'Margin',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text(
                  '${row.marginPercent.toStringAsFixed(1)}%',
                  style: AppTextStyles.dataMono,
                ),
              ),
            ],
          ),
          pagination: data == null
              ? null
              : ReportPaginationBar(
                  currentPage: cubit.currentPage,
                  totalPages: (data.totalEntries / ProfitReportCubit.pageSize).ceil().clamp(1, 999999),
                  totalEntries: data.totalEntries,
                  pageSize: ProfitReportCubit.pageSize,
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

  Future<void> _export(ProfitReportData data) async {
    setState(() => _exporting = true);
    try {
      await ReportExportService.exportCsv(
        fileNameWithoutExtension: 'profit_report',
        headers: const ['Invoice', 'Revenue', 'Cost', 'Profit', 'Margin'],
        rows: [
          for (final row in data.rows)
            [
              row.invoiceId,
              row.revenue.toStringAsFixed(2),
              row.cost.toStringAsFixed(2),
              row.profit.toStringAsFixed(2),
              '${row.marginPercent.toStringAsFixed(1)}%',
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
