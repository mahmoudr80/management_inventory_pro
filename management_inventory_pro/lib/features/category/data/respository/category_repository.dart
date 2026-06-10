import '../../../../core/networking/api_result.dart';
import '../datasource/category_datasource.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final CategoryLocalDatasource _datasource;

  const CategoryRepository(this._datasource);

  Future<ApiResult<List<CategoryModel>>>getCategories() async {
    return await _datasource.getCategories();
  }
}