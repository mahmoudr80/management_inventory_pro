  // lib/features/reports/presentation/screens/stock_movement_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/models/stock_movement_model.dart';
import '../../data/services/report_export_service.dart';
import '../cubit/base_report_state.dart';
import '../cubit/stock_movement_cubit.dart';
import '../widgets/report_breadcrumb.dart';
import '../widgets/report_chart_card.dart';
import '../widgets/report_data_table.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_pagination_bar.dart';
import '../widgets/report_status_pill.dart';
import '../widgets/report_summary_cards.dart';
import '../widgets/report_table_search_field.dart';
import '../widgets/report_workspace.dart';
import '../widgets/stock_movement_area_chart.dart';

class StockMovementScreen extends StatefulWidget {
  const StockMovementScreen({super.key});

  @override
  State<StockMovementScreen> createState() => _StockMovementScreenState();
}

class _StockMovementScreenState extends State<StockMovementScreen> {
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    context.read<StockMovementCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StockMovementCubit>();

    return BlocBuilder<StockMovementCubit, BaseReportState<StockMovementData>>(
      builder: (context, state) {
        final data = state.data;
        final isLoading = state.isLoading;

        return ReportWorkspace(
          title: 'Audit Trail',
          subtitle: 'Every stock in, out, and adjustment for the selected period.',
          breadcrumb: const ReportBreadcrumb(currentLabel: 'Stock Movement'),
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
              ReportSummaryCardData(
                label: 'Total Inbound',
                value: (data?.summary.totalInbound ?? 0).toStringAsFixed(0),
                icon: Icons.arrow_downward_rounded,
                valueColor: context.colors.success,
              ),
              ReportSummaryCardData(
                label: 'Total Outbound',
                value: (data?.summary.totalOutbound ?? 0).toStringAsFixed(0),
                icon: Icons.arrow_upward_rounded,
                valueColor: context.colors.error,
              ),
              ReportSummaryCardData(
                label: 'Total Adjustments',
                value: (data?.summary.totalAdjustments ?? 0).toStringAsFixed(0),
                icon: Icons.swap_horiz_rounded,
              ),
            ],
          ),
          chart: ReportChartCard(
            title: 'Movement Trend',
            isLoading: isLoading,
            isEmpty: (data?.trend ?? const []).isEmpty,
            child: StockMovementAreaChart(points: data?.trend ?? const []),
          ),
          table: ReportDataTable<StockMovementRow>(
            title: 'Movement Ledger',
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
              ReportTableColumn<StockMovementRow>(
                label: 'Date/Time',
                cellBuilder: (context, row) => Text(_dateTime(row.date), style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<StockMovementRow>(
                label: 'Product SKU',
                cellBuilder: (context, row) => Text(row.productSku, style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<StockMovementRow>(
                label: 'Type',
                cellBuilder: (context, row) => MovementTypePill(type: row.type),
              ),
              ReportTableColumn<StockMovementRow>(
                label: 'Qty',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text(
                  '${row.quantity > 0 ? '+' : ''}${row.quantity.toStringAsFixed(0)}',
                  style: AppTextStyles.dataMono.copyWith(
                    color: row.quantity >= 0 ? context.colors.success : context.colors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ReportTableColumn<StockMovementRow>(
                label: 'Ref ID',
                cellBuilder: (context, row) =>
                    Text(row.referenceId, style: AppTextStyles.dataMono.copyWith(color: context.colors.primary)),
              ),
              ReportTableColumn<StockMovementRow>(
                label: 'User',
                cellBuilder: (context, row) => Text(row.createdBy),
              ),
              ReportTableColumn<StockMovementRow>(
                label: 'Reason',
                cellBuilder: (context, row) => Text(row.reason ?? '-'),
              ),
            ],
          ),
          pagination: data == null
              ? null
              : ReportPaginationBar(
                  currentPage: cubit.currentPage,
                  totalPages: (data.totalEntries / StockMovementCubit.pageSize).ceil().clamp(1, 999999),
                  totalEntries: data.totalEntries,
                  pageSize: StockMovementCubit.pageSize,
                  onPageChanged: cubit.changePage,
                ),
        );
      },
    );
  }

  Future<void> _export(StockMovementData data) async {
    setState(() => _exporting = true);
    try {
      await ReportExportService.exportCsv(
        fileNameWithoutExtension: 'stock_movement',
        headers: const ['Date/Time', 'Product SKU', 'Type', 'Qty', 'Ref ID', 'User', 'Reason'],
        rows: [
          for (final row in data.rows)
            [
              _dateTime(row.date),
              row.productSku,
              row.type.name,
              row.quantity.toStringAsFixed(0),
              row.referenceId,
              row.createdBy,
              row.reason ?? '-',
            ],
        ],
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

String _dateTime(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${date.year}-${two(date.month)}-${two(date.day)} ${two(date.hour)}:${two(date.minute)}';
}
