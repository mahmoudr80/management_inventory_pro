import 'package:equatable/equatable.dart';

import 'adjustment_model.dart';

/// Aggregated KPI figures shown in the five summary cards above the table.
class AdjustmentHistoryKpis extends Equatable {
  const AdjustmentHistoryKpis({
    required this.totalAdjustments,
    required this.totalAdjustmentsTrendPct,
    required this.productsAdjusted,
    required this.productsAdjustedTrendPct,
    required this.netQuantityChange,
    required this.inventoryValueImpact,
    required this.avgAdjustmentSize,
  });

  final int totalAdjustments;
  final double totalAdjustmentsTrendPct;
  final int productsAdjusted;
  final double productsAdjustedTrendPct;
  final int netQuantityChange;
  final double inventoryValueImpact;
  final double avgAdjustmentSize;

  static const empty = AdjustmentHistoryKpis(
    totalAdjustments: 0,
    totalAdjustmentsTrendPct: 0,
    productsAdjusted: 0,
    productsAdjustedTrendPct: 0,
    netQuantityChange: 0,
    inventoryValueImpact: 0,
    avgAdjustmentSize: 0,
  );

  /// Computes KPIs from the full (unfiltered) adjustment list. Trend
  /// percentages are mocked, since there is no prior-period dataset.
  factory AdjustmentHistoryKpis.fromAdjustments(
    List<AdjustmentModel> adjustments,
  ) {
    if (adjustments.isEmpty) return empty;

    final uniqueSkus = <String>{};
    var netQty = 0;
    var totalValue = 0.0;
    var totalProductLines = 0;

    for (final adjustment in adjustments) {
      netQty += adjustment.qtyChange;
      totalValue += adjustment.valueImpact;
      totalProductLines += adjustment.productCount;
      for (final product in adjustment.products) {
        uniqueSkus.add(product.sku);
      }
    }

    return AdjustmentHistoryKpis(
      totalAdjustments: adjustments.length,
      totalAdjustmentsTrendPct: 8,
      productsAdjusted: uniqueSkus.length,
      productsAdjustedTrendPct: 4,
      netQuantityChange: netQty,
      inventoryValueImpact: totalValue,
      avgAdjustmentSize: totalProductLines / adjustments.length,
    );
  }

  @override
  List<Object?> get props => [
        totalAdjustments,
        totalAdjustmentsTrendPct,
        productsAdjusted,
        productsAdjustedTrendPct,
        netQuantityChange,
        inventoryValueImpact,
        avgAdjustmentSize,
      ];
}
