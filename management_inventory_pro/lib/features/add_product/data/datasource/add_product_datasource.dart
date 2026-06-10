import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/core/networking/api_error_model.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/category/data/models/category_model.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class AddProductLocalDatasource {
  final Database _database;

  const AddProductLocalDatasource(this._database);


  Future<ApiResult<int>>addProduct(ProductModel product) async{
   try{
     final id = await _database.insert(DatabaseConstants.productTable, product.toJson());
     return ApiResult.success(id);
   }
   catch(e){
    return ApiResult.failure(ApiErrorModel(message: e.toString()));
   }
  }

}
