import 'package:flutter/foundation.dart';

enum StockMovementType { sale, purchase, adjustment }

@immutable
class StockMovementSummary {
  final double totalInbound;
  final double totalOutbound;
  final double totalAdjustments;

  const StockMovementSummary({
    required this.totalInbound,
    required this.totalOutbound,
    required this.totalAdjustments,
  });

  factory StockMovementSummary.zero() =>
      const StockMovementSummary(totalInbound: 0, totalOutbound: 0, totalAdjustments: 0);
}

/// One day-level bucket for the Stock Movement area chart.
@immutable
class StockMovementTrendPoint {
  final String label;
  final double inbound;
  final double outbound;
  final double adjustments;

  const StockMovementTrendPoint({
    required this.label,
    required this.inbound,
    required this.outbound,
    required this.adjustments,
  });
}

@immutable
class StockMovementRow {
  final DateTime date;
  final String productSku;
  final String productName;
  final StockMovementType type;
  final double quantity; // signed: +in, -out
  final String referenceId;
  final String createdBy;
  final String? reason;

  const StockMovementRow({
    required this.date,
    required this.productSku,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.referenceId,
    required this.createdBy,
    this.reason,
  });
}

@immutable
class StockMovementData {
  final StockMovementSummary summary;
  final List<StockMovementTrendPoint> trend;
  final List<StockMovementRow> rows;
  final int totalEntries;

  const StockMovementData({
    required this.summary,
    required this.trend,
    required this.rows,
    required this.totalEntries,
  });
}
