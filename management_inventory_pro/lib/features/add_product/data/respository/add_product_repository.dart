import 'package:management_inventory_pro/features/add_product/data/datasource/add_product_datasource.dart';
import 'package:management_inventory_pro/features/product/data/datasource/product_datasource.dart' as add_product_repository;

import '../../../../core/networking/api_result.dart';
import '../../../product/data/models/product_model.dart';

class AddProductRepository {
  final AddProductLocalDatasource _datasource;

  const AddProductRepository(this._datasource);

  Future<ApiResult<int>>addProduct(ProductModel product) async {
    return await _datasource.addProduct(product);
  }
}