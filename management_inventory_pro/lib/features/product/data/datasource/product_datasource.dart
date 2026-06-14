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
        c.name AS ${DatabaseConstants.categoryName},
        u.name AS ${DatabaseConstants.unitName}
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
