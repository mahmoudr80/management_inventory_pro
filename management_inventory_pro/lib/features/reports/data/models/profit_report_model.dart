import 'package:flutter/foundation.dart';

@immutable
class ProfitReportSummary {
  final double revenue;
  final double cost;
  final double profit;
  final double marginPercent;

  const ProfitReportSummary({
    required this.revenue,
    required this.cost,
    required this.profit,
    required this.marginPercent,
  });

  factory ProfitReportSummary.zero() => const ProfitReportSummary(
        revenue: 0,
        cost: 0,
        profit: 0,
        marginPercent: 0,
      );
}

@immutable
class ProfitReportRow {
  final String invoiceId;
  final double revenue;
  final double cost;
  final double profit;
  final double marginPercent;

  const ProfitReportRow({
    required this.invoiceId,
    required this.revenue,
    required this.cost,
    required this.profit,
    required this.marginPercent,
  });
}

@immutable
class ProfitReportData {
  final ProfitReportSummary summary;
  final List<ProfitReportRow> rows;
  final int totalEntries;

  const ProfitReportData({
    required this.summary,
    required this.rows,
    required this.totalEntries,
  });
}
