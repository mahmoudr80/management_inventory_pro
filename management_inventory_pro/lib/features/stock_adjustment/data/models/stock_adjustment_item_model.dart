import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_constants.dart';

class StockAdjustmentItemModel {
  final String id;
  final String productId;
  final String productName;
  final String sku;
  final String? barcode;
  final String? category;
  final String? unit;
  final double currentStock;
  final double minimumStock;
  final double costPrice;
  final int adjustmentQty;

  const StockAdjustmentItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.sku,
     this.barcode='',
     this.category='',
     this.unit='',
    required this.currentStock,
    required this.minimumStock,
    required this.costPrice,
    this.adjustmentQty = 0,
  });

  double get newStock => currentStock + adjustmentQty;
  double get valueImpact => adjustmentQty * costPrice;

  bool get isNegativeInventory => newStock < 0;
  bool get isLowStock => newStock > 0 && newStock <= minimumStock;
  bool get isOutOfStock => newStock == 0;

  StockAdjustmentItemModel copyWith({
    int? adjustmentQty,
  }) =>
      StockAdjustmentItemModel(
        id: id,
        productId: productId,
        productName: productName,
        sku: sku,
        barcode: barcode,
        category: category,
        unit: unit,
        currentStock: currentStock,
        minimumStock: minimumStock,
        costPrice: costPrice,
        adjustmentQty: adjustmentQty ?? this.adjustmentQty,
      );


  factory StockAdjustmentItemModel.fromMap(
      Map<String, Object?> map,
      ) {
    return StockAdjustmentItemModel(
      id: map[DatabaseConstants.idColumn] as String,

      productId:
      map[DatabaseConstants.productIdColumn] as String,

      productName:
      map[DatabaseConstants.nameColumn] as String,

      sku:
      (map[DatabaseConstants.skuColumn] ?? '') as String,

      barcode:
      (map[DatabaseConstants.barcodeColumn] ?? '') as String,

      category:
      (map[DatabaseConstants.categoryNameAlias] ?? '') as String,

      unit:
      (map[DatabaseConstants.unitNameAlias] ?? '') as String,

      currentStock:
      (map[DatabaseConstants.currentStockColumn] as num).toDouble(),

      minimumStock:
      (map[DatabaseConstants.minimumStockColumn] as num).toDouble(),

      costPrice:
      (map[DatabaseConstants.costPriceColumn] as num).toDouble(),

      adjustmentQty:
      (map[DatabaseConstants.adjustmentQuantityColumn] as num).toInt(),
    );
  }

  Map<String, Object?> toMap({
    required String adjustmentId,
  }) {
    return {
      DatabaseConstants.idColumn: id,

      DatabaseConstants.stockAdjustmentIdColumn: adjustmentId,

      DatabaseConstants.productIdColumn: productId,

      DatabaseConstants.currentStockColumn: currentStock,

      DatabaseConstants.adjustmentQuantityColumn: adjustmentQty,

      DatabaseConstants.newStockColumn: newStock,

      DatabaseConstants.costPriceColumn: costPrice,

      DatabaseConstants.inventoryValueChangeColumn: valueImpact,
    };
  }

  factory StockAdjustmentItemModel.fromProduct(ProductModel product){
    return StockAdjustmentItemModel(id: Uuid().v4(),
        productId: product.id, productName: product.name, sku: product.sku, barcode: product.barcode,
        category: product.category, unit: product.unit, currentStock: product.currentStock, minimumStock: product.minStock,
        costPrice: product.costPrice);
  }
}
