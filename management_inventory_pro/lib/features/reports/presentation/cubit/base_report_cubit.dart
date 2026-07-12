import 'package:bloc/bloc.dart';
import '../../data/models/report_date_range.dart';
import '../../data/models/report_filter_state.dart';
import 'base_report_state.dart';

/// Shared load/refresh/reset flow for every report. Concrete cubits
/// (SalesReportCubit, ProfitReportCubit, ...) only implement [fetchData]
/// — typically by delegating to a [ReportRepository] — and optionally
/// [isEmptyResult] to define what "nothing to show" means for their
/// payload.
abstract class BaseReportCubit<T> extends Cubit<BaseReportState<T>> {
  BaseReportCubit() : super(BaseReportState<T>.initial(ReportFilterState.initial()));

  Future<T> fetchData(ReportFilterState filters);


  /// Whether [data] should be treated as "nothing to show" (e.g. zero
  /// table rows) rather than a normal loaded state. Defaults to false so
  /// reports that always render (even with zeroed summary cards) don't
  /// have to override it.
  bool isEmptyResult(T data) => false;
  bool get supportsDateRange => true;


  Future<void> load() async {
    emit(state.copyWith(status: ReportStatus.loading));
    try {
      final result = await fetchData(state.filters);
      emit(state.copyWith(
        status: isEmptyResult(result) ? ReportStatus.empty : ReportStatus.loaded,
        data: result,
      ));
    } catch (e) {
      emit(state.copyWith(status: ReportStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> refresh() => load();

  Future<void> updateDateRange(ReportDateRange dateRange) async {
    emit(state.copyWith(filters: state.filters.copyWith(dateRange: dateRange)));
    await load();
  }

  Future<void> updateSearch(String query) async {
    emit(state.copyWith(filters: state.filters.copyWith(searchQuery: query)));
    await load();
  }

  /// Phase 3 addition. Sets (or clears, if [value] is null) a single
  /// "Professional Filter" — Payment Method, Category, Supplier, Product
  /// — without a per-report cubit override. A report that doesn't use a
  /// given key simply never calls this with it, and its datasource never
  /// reads that key from `filters.extra`.
  Future<void> updateExtraFilter(String key, String? value) async {
    emit(state.copyWith(filters: state.filters.withExtra(key, value)));
    await load();
  }

  Future<void> resetFilters() async {
    emit(state.copyWith(filters: ReportFilterState.initial()));
    await load();
  }
}
