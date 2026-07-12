import '../datasource/profit_report_local_datasource.dart';
import '../models/profit_report_model.dart';
import '../models/report_filter_state.dart';
import 'report_repository.dart';

class ProfitReportRepository implements ReportRepository<ProfitReportData> {
  final ProfitReportLocalDataSource dataSource;

  ProfitReportRepository(this.dataSource);

  @override
  Future<ProfitReportData> fetch(
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

  Future<List<(String value, String label)>> fetchProductOptions() => dataSource.fetchProductOptions();

}
