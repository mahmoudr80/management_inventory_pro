import '../../data/models/profit_report_model.dart';
import '../../data/models/report_date_range.dart';
import '../../data/models/report_filter_state.dart';
import '../../data/repository/profit_report_repository.dart';
import 'base_report_cubit.dart';

class ProfitReportCubit extends BaseReportCubit<ProfitReportData> {
  final ProfitReportRepository repository;

  ProfitReportCubit(this.repository);

  static const pageSize = 20;

  int _page = 1;
  String? _sortColumn;
  bool _sortAscending = true;

  int get currentPage => _page;
  String? get sortColumn => _sortColumn;
  bool get sortAscending => _sortAscending;

  @override
  Future<ProfitReportData> fetchData(ReportFilterState filters) {
    return repository.fetch(
      filters,
      page: _page,
      pageSize: pageSize,
      sortColumn: _sortColumn,
      sortAscending: _sortAscending,
    );
  }

  @override
  bool isEmptyResult(ProfitReportData data) => data.rows.isEmpty;

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
  Future<void> updateDateRange(ReportDateRange dateRange) async {
    _page = 1;
    await super.updateDateRange(dateRange);
  }

  @override
  Future<void> updateExtraFilter(String key, String? value) async {
    _page = 1;
    await super.updateExtraFilter(key, value);
  }

  @override
  Future<void> updateSearch(String query) async {
    _page = 1;
    await super.updateSearch(query);
  }

  @override
  Future<void> resetFilters() async {
    _page = 1;
    _sortColumn = null;
    _sortAscending = true;
    await super.resetFilters();
  }
}
