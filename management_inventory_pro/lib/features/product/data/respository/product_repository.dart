import 'package:management_inventory_pro/features/product/data/datasource/product_datasource.dart';

import '../../../../core/networking/api_result.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ProductLocalDatasource _datasource;

  const ProductRepository(this._datasource);

  Future<ApiResult<List<ProductModel>>>getProducts() async {
    return await _datasource.getProducts();
  }
}