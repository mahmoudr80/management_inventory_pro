// lib/features/reports/presentation/screens/supplier_purchases_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/datasource/supplier_purchases_local_datasource.dart';
import '../../data/models/supplier_purchases_model.dart';
import '../../data/services/report_export_service.dart';
import '../cubit/base_report_state.dart';
import '../cubit/supplier_purchases_cubit.dart';
import '../widgets/report_breadcrumb.dart';
import '../widgets/report_data_table.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_pagination_bar.dart';
import '../widgets/report_select_filter.dart';
import '../widgets/report_summary_cards.dart';
import '../widgets/report_table_search_field.dart';
import '../widgets/report_workspace.dart';

class SupplierPurchasesScreen extends StatefulWidget {
  const SupplierPurchasesScreen({super.key});

  @override
  State<SupplierPurchasesScreen> createState() => _SupplierPurchasesScreenState();
}

class _SupplierPurchasesScreenState extends State<SupplierPurchasesScreen> {
  bool _exporting = false;
  List<ReportSelectOption> _supplierOptions = const [];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SupplierPurchasesCubit>();
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
    final cubit = context.read<SupplierPurchasesCubit>();

    return BlocBuilder<SupplierPurchasesCubit, BaseReportState<SupplierPurchasesData>>(
      builder: (context, state) {
        final data = state.data;
        final isLoading = state.isLoading;

        return ReportWorkspace(
          title: 'Supplier Purchases',
          subtitle: 'Purchase volume and spend by supplier for the selected period.',
          breadcrumb: const ReportBreadcrumb(currentLabel: 'Supplier Purchases'),
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
                selectedValue: state.filters.extraValue(
                  SupplierPurchasesLocalDataSource.supplierFilterKey,
                ),
                options: _supplierOptions,
                onChanged: (value) => cubit.updateExtraFilter(
                  SupplierPurchasesLocalDataSource.supplierFilterKey,
                  value,
                ),
              ),
            ],
          ),
          summaryCards: ReportSummaryCards(
            cards: [
              ReportSummaryCardData(label: 'Purchase Cost', value: _money(data?.summary.purchaseCost ?? 0)),
              ReportSummaryCardData(label: 'Orders', value: '${data?.summary.orders ?? 0}'),
              ReportSummaryCardData(label: 'Products', value: '${data?.summary.products ?? 0}'),
            ],
          ),
          table: ReportDataTable<SupplierPurchasesRow>(
            title: 'Supplier Purchases',
            headerTrailing: ReportTableSearchField(
              hint: 'Search supplier...',
              onChanged: cubit.updateSearch,
            ),
            isLoading: isLoading,
            isError: state.isError,
            errorMessage: state.errorMessage,
            onRetry: cubit.refresh,
            rows: data?.rows ?? const [],
            columns: [
              ReportTableColumn<SupplierPurchasesRow>(
                label: 'Supplier',
                cellBuilder: (context, row) => Text(row.supplierName),
              ),
              ReportTableColumn<SupplierPurchasesRow>(
                label: 'Orders',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text('${row.orders}', style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<SupplierPurchasesRow>(
                label: 'Items',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) => Text('${row.items}', style: AppTextStyles.dataMono),
              ),
              ReportTableColumn<SupplierPurchasesRow>(
                label: 'Total Cost',
                align: ReportColumnAlign.right,
                cellBuilder: (context, row) =>
                    Text(_money(row.totalCost), style: AppTextStyles.dataMono.copyWith(fontWeight: FontWeight.w700)),
              ),
              ReportTableColumn<SupplierPurchasesRow>(
                label: 'Last Purchase',
                cellBuilder: (context, row) =>
                    Text(row.lastPurchase == null ? '-' : _date(row.lastPurchase!), style: AppTextStyles.dataMono),
              ),
            ],
          ),
          pagination: data == null
              ? null
              : ReportPaginationBar(
            currentPage: cubit.currentPage,
            totalPages: (data.totalEntries / SupplierPurchasesCubit.pageSize).ceil().clamp(1, 999999),
            totalEntries: data.totalEntries,
            pageSize: SupplierPurchasesCubit.pageSize,
            onPageChanged: cubit.changePage,
          ),
        );
      },
    );
  }

  Future<void> _export(SupplierPurchasesData data) async {
    setState(() => _exporting = true);
    try {
      await ReportExportService.exportCsv(
        fileNameWithoutExtension: 'supplier_purchases',
        headers: const ['Supplier', 'Orders', 'Items', 'Total Cost', 'Last Purchase'],
        rows: [
          for (final row in data.rows)
            [
              row.supplierName,
              '${row.orders}',
              '${row.items}',
              row.totalCost.toStringAsFixed(2),
              row.lastPurchase == null ? '-' : _date(row.lastPurchase!),
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

String _date(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${date.year}-${two(date.month)}-${two(date.day)}';
}