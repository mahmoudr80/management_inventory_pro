import '../../data/models/report_date_range.dart';
import '../../data/models/report_filter_state.dart';
import '../../data/models/stock_adjustment_history_model.dart';
import '../../data/repository/reports_stock_adjustment_history_repository.dart';
import 'base_report_cubit.dart';

class StockAdjustmentHistoryCubit extends BaseReportCubit<StockAdjustmentHistoryData> {
  final ReportsStockAdjustmentHistoryRepository repository;

  StockAdjustmentHistoryCubit(this.repository);

  static const pageSize = 20;

  int _page = 1;
  int get currentPage => _page;

  @override
  Future<StockAdjustmentHistoryData> fetchData(ReportFilterState filters) {
    return repository.fetch(filters, page: _page, pageSize: pageSize);
  }

  // Same "result set size changed, don't strand the user past the last
// page" reasoning as every other cubit's override.
  @override
  Future<void> updateExtraFilter(String key, String? value) async {
    _page = 1;
    await super.updateExtraFilter(key, value);
  }

  @override
  bool isEmptyResult(StockAdjustmentHistoryData data) => data.rows.isEmpty;

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
