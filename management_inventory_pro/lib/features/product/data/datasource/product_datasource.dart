import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/category/data/models/category_model.dart';
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
  Future<ApiResult<List<CategoryModel>>>getCategories() async {
    try{
      List<Map<String, dynamic>> list = await _database.rawQuery('''
   SELECT * from ${DatabaseConstants.categoryTable}
  ''');
      List<CategoryModel> categories = [];
      for (final Map<String, dynamic> element in list) {
        categories.add(CategoryModel.fromJson(element));
        print("element:");
        print(element.toString());
      }
      return ApiResult.success(categories);
    }catch(e){
      return ApiResult.failure(ApiErrorModel(message: "could not find categories"));
    }
  }



}
