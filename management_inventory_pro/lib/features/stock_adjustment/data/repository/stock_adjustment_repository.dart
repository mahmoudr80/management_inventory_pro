import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/stock_adjustment/data/datasource/stock_adjustment_datasource.dart';
import 'package:sqflite/sqflite.dart';

import '../models/stock_adjustment_model.dart';

class StockAdjustmentRepository {
  final StockAdjustmentDatasource _datasource;

const  StockAdjustmentRepository(this._datasource);

  Future<ApiResult> addStockAdjustment(StockAdjustmentModel adjustment) async =>
      await _datasource.insertStockAdjustment(adjustment);

}