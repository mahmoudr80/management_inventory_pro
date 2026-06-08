import 'package:management_inventory_pro/core/database/database_constants.dart';

import '../../../../../core/components/status_chip.dart';

class ProductModel {
  final String sku;
  final String name;
  final String category;
  final double stock;
  final StatusType status;
  final String statusText;

  ProductModel({
    required this.sku,
    required this.name,
    required this.category,
    required this.stock,
    required this.status,
    required this.statusText,
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
      stock: (json[DatabaseConstants.currentStockColumn] as num).toDouble(),
      status:newStatus,
      statusText: newStatusText,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'name': name,
      'category': category,
      'stock': stock,
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
  }) {
    return ProductModel(
      sku: sku ?? this.sku,
      name: name ?? this.name,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      status: status ?? this.status,
      statusText: statusText ?? this.statusText,
    );
  }
}
