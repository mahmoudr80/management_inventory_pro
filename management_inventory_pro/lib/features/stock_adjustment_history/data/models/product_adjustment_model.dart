import 'package:equatable/equatable.dart';

import 'product_stock_status.dart';

/// A single product affected by a stock adjustment.
class ProductAdjustmentModel extends Equatable {
  const ProductAdjustmentModel({
    required this.productName,
    required this.sku,
    required this.adjustmentQty,
    required this.previousStock,
  });

  final String productName;
  final String sku;

  /// Signed quantity delta applied to this product (e.g. -2, +10).
  final int adjustmentQty;
  final int previousStock;

  int get newStock => previousStock + adjustmentQty;

  ProductStockStatus get stockStatus =>
      ProductStockStatus.fromQuantity(newStock);

  @override
  List<Object?> get props => [productName, sku, adjustmentQty, previousStock];
}
