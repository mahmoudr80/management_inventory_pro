import '../datasource/stock_adjustment_history_local_datasource.dart';
import '../models/report_filter_state.dart';
import '../models/stock_adjustment_history_model.dart';
import 'report_repository.dart';

class ReportsStockAdjustmentHistoryRepository implements ReportRepository<StockAdjustmentHistoryData> {
  final ReportsStockAdjustmentHistoryLocalDataSource dataSource;

  ReportsStockAdjustmentHistoryRepository(this.dataSource);

  @override
  Future<StockAdjustmentHistoryData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
  }) {
    return dataSource.fetch(filters, page: page, pageSize: pageSize);
  }

  // reports_stock_adjustment_history_repository.dart
  Future<List<(String value, String label)>> fetchProductOptions() => dataSource.fetchProductOptions();
  Future<List<(String value, String label)>> fetchStatusOptions() => dataSource.fetchStatusOptions();
}
