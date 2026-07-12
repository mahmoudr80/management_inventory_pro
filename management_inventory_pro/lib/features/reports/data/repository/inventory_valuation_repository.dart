// lib/features/reports/data/repository/inventory_valuation_repository.dart
import '../datasource/inventory_valuation_local_datasource.dart';
import '../models/inventory_valuation_model.dart';
import '../models/report_filter_state.dart';
import 'report_repository.dart';

class InventoryValuationRepository implements ReportRepository<InventoryValuationData> {
  final InventoryValuationLocalDataSource dataSource;

  InventoryValuationRepository(this.dataSource);

  @override
  Future<InventoryValuationData> fetch(
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

  /// Phase 3 addition — forwards to the datasource so the screen can
  /// populate its Category filter dropdown without reaching past the
  /// repository layer.
  Future<List<(String value, String label)>> fetchCategoryOptions() =>
      dataSource.fetchCategoryOptions();
}
