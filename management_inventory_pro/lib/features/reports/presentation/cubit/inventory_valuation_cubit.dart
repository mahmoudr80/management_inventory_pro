// lib/features/reports/presentation/cubit/inventory_valuation_cubit.dart
import '../../data/models/inventory_valuation_model.dart';
import '../../data/models/report_filter_state.dart';
import '../../data/repository/inventory_valuation_repository.dart';
import 'base_report_cubit.dart';

/// Point-in-time report — [updateDateRange] is overridden as a no-op
/// forward to `load()` (skipping the base class's filter-state mutation)
/// since [InventoryValuationLocalDataSource] never reads dateRange. Kept
/// as an override rather than removing the control from the UI, so this
/// cubit still satisfies [BaseReportCubit]'s full contract and the shared
/// [ReportFilterBar] doesn't need a per-report "supports date range" flag.
class InventoryValuationCubit extends BaseReportCubit<InventoryValuationData> {
  final InventoryValuationRepository repository;

  InventoryValuationCubit(this.repository);

  static const pageSize = 20;

  /// Point-in-time report — see BaseReportCubit.supportsDateRange.
  @override
  bool get supportsDateRange => false;

  int _page = 1;
  String? _sortColumn;
  bool _sortAscending = true;

  int get currentPage => _page;
  String? get sortColumn => _sortColumn;
  bool get sortAscending => _sortAscending;

  @override
  Future<InventoryValuationData> fetchData(ReportFilterState filters) {
    return repository.fetch(
      filters,
      page: _page,
      pageSize: pageSize,
      sortColumn: _sortColumn,
      sortAscending: _sortAscending,
    );
  }

  @override
  bool isEmptyResult(InventoryValuationData data) => data.rows.isEmpty;

  Future<void> changePage(int page) async {
    _page = page;
    await load();
  }

  Future<void> changeSort(String column) async {
    if (_sortColumn == column) {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumn = column;
      _sortAscending = true;
    }
    _page = 1;
    await load();
  }

  @override
  Future<void> updateSearch(String query) async {
    _page = 1;
    await super.updateSearch(query);
  }

  // Phase 3 addition — same "reset to page 1" reasoning as
  // SalesReportCubit's override: changing the Category filter changes
  // the result set size, so staying on the current page number could
  // point past the end.
  @override
  Future<void> updateExtraFilter(String key, String? value) async {
    _page = 1;
    await super.updateExtraFilter(key, value);
  }

  @override
  Future<void> resetFilters() async {
    _page = 1;
    _sortColumn = null;
    _sortAscending = true;
    await super.resetFilters();
  }
}
