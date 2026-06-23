import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/pos/data/models/cart_item.dart';
import 'package:sqflite/sqflite.dart';

class PosDatasource{
  final Database _database;
  const PosDatasource(this._database);

  Future <ApiResult> completeSale(CartModel cart) async {
    try{
      await _database.transaction((txn) async {
        await _insertSale(txn, cart);
        await _insertSaleItem(txn, cart);
        await _updateProductStock(txn, cart);
      },);
      return ApiResult.success(true);
    }catch(e){
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }

  }
  Future<void>_insertSale(Transaction txn,CartModel cart) async {
    await txn.insert(DatabaseConstants.saleTable, cart.toMap());
  }
  Future<void>_insertSaleItem(Transaction txn ,CartModel cart) async {
    for(final item in cart.items){
      await txn.insert(DatabaseConstants.saleItemTable, {DatabaseConstants.saleIdColumn:cart.id,...item.toMap()});
    }
  }
  Future<void> _updateProductStock(
      Transaction txn,
      CartModel cart,
      ) async {
    final now = DateTime.now()
        .toIso8601String()
        .split('.')
        .first
        .replaceFirst('T', ' ');

    for (final item in cart.items) {
      await txn.rawUpdate(
        '''
      UPDATE ${DatabaseConstants.productTable}
      SET
        ${DatabaseConstants.currentStockColumn}
          = ${DatabaseConstants.currentStockColumn} - ?,
        ${DatabaseConstants.updatedAtColumn} = ?
      WHERE ${DatabaseConstants.idColumn} = ?
      ''',
        [
          item.quantity,
          now,
          item.product.id,
        ],
      );
    }
  }
}