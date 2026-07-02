import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_constants.dart';
import '../models/adjustment_model.dart';
import '../models/adjustment_reason.dart';
import '../models/adjustment_status.dart';
import '../models/product_adjustment_model.dart';

class StockAdjustmentHistoryDatasource {
  final Database _database;

  const StockAdjustmentHistoryDatasource(this._database);

  Future<ApiResult> getAdjustments() async {
   try{
     final adjustmentMaps = await _database.query(
       DatabaseConstants.stockAdjustmentsTable,
       orderBy:
       '${DatabaseConstants.createdAtColumn} DESC',
     );

     final List<AdjustmentModel> adjustments = [];

     for (final adjustmentMap in adjustmentMaps) {
       final products = await _getAdjustmentProducts(
         adjustmentMap[DatabaseConstants.idColumn] as String,
       );

       adjustments.add(
         AdjustmentModel(
           id: adjustmentMap[DatabaseConstants.idColumn] as String,
           dateTime: DateTime.parse(
             adjustmentMap[DatabaseConstants.createdAtColumn] as String,
           ),
           reason: AdjustmentReason.values.firstWhere(
                 (e) =>
             e.name ==
                 adjustmentMap[DatabaseConstants.reasonColumn],
           ),
           status: AdjustmentStatus.values.firstWhere(
                 (e) =>
             e.name ==
                 adjustmentMap[DatabaseConstants.statusColumn],
           ),
           createdBy:
           adjustmentMap[DatabaseConstants.createdByColumn]
           as String,
           valueImpact:
           (adjustmentMap[
           DatabaseConstants
               .totalInventoryValueChangeColumn]
           as num)
               .toDouble(),
           products: products,
         ),
       );
     }
     return ApiResult.success(adjustments);
   }catch(e){
     return ApiResult.failure(ApiErrorModel(message: e.toString()));
   }

  }

  Future<List<ProductAdjustmentModel>>
  _getAdjustmentProducts(
      String adjustmentId,
      ) async {
    final maps = await _database.rawQuery(
      '''
SELECT
    ${DatabaseConstants.stockAdjustmentItemsTable}.${DatabaseConstants.adjustmentQuantityColumn},
    ${DatabaseConstants.stockAdjustmentItemsTable}.${DatabaseConstants.currentStockColumn},
    ${DatabaseConstants.productTable}.${DatabaseConstants.nameColumn},
    ${DatabaseConstants.productTable}.${DatabaseConstants.skuColumn}
FROM ${DatabaseConstants.stockAdjustmentItemsTable}

INNER JOIN ${DatabaseConstants.productTable}
ON ${DatabaseConstants.productTable}.${DatabaseConstants.idColumn} =
   ${DatabaseConstants.stockAdjustmentItemsTable}.${DatabaseConstants.productIdColumn}

WHERE ${DatabaseConstants.stockAdjustmentItemsTable}.${DatabaseConstants.stockAdjustmentIdColumn} = ?
''',
      [adjustmentId],
    );

    return maps
        .map(
          (map) => ProductAdjustmentModel(
        productName:
        map[DatabaseConstants.nameColumn] as String,
        sku: map[DatabaseConstants.skuColumn] as String,
        adjustmentQty:
        (map[
        DatabaseConstants
            .adjustmentQuantityColumn]
        as num)
            .toInt(),
        previousStock:
        (map[
        DatabaseConstants
            .currentStockColumn]
        as num)
            .toInt(),
      ),
    )
        .toList();
  }
}