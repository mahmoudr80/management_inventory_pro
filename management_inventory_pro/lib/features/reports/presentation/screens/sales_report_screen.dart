import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/datasource/sales_report_local_datasource.dart';
import '../../data/models/sales_report_model.dart';
import '../../data/services/report_export_service.dart';
import '../../data/services/report_print_service.dart';
import '../cubit/base_report_state.dart';
import '../cubit/sales_report_cubit.dart';
import '../widgets/report_breadcrumb.dart';
import '../widgets/report_chart_card.dart';
import '../widgets/report_data_table.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_pagination_bar.dart';
import '../widgets/report_select_filter.dart';
import '../widgets/report_summary_cards.dart';
import '../widgets/report_table_search_field.dart';
import '../widgets/report_workspace.dart';

/// Phase 3 Part 4/5 changes vs. Part 1:
///  - Export is now a menu (current page vs. all filtered rows, CSV vs.
///    Excel) instead of a single CSV-current-page button — resolves the
///    "export current page vs. all filtered rows" question raised in
///    PHASE3_PART1_SUMMARY.md by offering both rather than picking one.
///  - Print button wired to the now-real [ReportPrintService].
/// This is the reference report for both changes — Profit, Inventory
/// Valuation, Low Stock, Out of Stock, Stock Movement, Supplier
/// Purchases, and Stock Adjustment History all get the identical
/// pattern (see the Phase 3 Part 4/5 wrap-up for the per-report export
/// column lists / print sections, since those differ by report while
/// the menu/button wiring itself does not).
class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

enum _ExportChoice { currentPageCsv, currentPageExcel, allCsv, allExcel }

class _SalesReportScreenState extends State<SalesReportScreen> {
  static const _columnKeys = <String?>[
    null, // Invoice ID
    'date',
    'cashier',
    null, // Payment Method
    null, // Subtotal
    null, // Discount
    null, // Tax
    'grandTotal',
    null, // Status
  ];

  static const _paymentMethodOptions = [
    ReportSelectOption(value: 'Cash', label: 'Cash'),
    ReportSelectOption(value: 'Credit', label: 'Credit'),
    ReportSelectOption(value: 'Wire', label: 'Wire'),
  ];

  static const _exportHeaders = [
    'Invoice ID',
    'Date & Time',
    'Cashier',
    'Payment Method',
    'Subtotal',
    'Discount',
    'Tax',
    'Grand Total',
    'Status',
  ];

  bool _exporting = false;
  bool _printing = false;

