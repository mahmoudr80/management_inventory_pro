import '../datasource/stock_movement_local_datasource.dart';
import '../models/report_filter_state.dart';
import '../models/stock_movement_model.dart';
import 'report_repository.dart';

class StockMovementRepository implements ReportRepository<StockMovementData> {
  final StockMovementLocalDataSource dataSource;

  StockMovementRepository(this.dataSource);

  @override
  Future<StockMovementData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
  }) {
    return dataSource.fetch(filters, page: page, pageSize: pageSize);
  }

  // stock_movement_repository.dart
  Future<List<(String value, String label)>> fetchProductOptions() => dataSource.fetchProductOptions();
  List<(String value, String label)> get movementTypeOptions => StockMovementLocalDataSource.movementTypeOptions;
}
