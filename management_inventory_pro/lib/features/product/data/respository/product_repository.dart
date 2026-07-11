import 'package:management_inventory_pro/features/product/data/datasource/product_datasource.dart';

import '../../../../core/networking/api_result.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ProductLocalDatasource _datasource;

  const ProductRepository(this._datasource);

  Future<ApiResult<List<ProductModel>>>getProducts() async {
    return await _datasource.getProducts();
  }
  Future<ApiResult<int>>addProduct(ProductModel product) async {
    return await _datasource.addProduct(product);
  }
  Future<ApiResult<int>>delete(String id) async {
    return await _datasource.delete(id);
  }

  /// Updates Product Master Data only — see
  /// [ProductLocalDatasource.updateProduct]. current_stock, created_at,
  /// and id are never part of the UPDATE regardless of what [product]
  /// contains.
  Future<ApiResult<int>> updateProduct(ProductModel product) async {
    return await _datasource.updateProduct(product);
  }

  Future<bool> isSkuTaken(String sku, String excludeId) async {
    return await _datasource.isSkuTaken(sku, excludeId);
  }

  Future<bool> isBarcodeTaken(String barcode, String excludeId) async {
    return await _datasource.isBarcodeTaken(barcode, excludeId);
  }
}