  @override
  void initState() {
    super.initState();
    context.read<SalesReportCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesReportCubit>();

    return BlocBuilder<SalesReportCubit, BaseReportState<SalesReportData>>(
      builder: (context, state) {
        final data = state.data;
        final isLoading = state.isLoading;

        return ReportWorkspace(
          title: 'Sales Report',
          subtitle: 'Revenue, orders, and transaction history for the selected period.',
          breadcrumb: const ReportBreadcrumb(currentLabel: 'Sales'),
          headerActions: [
            OutlinedButton.icon(
              onPressed: isLoading ? null : cubit.refresh,
              icon: const Icon(Icons.refresh, size: AppIconSize.sm),
              label: const Text('Refresh'),
            ),
            const SizedBox(width: AppSpacing.sm),
            PopupMenuButton<_ExportChoice>(
              enabled: data != null && !_exporting,
              tooltip: 'Export',
              onSelected: (choice) => _handleExport(choice, cubit, state.filters, data!),
              itemBuilder: (context) => const [
                PopupMenuItem(value: _ExportChoice.currentPageCsv, child: Text('Export current page (CSV)')),
                PopupMenuItem(value: _ExportChoice.currentPageExcel, child: Text('Export current page (Excel)')),
                PopupMenuDivider(),
                PopupMenuItem(value: _ExportChoice.allCsv, child: Text('Export all filtered rows (CSV)')),
                PopupMenuItem(value: _ExportChoice.allExcel, child: Text('Export all filtered rows (Excel)')),
              ],
              child: OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.download_outlined, size: AppIconSize.sm),
                label: Text(_exporting ? 'Exporting…' : 'Export'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: data == null || _printing ? null : () => _print(data),
              icon: const Icon(Icons.print_outlined, size: AppIconSize.sm),
              label: Text(_printing ? 'Preparing…' : 'Print'),
            ),
          ],
          filterBar: ReportFilterBar(
            selectedRange: state.filters.dateRange,
            onDateRangeChanged: cubit.updateDateRange,
            onRefresh: cubit.refresh,
            onReset: cubit.resetFilters,
            trailing: [
              ReportSelectFilter(
                label: 'Payment Methods',
                selectedValue: state.filters.extraValue(
                  SalesReportLocalDataSource.paymentMethodFilterKey,
                ),
                options: _paymentMethodOptions,
                onChanged: (value) => cubit.updateExtraFilter(
                  SalesReportLocalDataSource.paymentMethodFilterKey,
                  value,
                ),
              ),
            ],
          ),
          summaryCards: ReportSummaryCards(
            cards: [
              // TODO(delta-wiring): reference UI (Image 3) shows a colored
              // trend pill (↑12%, ↑5%, ↓2%) on these three cards. Wiring
              // real values needs a period-over-period delta on
              // SalesReportSummary (e.g. `revenueDeltaPercent`,
              // `ordersDeltaPercent`, `averageOrderDeltaPercent`) that
              // doesn't exist on the model yet — `_deltaLabel`/
              // `_deltaPositive` below are stubs returning null until
              // that field is added, so this compiles but the pills
              // won't render until then.
              ReportSummaryCardData(
                label: 'Total Revenue',
                value: _money(data?.summary.revenue ?? 0),
                delta: _deltaLabel(null),
                deltaPositive: _deltaPositive(null),
              ),
              ReportSummaryCardData(
                label: 'Orders',
                value: '${data?.summary.orders ?? 0}',
                delta: _deltaLabel(null),
                deltaPositive: _deltaPositive(null),
              ),
              ReportSummaryCardData(
                label: 'Avg. Order Value',
                value: _money(data?.summary.averageOrder ?? 0),
                delta: _deltaLabel(null),
                deltaPositive: _deltaPositive(null),
              ),
              ReportSummaryCardData(
                label: 'Gross Profit',
                value: _money(data?.summary.profit ?? 0),
                valueColor: context.colors.success,
              ),
              ReportSummaryCardData(label: 'Tax Collected', value: _money(data?.summary.tax ?? 0)),
            ],
          ),
          chart: ReportChartCard(
            title: 'Revenue Trend',
            isLoading: isLoading,
            isEmpty: (data?.trend ?? const []).isEmpty,
            // Reference (code.html lines 320-335) shows a legend
            // ("● Revenue  ● Profit") to the right of the chart title.
            // ReportChartCard already had a `trailing` slot for exactly
            // this — it was just never used here.
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LegendDot(color: context.colors.primary, label: 'Revenue'),
                const SizedBox(width: AppSpacing.md),
                _LegendDot(color: context.colors.outlineVariant, label: 'Profit'),
              ],
            ),
            child: _RevenueTrendChart(points: data?.trend ?? const []),
          ),
          table: ReportDataTable<SalesReportRow>(
            title: 'Transaction Log',
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
            // Reference (code.html line 344) puts search inside the table
            // header ("Filter invoices...") rather than the filter bar.
            headerTrailing: ReportTableSearchField(
              hint: 'Filter invoices...',
              onChanged: cubit.updateSearch,
            ),
            // Reference's refund row (Image 3, INV-24-005) gets a tinted
            // background + left accent border. rowStyleBuilder is the
            // generic hook added to ReportDataTable for exactly this.
            rowStyleBuilder: (context, row) {
              final normalized = row.status.toLowerCase();
              if (normalized != 'refunded' && normalized != 'cancelled') return null;
              return DataRowStyle(
                backgroundColor: context.colors.errorContainer.withOpacity(0.2),
                leftBorderColor: context.colors.error,
              );
            },
            columns: [
              ReportTableColumn<SalesReportRow>(
                label: 'Invoice ID',
                cellBuilder: (context, row) => Text(
                  row.invoiceId,
                  style: AppTextStyles.dataMono.copyWith(color: context.colors.primary),
                ),
              ),
              ReportTableColumn<SalesReportRow>(
                label: 'Date & Time',
                sortable: true,
                cellBuilder: (context, row) => Text(_dateTime(row.date), style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<SalesReportRow>(
                label: 'Cashier',
                sortable: true,
                cellBuilder: (context, row) => Text(row.cashier),
              ),
              ReportTableColumn<SalesReportRow>(
                label: 'Payment Method',
                cellBuilder: (context, row) => _MethodPill(method: row.paymentMethod),
              ),
              ReportTableColumn<SalesReportRow>(
                label: 'Subtotal',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text(_money(row.subtotal), style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<SalesReportRow>(
                label: 'Discount',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text(
                  row.discount == 0 ? '-' : '-${_money(row.discount)}',
                  style: AppTextStyles.dataMono.copyWith(
                    color: row.discount == 0 ? context.colors.textSecondary : context.colors.error,
                  ),
                ),
              ),
              ReportTableColumn<SalesReportRow>(
                label: 'Tax',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text(_money(row.tax), style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<SalesReportRow>(
                label: 'Grand Total',
                align: ReportColumnAlign.right,
                sortable: true,
                cellBuilder: (context, row) => Text(
                  _money(row.grandTotal),
                  style: AppTextStyles.dataMono.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              ReportTableColumn<SalesReportRow>(
                label: 'Status',
                align: ReportColumnAlign.center,
                cellBuilder: (context, row) => _StatusPill(status: row.status),
              ),
            ],
          ),
          pagination: data == null
              ? null
              : ReportPaginationBar(
                  currentPage: cubit.currentPage,
                  totalPages: (data.totalEntries / SalesReportCubit.pageSize).ceil().clamp(1, 999999),
                  totalEntries: data.totalEntries,
                  pageSize: SalesReportCubit.pageSize,
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

  List<List<String>> _rowsToExport(SalesReportRow row) => [
        [
          row.invoiceId,
          _dateTime(row.date),
          row.cashier,
          row.paymentMethod,
          row.subtotal.toStringAsFixed(2),
          row.discount.toStringAsFixed(2),
          row.tax.toStringAsFixed(2),
          row.grandTotal.toStringAsFixed(2),
          row.status,
        ],
      ];

  Future<void> _handleExport(
    _ExportChoice choice,
    SalesReportCubit cubit,
    dynamic filters,
    SalesReportData currentPageData,
  ) async {
    setState(() => _exporting = true);
    try {
      final bool wantsAll = choice == _ExportChoice.allCsv || choice == _ExportChoice.allExcel;
      final bool wantsExcel = choice == _ExportChoice.currentPageExcel || choice == _ExportChoice.allExcel;

      final rows = wantsAll
          ? await cubit.repository.fetchAllRows(
              filters,
              sortColumn: cubit.sortColumn,
              sortAscending: cubit.sortAscending,
            )
          : currentPageData.rows;

      final flatRows = [for (final row in rows) ..._rowsToExport(row)];
      final fileName = wantsAll ? 'sales_report_all' : 'sales_report_page_${cubit.currentPage}';

      if (wantsExcel) {
        await ReportExportService.exportExcel(
          fileNameWithoutExtension: fileName,
          sheetName: 'Sales Report',
          headers: _exportHeaders,
          rows: flatRows,
        );
      } else {
        await ReportExportService.exportCsv(
          fileNameWithoutExtension: fileName,
          headers: _exportHeaders,
          rows: flatRows,
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _print(SalesReportData data) async {
    setState(() => _printing = true);
    try {
      await ReportPrintService.printReport(
        PrintableReport(
          title: 'Sales Report',
          subtitle: 'Revenue, orders, and transaction history for the selected period.',
          sections: [
            PrintableSummaryCards([
              ('Total Revenue', _money(data.summary.revenue)),
              ('Orders', '${data.summary.orders}'),
              ('Avg. Order Value', _money(data.summary.averageOrder)),
              ('Gross Profit', _money(data.summary.profit)),
              ('Tax Collected', _money(data.summary.tax)),
            ]),
            PrintableTable(
              title: 'Transaction Log (current page)',
              headers: _exportHeaders,
              rows: [for (final row in data.rows) ..._rowsToExport(row)],
            ),
          ],
        ),
      );
    } on PrintingNotAvailableException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Printing will be available soon.')),
        );
      }
    } finally {
      if (mounted) setState(() => _printing = false);
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

String _dateTime(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${date.year}-${two(date.month)}-${two(date.day)} ${two(date.hour)}:${two(date.minute)}';
}

/// Stub — see the TODO on the summary cards above. Returns null (no pill
/// rendered) until `SalesReportSummary` has a real delta field to read.
String? _deltaLabel(double? percent) => percent == null ? null : '${percent.abs().toStringAsFixed(0)}%';

/// Companion to [_deltaLabel].
bool? _deltaPositive(double? percent) => percent == null ? null : percent >= 0;

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTextStyles.bodySm.copyWith(color: context.colors.textSecondary)),
      ],
    );
  }
}

class _MethodPill extends StatelessWidget {
  final String method;
  const _MethodPill({required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(method, style: AppTextStyles.bodySm.copyWith(color: context.colors.textPrimary)),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final Color bg;
    final Color fg;
    if (normalized == 'completed') {
      bg = context.colors.statusHealthyBg;
      fg = context.colors.statusHealthyFg;
    } else if (normalized == 'refunded' || normalized == 'cancelled') {
      bg = context.colors.statusCancelledBg;
      fg = context.colors.statusCancelledFg;
    } else {
      bg = context.colors.statusPendingBg;
      fg = context.colors.statusPendingFg;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(status, style: AppTextStyles.labelCaps.copyWith(color: fg, letterSpacing: 0)),
    );
  }
}

/// Unchanged from prior parts — dependency-free CustomPainter, still not
/// swapped for fl_chart (confirmed still not a pubspec dependency).
class _RevenueTrendChart extends StatelessWidget {
  final List<SalesTrendPoint> points;
  const _RevenueTrendChart({required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    return CustomPaint(
      size: Size.infinite,
      painter: _TrendPainter(
        points: points,
        revenueColor: context.colors.primary,
        profitColor: context.colors.outline,
        gridColor: context.colors.outlineVariant,
        labelColor: context.colors.textSecondary,
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  final List<SalesTrendPoint> points;
  final Color revenueColor;
  final Color profitColor;
  final Color gridColor;
  final Color labelColor;

  // Left gutter reserved for the Y-axis value labels, bottom gutter for
  // the W1/W2/.../week labels — matches the reference's grid (code.html
  // lines 328-336: "150k/100k/50k/0" down the left edge, "W1..W4" along
  // the bottom).
  static const _leftGutter = 36.0;
  static const _bottomGutter = 18.0;

  _TrendPainter({
    required this.points,
    required this.revenueColor,
    required this.profitColor,
    required this.gridColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue =
        points.expand((p) => [p.revenue, p.profit]).fold<double>(0, (max, v) => v > max ? v : max);
    final safeMax = maxValue <= 0 ? 1 : maxValue;

    final plotWidth = size.width - _leftGutter;
    final plotHeight = size.height - _bottomGutter;

    final labelStyle = TextStyle(color: labelColor, fontSize: 10, fontFamily: 'JetBrainsMono');

    void drawLabel(String text, Offset topLeft) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, topLeft);
    }

    // Horizontal gridlines + Y-axis value labels (0 / 1/3 max / 2/3 max / max).
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = plotHeight * (i / 3);
      canvas.drawLine(Offset(_leftGutter, y), Offset(size.width, y), gridPaint);
      final value = safeMax * (1 - i / 3);
      drawLabel(_shortValue(value), Offset(0, y - 6));
    }

    // X-axis week labels, evenly spaced under the plot area. Uses a
    // generated "W1"/"W2"/... index label rather than reading a field off
    // SalesTrendPoint — I don't have that model's source, so I can't
    // confirm whether it already carries a period label (e.g. a real
    // date-range string). If it does, swap this for `points[i].label`
    // (or whatever the actual field is named).
    for (var i = 0; i < points.length; i++) {
      final x = points.length == 1
          ? _leftGutter
          : _leftGutter + plotWidth * (i / (points.length - 1));
      drawLabel('W${i + 1}', Offset(x - 8, plotHeight + 4));
    }

    void drawSeries(List<double> values, Color color, {required bool filled}) {
      final linePath = Path();
      final fillPath = Path();
      for (var i = 0; i < values.length; i++) {
        final x = values.length == 1 ? _leftGutter : _leftGutter + plotWidth * (i / (values.length - 1));
        final y = plotHeight - (values[i] / safeMax) * plotHeight;
        if (i == 0) {
          linePath.moveTo(x, y);
          fillPath.moveTo(x, plotHeight);
          fillPath.lineTo(x, y);
        } else {
          linePath.lineTo(x, y);
          fillPath.lineTo(x, y);
        }
      }
      if (filled && values.isNotEmpty) {
        fillPath.lineTo(_leftGutter + plotWidth, plotHeight);
        fillPath.close();
        canvas.drawPath(fillPath, Paint()..color = color.withOpacity(0.1));
      }
      canvas.drawPath(
        linePath,
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }

    // Reference fills only under the Revenue line, not Profit (code.html's
    // gradient path is a single fill under the top series).
    drawSeries(points.map((p) => p.revenue).toList(), revenueColor, filled: true);
    drawSeries(points.map((p) => p.profit).toList(), profitColor, filled: false);
  }

  String _shortValue(double value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}k';
    return value.toStringAsFixed(0);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) => oldDelegate.points != points;
}
