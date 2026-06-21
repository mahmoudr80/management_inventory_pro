import 'package:management_inventory_pro/features/stock_receipts/data/models/product_ref.dart';

import '../../../../core/database/database_constants.dart';

class StockEntryLineModel {
  final String id;
  final ProductRef product;
  final String? unitId;
  final String? unitName;     // denormalized for display
  final int quantity;
  final double unitCost;
  final double? total;

  const StockEntryLineModel({
    required this.id,
    required this.product,
    this.unitId,
    this.unitName,
    required this.quantity,
    required this.unitCost, this.total,
  });

  double get lineTotal => quantity * unitCost;

  factory StockEntryLineModel.fromMap(Map<String, dynamic> map) {
    return StockEntryLineModel(
      id: map[DatabaseConstants.lineIdAlias] as String,
      product: ProductRef.fromMap(map),
      unitId: map[DatabaseConstants.unitIdColumn].toString(),
      unitName: map[DatabaseConstants.unitNameAlias] as String?,
      quantity: (map[DatabaseConstants.quantityColumn] as double).toInt(),
      unitCost: (map[DatabaseConstants.costPriceColumn] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    DatabaseConstants.idColumn: id,
    DatabaseConstants.productIdColumn:product.id,
    DatabaseConstants.quantityColumn: quantity,
    DatabaseConstants.costPriceColumn: unitCost,
    DatabaseConstants.totalColumn:total??quantity*unitCost
  };

  StockEntryLineModel copyWith({
    String? id,
    ProductRef ?product,
    String? unitId,
    String? unitName,
    int? quantity,
    double? unitCost,
  }) =>
      StockEntryLineModel(
        id: id ?? this.id,
        product:product??this.product ,
        unitId: unitId ?? this.unitId,
        unitName: unitName ?? this.unitName,
        quantity: quantity ?? this.quantity,
        unitCost: unitCost ?? this.unitCost,
      );
}