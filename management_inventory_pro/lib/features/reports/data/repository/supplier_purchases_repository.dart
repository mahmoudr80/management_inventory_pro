// lib/features/reports/data/repository/supplier_purchases_repository.dart
import '../datasource/supplier_purchases_local_datasource.dart';
import '../models/report_filter_state.dart';
import '../models/supplier_purchases_model.dart';
import 'report_repository.dart';

class SupplierPurchasesRepository implements ReportRepository<SupplierPurchasesData> {
  final SupplierPurchasesLocalDataSource dataSource;

  SupplierPurchasesRepository(this.dataSource);

  @override
  Future<SupplierPurchasesData> fetch(
    ReportFilterState filters, {
    int page = 1,
    int pageSize = 20,
  }) {
    return dataSource.fetch(filters, page: page, pageSize: pageSize);
  }

  /// Phase 3 addition.
  Future<List<(String value, String label)>> fetchSupplierOptions() =>
      dataSource.fetchSupplierOptions();

  Future<List<(String value, String label)>> fetchProductOptions() => dataSource.fetchProductOptions();

}
