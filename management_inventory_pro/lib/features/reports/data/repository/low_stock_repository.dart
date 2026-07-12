// lib/features/reports/data/repository/low_stock_repository.dart
import '../datasource/low_stock_local_datasource.dart';
import '../models/low_stock_model.dart';
import '../models/report_filter_state.dart';
import 'report_repository.dart';

class LowStockRepository implements ReportRepository<LowStockData> {
  final LowStockLocalDataSource dataSource;

  LowStockRepository(this.dataSource);

  @override
  Future<LowStockData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
  }) {
    return dataSource.fetch(filters, page: page, pageSize: pageSize);
  }

  /// Phase 3 addition.
  Future<List<(String value, String label)>> fetchSupplierOptions() =>
      dataSource.fetchSupplierOptions();
}
