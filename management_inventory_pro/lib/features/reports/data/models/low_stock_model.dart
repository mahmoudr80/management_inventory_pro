import 'package:flutter/foundation.dart';

@immutable
class LowStockSummary {
  final int lowStockCount;

  const LowStockSummary({required this.lowStockCount});

  factory LowStockSummary.zero() => const LowStockSummary(lowStockCount: 0);
}

@immutable
class LowStockRow {
  final String sku;
  final String productName;
  final String category;
  final double currentStock;
  final double minimumStock;
  final String? supplierName;
  final DateTime? lastStockEntry;

  const LowStockRow({
    required this.sku,
    required this.productName,
    required this.category,
    required this.currentStock,
    required this.minimumStock,
    this.supplierName,
    this.lastStockEntry,
  });
}

@immutable
class LowStockData {
  final LowStockSummary summary;
  final List<LowStockRow> rows;
  final int totalEntries;

  const LowStockData({required this.summary, required this.rows, required this.totalEntries});
}
