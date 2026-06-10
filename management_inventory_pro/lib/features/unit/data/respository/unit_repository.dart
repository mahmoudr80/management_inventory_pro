import '../../../../core/networking/api_result.dart';
import '../datasource/unit_datasource.dart';
import '../models/unit_model.dart';

class UnitRepository {
  final UnitLocalDatasource _datasource;

  const UnitRepository(this._datasource);
  Future<ApiResult<List<UnitModel>>>getUnits() async {
    return await _datasource.getUnits();
  }
}