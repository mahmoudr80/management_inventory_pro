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
  Future<ApiResult>addCategory(String name) async {
    try{
      final response = await _database.
      insert(DatabaseConstants.categoryTable,{DatabaseConstants.nameColumn:name});
      print("success added ${response.toString()}");
      return ApiResult.success(response);
    }catch(e){
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }

  }
  Future<ApiResult> deleteCategory(int id) async {
    try {
      // Check if any product uses this category
      final countResult = await _database.rawQuery(
        '''
  SELECT COUNT(*) as count
  FROM ${DatabaseConstants.productTable}
  WHERE ${DatabaseConstants.categoryIdColumn} = ?
  ''',
        [id],
      );
      final inUseCount = Sqflite.firstIntValue(countResult) ?? 0;
      if (inUseCount > 0) {
        return ApiResult.failure(ApiErrorModel(
          message: 'Cannot delete — $inUseCount product(s) use this category.',
        ));
      }

      final rowsDeleted = await _database.delete(
        DatabaseConstants.categoryTable,
        where: '${DatabaseConstants.idColumn} = ?',
        whereArgs: [id],
      );
      if (rowsDeleted == 0) {
        return ApiResult.failure(ApiErrorModel(message: "Category not found"));
      }
      return ApiResult.success(rowsDeleted);
    } catch (e) {
      print(e.toString());
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }
  }

}
