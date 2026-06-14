import 'package:management_inventory_pro/features/unit/data/models/unit_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_constants.dart';
import '../../../../core/networking/api_error_model.dart';
import '../../../../core/networking/api_result.dart';

class UnitLocalDatasource {
  final Database _database;

  const UnitLocalDatasource(this._database);

  Future<ApiResult<List<UnitModel>>>getUnits() async {
    try{
      List<Map<String, dynamic>> list = await _database.rawQuery('''
   SELECT * from ${DatabaseConstants.unitTable}
  ''');
      List<UnitModel> units = [];
      for (final Map<String, dynamic> element in list) {
        units.add(UnitModel.fromJson(element));
        print("element:");
        print(element.toString());
      }
      return ApiResult.success(units);
    }catch(e){
      return ApiResult.failure(ApiErrorModel(message: "could not find Units"));
    }
  }

  Future<ApiResult>addUnit({required String name, String ?symbol}) async {
   try{
     final response = await _database.
     insert(DatabaseConstants.unitTable,{DatabaseConstants.nameColumn:name,DatabaseConstants.symbolColumn:symbol});
     return ApiResult.success(response);
   }catch(e){
     return ApiResult.failure(ApiErrorModel(message: e.toString()));
   }

  }
  Future<ApiResult> deleteUnit(int id) async {
    try {
      final countResult = await _database.rawQuery(
        'SELECT COUNT(*) as count FROM ${DatabaseConstants.productTable} '
            'WHERE ${DatabaseConstants.unitIdColumn} = ?',
        [id],
      );
      final inUseCount = Sqflite.firstIntValue(countResult) ?? 0;
      if (inUseCount > 0) {
        return ApiResult.failure(ApiErrorModel(
          message: 'Cannot delete — $inUseCount product(s) use this unit.',
        ));
      }

      final rowsDeleted = await _database.delete(
        DatabaseConstants.unitTable,
        where: '${DatabaseConstants.idColumn} = ?',
        whereArgs: [id],
      );
      if (rowsDeleted == 0) {
        return ApiResult.failure(ApiErrorModel(message: "Unit not found"));
      }
      return ApiResult.success(rowsDeleted);
    } catch (e) {
      return ApiResult.failure(ApiErrorModel(message: e.toString()));
    }
  }

}
