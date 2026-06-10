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

}
