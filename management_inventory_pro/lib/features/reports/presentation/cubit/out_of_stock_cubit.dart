// lib/features/reports/presentation/cubit/out_of_stock_cubit.dart
import '../../data/models/out_of_stock_model.dart';
import '../../data/models/report_filter_state.dart';
import '../../data/repository/out_of_stock_repository.dart';
import 'base_report_cubit.dart';

/// Point-in-time — same reasoning as [InventoryValuationCubit].
class OutOfStockCubit extends BaseReportCubit<OutOfStockData> {
  final OutOfStockRepository repository;

  OutOfStockCubit(this.repository);

  static const pageSize = 20;

  @override
  bool get supportsDateRange => false;

  int _page = 1;
  int get currentPage => _page;

  @override
  Future<OutOfStockData> fetchData(ReportFilterState filters) {
    return repository.fetch(filters, page: _page, pageSize: pageSize);
  }

  @override
  bool isEmptyResult(OutOfStockData data) => data.rows.isEmpty;

  Future<void> changePage(int page) async {
    _page = page;
    await load();
  }

  @override
  Future<void> updateSearch(String query) async {
    _page = 1;
    await super.updateSearch(query);
  }

  // Phase 3 addition.
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
