import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/stock_adjustment_history/data/datasource/stock_adjustment_history_datasource.dart';
class StockAdjustmentHistoryRepository {
  final StockAdjustmentHistoryDatasource _datasource;

  const StockAdjustmentHistoryRepository(this._datasource);

  Future<ApiResult> getAdjustments() async {
    return await _datasource.getAdjustments();
  }
}
