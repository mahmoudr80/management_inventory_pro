import 'package:flutter/foundation.dart';

@immutable
class InventoryValuationSummary {
  final double totalValue;
  final int activeSkus;
  final int categoryCount;
  final int lowStockCount;
  final int outOfStockCount;

  const InventoryValuationSummary({
    required this.totalValue,
    required this.activeSkus,
    required this.categoryCount,
    required this.lowStockCount,
    required this.outOfStockCount,
  });

  factory InventoryValuationSummary.zero() => const InventoryValuationSummary(
        totalValue: 0,
        activeSkus: 0,
        categoryCount: 0,
        lowStockCount: 0,
        outOfStockCount: 0,
      );
}

/// One slice of the "Value by Category" pie chart.
@immutable
class CategoryValueSlice {
  final String category;
  final double value;

  const CategoryValueSlice({required this.category, required this.value});
}

enum StockStatus { healthy, low, out }

@immutable
class InventoryValuationRow {
  final String sku;
  final String productName;
  final String category;
  final double currentStock;
  final double costPrice;
  final double totalValue;
  final StockStatus status;

  const InventoryValuationRow({
    required this.sku,
    required this.productName,
    required this.category,
    required this.currentStock,
    required this.costPrice,
    required this.totalValue,
    required this.status,
  });
}

@immutable
class InventoryValuationData {
  final InventoryValuationSummary summary;
  final List<CategoryValueSlice> categoryBreakdown;
  final List<InventoryValuationRow> rows;
  final int totalEntries;

  const InventoryValuationData({
    required this.summary,
    required this.categoryBreakdown,
    required this.rows,
    required this.totalEntries,
  });
}
