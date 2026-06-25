import 'package:management_inventory_pro/features/sale_history/data/datasource/sale_history_datasource.dart';

import '../../../../core/networking/api_result.dart';

class SaleHistoryRepository {
  final SaleHistoryDatasource _datasource;

  const SaleHistoryRepository(this._datasource);

  Future<ApiResult> getSales() async {
    return await _datasource.getSales();
  }
}