import 'package:flutter/foundation.dart';

@immutable
class SupplierPurchasesSummary {
  final double purchaseCost;
  final int orders;
  final int products;

  const SupplierPurchasesSummary({
    required this.purchaseCost,
    required this.orders,
    required this.products,
  });

  factory SupplierPurchasesSummary.zero() =>
      const SupplierPurchasesSummary(purchaseCost: 0, orders: 0, products: 0);
}

@immutable
class SupplierPurchasesRow {
  final String supplierId;
  final String supplierName;
  final int orders;
  final int items;
  final double totalCost;
  final DateTime? lastPurchase;

  const SupplierPurchasesRow({
    required this.supplierId,
    required this.supplierName,
    required this.orders,
    required this.items,
    required this.totalCost,
    this.lastPurchase,
  });
}

@immutable
class SupplierPurchasesData {
  final SupplierPurchasesSummary summary;
  final List<SupplierPurchasesRow> rows;
  final int totalEntries;

  const SupplierPurchasesData({
    required this.summary,
    required this.rows,
    required this.totalEntries,
  });
}
