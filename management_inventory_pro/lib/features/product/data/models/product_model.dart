import 'package:management_inventory_pro/core/database/database_constants.dart';

import '../../../../../core/components/status_chip.dart';

class ProductModel {

  final String id;
  final String ?barcode;
  final int categoryId;
  final int unitId;
  final double costPrice;
  final double sellingPrice;
  final double minStock;
  final String? imageUrl;
  final String? note;
  final String ?createdAt;
  final String ?updatedAt;
  final double currentStock;

  final String sku;
  final String name;
  final String ?category;
  final StatusType status;
  final String ?statusText;

  ProductModel({
    required this.sku,
    required this.name,
     this.category,
    required this.status,
     this.statusText, required this.id,
    this.barcode, required this.categoryId,
    required this.unitId,
    required this.costPrice,
    required this.sellingPrice,
    required this.minStock, this.imageUrl,
    this.note,  this.createdAt,  this.updatedAt,
    required this.currentStock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final stock = (json[DatabaseConstants.currentStockColumn] as num).toDouble();
    final minStock = (json[DatabaseConstants.minimumStockColumn] as num).toDouble();

    late final StatusType newStatus;
    late final String newStatusText;

    if (stock == 0) {
      newStatus = StatusType.outOfStock;
      newStatusText = 'Out of Stock';
    } else if (stock <= minStock) {
      newStatus = StatusType.lowStock;
      newStatusText = 'Low Stock';
    } else {
      newStatus = StatusType.inStock;
      newStatusText = 'In Stock';
    }
    return ProductModel(
      sku: json[DatabaseConstants.skuColumn] as String,
      name: json[DatabaseConstants.nameColumn] as String,
      category: json[DatabaseConstants.categoryName] as String,
      status:newStatus,
      statusText: newStatusText,
      id:json[DatabaseConstants.idColumn],
      categoryId: json[DatabaseConstants.categoryIdColumn],
      unitId: json[DatabaseConstants.unitIdColumn],
      costPrice: json[DatabaseConstants.costPriceColumn],
      sellingPrice:json[DatabaseConstants.sellingPriceColumn],
      minStock: json[DatabaseConstants.minimumStockColumn],
      createdAt: json[DatabaseConstants.createdAtColumn],
      updatedAt: json[DatabaseConstants.updatedAtColumn],
      currentStock: json[DatabaseConstants.currentStockColumn],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'name': name,
      'category': category,
      'stock': currentStock,
      'status': status.name,
      'statusText': statusText,
    };
  }

  ProductModel copyWith({
    String? sku,
    String? name,
    String? category,
    double? stock,
    StatusType? status,
    String? statusText,
    String ?id,
    int ?categoryId,
    int ?unitId,
    double ?costPrice,
    double ?sellingPrice,
    double ?minStock,
    String ?createdAt,
    String ?updatedAt,
    double ? currentStock
  }) {
    return ProductModel(
      sku: sku ?? this.sku,
      name: name ?? this.name,
      category: category ?? this.category,
      status: status ?? this.status,
      statusText: statusText ?? this.statusText,
      id: id??this.id, categoryId: categoryId??this.categoryId,
      unitId: unitId??this.unitId,
      costPrice: costPrice??this.costPrice, sellingPrice: sellingPrice??this.sellingPrice,
      minStock: minStock??this.minStock, createdAt: createdAt??this.createdAt,
      updatedAt:updatedAt??this.updatedAt, currentStock: currentStock??this.currentStock,
    );
  }
}
