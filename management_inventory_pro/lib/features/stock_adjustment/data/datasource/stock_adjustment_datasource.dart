import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/networking/api_result.dart';
import '../models/stock_adjustment_item_model.dart';
import '../models/stock_adjustment_model.dart';

class StockAdjustmentDatasource {
  final Database _database;

const  StockAdjustmentDatasource(this._database);

  Future<ApiResult>insertStockAdjustment(StockAdjustmentModel adjustment) async {
   try{
     _database.transaction((txn) async {
       await _addAdjustment(adjustment: adjustment,txn: txn);
       await _addAdjustmentItems(items: adjustment.items, adjustmentId:adjustment.id,txn: txn);
     },);
     return ApiResult.success(true);
   }
   catch(e){
     return  ApiResult.failure(ApiErrorModel(message: e.toString()));
   }
  }
  Future<void> _addAdjustment({required StockAdjustmentModel adjustment,Transaction ?txn})async{
     await (txn??_database).insert(DatabaseConstants.stockAdjustmentsTable, adjustment.toMap());
  }
  Future<void> _addAdjustmentItems({required List<StockAdjustmentItemModel> items, required String adjustmentId,Transaction ?txn})async{
    for(final item in items ){
      await _addAdjustmentOneItem(item: item, adjustmentId: adjustmentId,txn: txn);
      await _updateProduct(adjustmentQty: item.adjustmentQty, productId: item.productId,txn: txn);
    }
  }
  Future<void> _addAdjustmentOneItem({required StockAdjustmentItemModel item, required String adjustmentId, Transaction ?txn})async{
    await (txn??_database).insert(DatabaseConstants.stockAdjustmentItemsTable, item.toMap(adjustmentId: adjustmentId));
  }
  Future<void> _updateProduct({Transaction ?txn,required int adjustmentQty,required String productId}) async {
    await (txn??_database).rawUpdate(
      '''
  UPDATE ${DatabaseConstants.productTable}
  SET ${DatabaseConstants.currentStockColumn} =
      ${DatabaseConstants.currentStockColumn} + ?
  WHERE ${DatabaseConstants.idColumn} = ?
  ''',
      [
        adjustmentQty,
        productId,
      ],
    );
  }
}