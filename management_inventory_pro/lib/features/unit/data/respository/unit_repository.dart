import '../../../../core/networking/api_result.dart';
import '../datasource/unit_datasource.dart';
import '../models/unit_model.dart';

class UnitRepository {
  final UnitLocalDatasource _datasource;

  const UnitRepository(this._datasource);
  Future<ApiResult<List<UnitModel>>>getUnits() async {
    return await _datasource.getUnits();
  }

  Future<ApiResult>addUnit({required String name, String ?symbol}) async {
    symbol = symbol?.trim()==''?null:symbol;
    return await _datasource.addUnit(name: name,symbol: symbol);
  }
  Future<ApiResult> deleteUnit(int id) async {
    return _datasource.deleteUnit(id);
  }
}