// lib/features/reports/data/repository/out_of_stock_repository.dart
import '../datasource/out_of_stock_local_datasource.dart';
import '../models/out_of_stock_model.dart';
import '../models/report_filter_state.dart';
import 'report_repository.dart';

class OutOfStockRepository implements ReportRepository<OutOfStockData> {
  final OutOfStockLocalDataSource dataSource;

  OutOfStockRepository(this.dataSource);

  @override
  Future<OutOfStockData> fetch(
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
