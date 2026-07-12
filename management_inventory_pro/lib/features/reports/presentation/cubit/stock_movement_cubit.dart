import '../../data/models/report_date_range.dart';
import '../../data/models/report_filter_state.dart';
import '../../data/models/stock_movement_model.dart';
import '../../data/repository/stock_movement_repository.dart';
import 'base_report_cubit.dart';

class StockMovementCubit extends BaseReportCubit<StockMovementData> {
  final StockMovementRepository repository;

  StockMovementCubit(this.repository);

  static const pageSize = 20;

  int _page = 1;
  int get currentPage => _page;

  @override
  Future<StockMovementData> fetchData(ReportFilterState filters) {
    return repository.fetch(filters, page: _page, pageSize: pageSize);
  }

  @override
  Future<void> updateExtraFilter(String key, String? value) async {
    _page = 1;
    await super.updateExtraFilter(key, value);
  }

  @override
  bool isEmptyResult(StockMovementData data) => data.rows.isEmpty;

  Future<void> changePage(int page) async {
    _page = page;
    await load();
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
  Future<void> resetFilters() async {
    _page = 1;
    await super.resetFilters();
  }
}
