class StockEntryLineModel {
  final String id;
  final String? productId;
  final String productName;   // denormalized for display
  final String? productSku;   // denormalized for display
  final String? unitId;
  final String? unitName;     // denormalized for display
  final int quantity;
  final double unitCost;

  const StockEntryLineModel({
    required this.id,
    this.productId,
    required this.productName,
    this.productSku,
    this.unitId,
    this.unitName,
    required this.quantity,
    required this.unitCost,
  });

  double get lineTotal => quantity * unitCost;

  factory StockEntryLineModel.fromMap(Map<String, dynamic> map) {
    return StockEntryLineModel(
      id: map['id'] as String,
      productId: map['product_id'] as String?,
      productName: map['product_name'] as String,
      productSku: map['product_sku'] as String?,
      unitId: map['unit_id'] as String?,
      unitName: map['unit_name'] as String?,
      quantity: map['quantity'] as int,
      unitCost: (map['unit_cost'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'product_id': productId,
    'product_name': productName,
    'product_sku': productSku,
    'unit_id': unitId,
    'unit_name': unitName,
    'quantity': quantity,
    'unit_cost': unitCost,
  };

  StockEntryLineModel copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productSku,
    String? unitId,
    String? unitName,
    int? quantity,
    double? unitCost,
  }) =>
      StockEntryLineModel(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        productSku: productSku ?? this.productSku,
        unitId: unitId ?? this.unitId,
        unitName: unitName ?? this.unitName,
        quantity: quantity ?? this.quantity,
        unitCost: unitCost ?? this.unitCost,
      );
}