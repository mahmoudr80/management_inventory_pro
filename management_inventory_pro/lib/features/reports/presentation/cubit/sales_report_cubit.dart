import '../../data/models/report_date_range.dart';
import '../../data/models/report_filter_state.dart';
import '../../data/models/sales_report_model.dart';
import '../../data/repository/sales_report_repository.dart';
import 'base_report_cubit.dart';
import 'base_report_state.dart';

/// Adds pagination + sorting on top of [BaseReportCubit]'s load/refresh/
/// filter flow. Page/sort are deliberately kept as plain cubit fields
/// (not part of the emitted [BaseReportState]) so `BaseReportState<T>
/// .copyWith` — which only knows about status/filters/data/errorMessage —
/// never has to change to support them.
///
/// Phase 3 Part 4 (Performance) change: [changePage] and [changeSort] no
/// longer call the full three-query [fetchData] — they call
/// [SalesReportRepository.fetchRows] directly and splice the result into
/// a cached summary/trend, since neither depends on page or sort. This
/// was flagged as a known trade-off since Section 2 ("re-runs
/// summary+trend on every page click") and is the actual fix, not just
/// an index (indexes make the redundant queries cheaper; this removes
/// them). A filter change (date range / search / payment method) still
/// goes through the full [fetchData] via [BaseReportCubit]'s
/// updateDateRange/updateSearch/updateExtraFilter, since those genuinely
/// do change the summary and trend.
class SalesReportCubit extends BaseReportCubit<SalesReportData> {
  final SalesReportRepository repository;

  SalesReportCubit(this.repository);

  static const pageSize = 20;

  int _page = 1;
  String? _sortColumn;
  bool _sortAscending = true;

  int get currentPage => _page;
  String? get sortColumn => _sortColumn;
  bool get sortAscending => _sortAscending;

  // Perf cache: summary + trend are the expensive multi-join aggregates.
  // Cached alongside the exact filter state they were computed for, so a
  // stale cache (e.g. after a filter change fired concurrently) is never
  // silently reused — `_cachedForFilters != state.filters` falls back to
  // a full reload rather than showing summary/trend for the wrong query.
  SalesReportSummary? _cachedSummary;
  List<SalesTrendPoint>? _cachedTrend;
  ReportFilterState? _cachedForFilters;

  @override
  Future<SalesReportData> fetchData(ReportFilterState filters) async {
    final data = await repository.fetch(
      filters,
      page: _page,
      pageSize: pageSize,
      sortColumn: _sortColumn,
      sortAscending: _sortAscending,
    );
    _cachedSummary = data.summary;
    _cachedTrend = data.trend;
    _cachedForFilters = filters;
    return data;
  }

  @override
  bool isEmptyResult(SalesReportData data) => data.rows.isEmpty;

  /// Row-only reload used by [changePage]/[changeSort]. Falls back to a
  /// full [load] whenever there's no usable cache — first load, or a
  /// filter changed since the cache was populated.
  Future<void> _reloadRowsOnly() async {
    final summary = _cachedSummary;
    final trend = _cachedTrend;
    if (summary == null || trend == null || _cachedForFilters != state.filters) {
      await load();
      return;
    }

    emit(state.copyWith(status: ReportStatus.loading));
    try {
      final (rows, totalEntries) = await repository.fetchRows(
        state.filters,
        page: _page,
        pageSize: pageSize,
        sortColumn: _sortColumn,
        sortAscending: _sortAscending,
      );
      final data = SalesReportData(summary: summary, trend: trend, rows: rows, totalEntries: totalEntries);
      emit(state.copyWith(
        status: rows.isEmpty ? ReportStatus.empty : ReportStatus.loaded,
        data: data,
      ));
    } catch (e) {
      emit(state.copyWith(status: ReportStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> changePage(int page) async {
    _page = page;
    await _reloadRowsOnly();
  }

  Future<void> changeSort(String column) async {
    if (_sortColumn == column) {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumn = column;
      _sortAscending = true;
    }
    _page = 1;
    await _reloadRowsOnly();
  }

  @override
  Future<void> updateDateRange(ReportDateRange dateRange) async {
    _page = 1;
    await super.updateDateRange(dateRange);
  }

  @override
  Future<void> updateSearch(String query) async {
    _page = 1;
    await super.updateSearch(query);
  }

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
