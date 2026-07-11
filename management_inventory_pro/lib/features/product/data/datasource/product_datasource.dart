import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/category/data/models/category_model.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDatasource {
  final Database _database;

  const ProductLocalDatasource(this._database);

  Future<ApiResult<List<ProductModel>>> getProducts() async {
    try {
      List<Map<String, dynamic>> list = await _database.rawQuery('''
      SELECT
        p.*,
        c.name AS ${DatabaseConstants.categoryNameAlias},
        u.name AS ${DatabaseConstants.unitNameAlias}
      FROM ${DatabaseConstants.productTable} p
      INNER JOIN ${DatabaseConstants.categoryTable} c
        ON c.id = p.${DatabaseConstants.categoryIdColumn}
      INNER JOIN ${DatabaseConstants.unitTable} u
        ON u.id = p.${DatabaseConstants.unitIdColumn}
      ORDER BY p.${DatabaseConstants.createdAtColumn} DESC
    ''');

      final products = list.map((e) => ProductModel.fromJson(e)).toList();
      print("=================");
      print(products[0].toString());
      print("=================");
      return ApiResult.success(products);
    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: 'Could not find products'));
    }
  }

  Future<ApiResult<int>>addProduct(ProductModel product) async{
    try{
      final id = await _database.insert(DatabaseConstants.productTable, product.toJson());
      return ApiResult.success(id);
    }
    catch(e){
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }
  }
  Future<ApiResult<int>>delete(String id) async {
   try{
     final response = await _database
         .delete(DatabaseConstants.productTable,
         where: '${DatabaseConstants.idColumn}=?',
         whereArgs: [id]);
     return ApiResult.success(response);
   }catch(e){
     return ApiResult.failure(ApiErrorModel(message: e.toString()));
   }
  }

  /// Updates Product Master Data only.
  ///
  /// Deliberately strips current_stock, created_at, and id from the
  /// payload before issuing the UPDATE — regardless of what
  /// [product.toJson()] contains — so Edit Product can never be used to
  /// move inventory or rewrite a product's identity/history. Inventory
  /// quantity changes only through Stock Entry / Stock Adjustment.
  /// updated_at is stamped here rather than trusted from the caller.
  Future<ApiResult<int>> updateProduct(ProductModel product) async {
    try {
      final data = product.toJson();
      data.remove(DatabaseConstants.currentStockColumn);
      data.remove(DatabaseConstants.createdAtColumn);
      data.remove(DatabaseConstants.idColumn);
      data[DatabaseConstants.updatedAtColumn] = DateTime.now().toString();

      final result = await _database.update(
        DatabaseConstants.productTable,
        data,
        where: '${DatabaseConstants.idColumn}=?',
        whereArgs: [product.id],
      );
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }
  }

  /// True if a product other than [excludeId] already uses [sku].
  Future<bool> isSkuTaken(String sku, String excludeId) async {
    if (sku.trim().isEmpty) return false;
    final result = await _database.query(
      DatabaseConstants.productTable,
      where:
          '${DatabaseConstants.skuColumn} = ? AND ${DatabaseConstants.idColumn} != ?',
      whereArgs: [sku, excludeId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// True if a product other than [excludeId] already uses [barcode].
  Future<bool> isBarcodeTaken(String barcode, String excludeId) async {
    if (barcode.trim().isEmpty) return false;
    final result = await _database.query(
      DatabaseConstants.productTable,
      where:
          '${DatabaseConstants.barcodeColumn} = ? AND ${DatabaseConstants.idColumn} != ?',
      whereArgs: [barcode, excludeId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<int> countProductsByCategory(String categoryName) async {
    final result = await _database.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.productTable} '
          'WHERE ${DatabaseConstants.nameColumn} = ?',
      [categoryName],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
  Future<int> countProductsByUnit(String unitName) async {
    final result = await _database.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.productTable} '
          'WHERE ${DatabaseConstants.nameColumn} = ?',
      [unitName],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

}
