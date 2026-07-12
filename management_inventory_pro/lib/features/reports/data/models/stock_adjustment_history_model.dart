import 'package:flutter/foundation.dart';

@immutable
class StockAdjustmentHistorySummary {
  final int adjustments;
  final double inventoryValueImpact;

  const StockAdjustmentHistorySummary({
    required this.adjustments,
    required this.inventoryValueImpact,
  });

  factory StockAdjustmentHistorySummary.zero() =>
      const StockAdjustmentHistorySummary(adjustments: 0, inventoryValueImpact: 0);
}

@immutable
class StockAdjustmentHistoryRow {
  final String adjustmentNumber;
  final String reason;
  final int items;
  final double valueImpact;
  final String createdBy;
  final String status;
  final DateTime date;

  const StockAdjustmentHistoryRow({
    required this.adjustmentNumber,
    required this.reason,
    required this.items,
    required this.valueImpact,
    required this.createdBy,
    required this.status,
    required this.date,
  });
}

@immutable
class StockAdjustmentHistoryData {
  final StockAdjustmentHistorySummary summary;
  final List<StockAdjustmentHistoryRow> rows;
  final int totalEntries;

  const StockAdjustmentHistoryData({
    required this.summary,
    required this.rows,
    required this.totalEntries,
  });
}
