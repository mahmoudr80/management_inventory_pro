// lib/features/reports/presentation/cubit/low_stock_cubit.dart
import '../../data/models/low_stock_model.dart';
import '../../data/models/report_filter_state.dart';
import '../../data/repository/low_stock_repository.dart';
import 'base_report_cubit.dart';

/// Point-in-time — same reasoning as [InventoryValuationCubit].
class LowStockCubit extends BaseReportCubit<LowStockData> {
  final LowStockRepository repository;

  LowStockCubit(this.repository);

  static const pageSize = 20;

  @override
  bool get supportsDateRange => false;

  int _page = 1;
  int get currentPage => _page;

  @override
  Future<LowStockData> fetchData(ReportFilterState filters) {
    return repository.fetch(filters, page: _page, pageSize: pageSize);
  }

  @override
  bool isEmptyResult(LowStockData data) => data.rows.isEmpty;

  Future<void> changePage(int page) async {
    _page = page;
    await load();
  }

  @override
  Future<void> updateSearch(String query) async {
    _page = 1;
    await super.updateSearch(query);
  }

  // Phase 3 addition — same "reset to page 1" reasoning as elsewhere.
  @override
  Future<void> updateExtraFilter(String key, String? value) async {
    _page = 1;
    await super.updateExtraFilter(key, value);
  }

  @override
  Future<void> resetFilters() async {
    _page = 1;
    await super.resetFilters();
  }
}
