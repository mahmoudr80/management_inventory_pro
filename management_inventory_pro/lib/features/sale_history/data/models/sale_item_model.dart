import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/features/pos/data/models/pos_product.dart';

enum PaymentMethod {
  cash,
  card,
  mixed,
}

enum SaleStatus {
  completed,
  refunded,
  cancelled,
}

class SaleItemModel {
  final String id;
  final PosProduct product;

  final int quantity;
  final double sellingPrice;

  const SaleItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.sellingPrice,
  });

  double get total => quantity * sellingPrice;

  factory SaleItemModel.fromMap(Map<String,Object?>map){
    return SaleItemModel(
      id: map[DatabaseConstants.saleItemId] as String,
      // FIX: quantity is stored in a REAL column (see database_service.dart),
      // and a Dart `int` written into it can come back as either `int` or
      // `double` depending on the sqflite platform driver. Casting straight
      // to `double` crashed whenever the driver returned an int. `as num`
      // accepts either runtime type safely.
      quantity: (map[DatabaseConstants.quantityColumn] as num).toInt(),
      sellingPrice: (map[DatabaseConstants.sellingPriceColumn] as num).toDouble(),
      product: PosProduct(
        id: map[DatabaseConstants.productIdColumn] as String,
        name: map[DatabaseConstants.nameColumn] as String,
        price: (map[DatabaseConstants.productPrice] as num).toDouble(),
        imageUrl: map[DatabaseConstants.imageUrlColumn] as String?,
        sku: map[DatabaseConstants.skuColumn] as String?,
        barcode: map[DatabaseConstants.barcodeColumn] as String?,
      ),
    );
  }
}