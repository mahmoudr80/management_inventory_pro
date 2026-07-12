import '../models/report_filter_state.dart';

/// Contract every concrete report repository implements (a future
/// SalesReportRepository, ProfitReportRepository, ...). Deliberately a
/// single method — repositories differ mainly in what [T] is, not in
/// shape — so [BaseReportCubit] can stay datasource-agnostic.
abstract class ReportRepository<T> {
  /// [page]/[pageSize] are part of the base contract (not left to each
  /// subclass to add ad hoc) so code holding the `ReportRepository<T>`
  /// interface type — not a concrete repository — can still paginate.
  /// Sorting isn't included here since not every report is sortable;
  /// implementations that support it add `sortColumn`/`sortAscending`
  /// as additional optional params, which Dart allows on an override.
  Future<T> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
  });
}
