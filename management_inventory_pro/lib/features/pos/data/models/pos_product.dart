import 'package:management_inventory_pro/core/components/status_chip.dart';
import '../../../product/data/models/product_model.dart';

class PosProduct {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final bool outOfStock;
  final String category;
  final String ?unit;
  final num? currentStock;
  final int? categoryId;

  /// Stock-keeping unit code, used as a secondary search key alongside
  /// [name] and [barcode]. Null/empty when the product has none.
  final String? sku;

  /// Scanned/printed barcode value, used as a secondary search key
  /// alongside [name] and [sku]. Null/empty when the product has none.
  final String? barcode;

  const PosProduct({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.outOfStock = false,
    this.category = 'General',
    this.sku,
    this.barcode, this.currentStock, this.categoryId, this.unit,
  });

  factory PosProduct.fromProduct(ProductModel product) => PosProduct(
        id: product.id,
        name: product.name,
        price: product.sellingPrice,
        imageUrl: product.imageUrl,
        category: product.category ?? "generic",
        outOfStock: product.status == StatusType.outOfStock,
        // NOTE: adjust these two lines to match whatever your ProductModel
        // actually calls these fields (e.g. `skuCode`, `barcodeNumber`) if
        // the names differ — they're required for SKU/barcode search.
        sku: product.sku,
        barcode: product.barcode,
        currentStock:product.currentStock
      );
}
