import '../datasource/sales_report_local_datasource.dart';
import '../models/report_filter_state.dart';
import '../models/sales_report_model.dart';
import 'report_repository.dart';

class SalesReportRepository implements ReportRepository<SalesReportData> {
  final SalesReportLocalDataSource dataSource;

  SalesReportRepository(this.dataSource);

  /// Satisfies [ReportRepository]'s single-argument contract while adding
  /// the pagination/sort params [SalesReportCubit] needs — Dart allows
  /// widening an override with extra optional parameters, so
  /// `repository.fetch(filters)` (as the Phase 1 interface promises)
  /// still works unchanged for any caller that doesn't care about paging.
  @override
  Future<SalesReportData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
    String? sortColumn,
    bool sortAscending = true,
  }) {
    return dataSource.fetch(
      filters,
      page: page,
      pageSize: pageSize,
      sortColumn: sortColumn,
      sortAscending: sortAscending,
    );
  }

  /// Phase 3 Part 4 (Performance) addition — forwards to the datasource's
  /// row-only query, used by the cubit on page/sort changes so the
  /// summary + trend aggregates aren't re-run for no reason.
  Future<(List<SalesReportRow>, int)> fetchRows(
    ReportFilterState filters, {
    required int page,
    required int pageSize,
    String? sortColumn,
    bool sortAscending = true,
  }) {
    return dataSource.fetchRows(
      filters,
      page: page,
      pageSize: pageSize,
      sortColumn: sortColumn,
      sortAscending: sortAscending,
    );
  }

  /// Phase 3 Part 4/5 addition — backs "Export all filtered rows".
  Future<List<SalesReportRow>> fetchAllRows(
    ReportFilterState filters, {
    String? sortColumn,
    bool sortAscending = true,
  }) {
    return dataSource.fetchAllRows(filters, sortColumn: sortColumn, sortAscending: sortAscending);
  }

  Future<List<(String value, String label)>> fetchProductOptions() => dataSource.fetchProductOptions();

}
