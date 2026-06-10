import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_constants.dart';
import '../../../../core/networking/api_error_model.dart';
import '../../../../core/networking/api_result.dart';
import '../models/category_model.dart';

class CategoryLocalDatasource {
  final Database _database;

  const CategoryLocalDatasource(this._database);

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
