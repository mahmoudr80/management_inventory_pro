import 'package:management_inventory_pro/features/product/data/models/product_model.dart';

import '../../../../core/database/database_constants.dart';

/// Lightweight reference to a product — just enough to display and
/// select one in a dropdown. Swap in your real product model's fields
/// here once a catalog endpoint exists.
class ProductRef {
  final String ?id;
  final String name;
  final String? sku;

  const ProductRef({
     this.id,
    required this.name,
    this.sku,
  });

  factory ProductRef.fromMap(Map<String,dynamic>map){
    return ProductRef(
      id: map[DatabaseConstants.productIdColumn] as String?,
      name: map[DatabaseConstants.productNameAlias] as String,
      sku: map[DatabaseConstants.skuColumn] as String?,
    );
  }
  factory ProductRef.fromProductModel(ProductModel product){
    return ProductRef(
      id: product.id,
      name:product.name,
      sku: product.sku,
    );
  }
   Map<String,String?> toMap(){
   return  {
       'product_id': id,
     'product_name': name,
     'product_sku': sku
   };
   }
}
