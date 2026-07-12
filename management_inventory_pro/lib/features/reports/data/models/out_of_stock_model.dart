import 'package:flutter/foundation.dart';

@immutable
class OutOfStockSummary {
  final int outOfStockCount;

  const OutOfStockSummary({required this.outOfStockCount});

  factory OutOfStockSummary.zero() => const OutOfStockSummary(outOfStockCount: 0);
}

@immutable
class OutOfStockRow {
  final String sku;
  final String productName;
  final String category;
  final String? supplierName;
  final DateTime? lastSale;

  /// Days since [lastSale]. Null when the product has never sold — in
  /// that case there is no reliable signal for how long it's been out
  /// of stock (the schema has no event recording the moment
  /// current_stock hit zero, and `products.updated_at` is a generic
  /// row-touch column that unrelated edits — e.g. fixing a product's
  /// name or price — also bump, which would silently reset this to a
  /// near-zero, misleading value). Show "Never sold" in the UI rather
  /// than inventing a number. TODO: add a `stock_depleted_at` column,
  /// set at the moment current_stock transitions to 0, to make this
  /// exact instead of a proxy.
  final int? daysOutOfStock;

  const OutOfStockRow({
    required this.sku,
    required this.productName,
    required this.category,
    this.supplierName,
    this.lastSale,
    this.daysOutOfStock,
  });
}

@immutable
class OutOfStockData {
  final OutOfStockSummary summary;
  final List<OutOfStockRow> rows;
  final int totalEntries;

  const OutOfStockData({required this.summary, required this.rows, required this.totalEntries});
}
