import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDatasource {
  final Database _database;

  const ProductLocalDatasource(this._database);

  Future<ApiResult<List<ProductModel>>>getProducts() async {
   try{
     List<Map<String, dynamic>> list = await _database.rawQuery('''
    SELECT
      p.*,
      c.name AS ${DatabaseConstants.categoryName}
    FROM ${DatabaseConstants.productTable} p
    INNER JOIN ${DatabaseConstants.categoryTable} c
      ON c.id = p.${DatabaseConstants.categoryIdColumn}
    ORDER BY p.${DatabaseConstants.createdAtColumn} DESC
  ''');
//      _database.rawQuery("""
//     SELECT
//     ${DatabaseConstants.skuColumn},
//     p.name AS name,
//     c.name AS category,
//     ${DatabaseConstants.currentStockColumn},
//     ${DatabaseConstants.minimumStockColumn}
// FROM products p
// INNER JOIN categories c
//     ON c.id = p.category_id
// ORDER BY p.name;
//
//     """);

     List<ProductModel> products = [];
     for (final Map<String, dynamic> element in list) {
       products.add(ProductModel.fromJson(element));
       print("element:");
       print(element.toString());
     }
    return ApiResult.success(products);
   }catch(e){
     return ApiResult.failure(ApiErrorModel(message: "could not find products"));
   }

  }
}
