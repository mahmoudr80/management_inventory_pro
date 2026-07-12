import 'package:flutter/foundation.dart';

/// High-level KPIs shown in the Sales Report's summary card row. Revenue
/// and profit are both computed pre-tax (see [SalesReportLocalDataSource]
/// for the exact formula) since tax collected is reported separately.
@immutable
class SalesReportSummary {
  final double revenue;
  final double profit;
  final int orders;
  final double averageOrder;
  final double tax;

  const SalesReportSummary({
    required this.revenue,
    required this.profit,
    required this.orders,
    required this.averageOrder,
    required this.tax,
  });

  factory SalesReportSummary.zero() => const SalesReportSummary(
        revenue: 0,
        profit: 0,
        orders: 0,
        averageOrder: 0,
        tax: 0,
      );
}

/// One point on the Revenue Trend chart (the reference UI plots Revenue
/// + Profit on the same axis).
@immutable
class SalesTrendPoint {
  final String label; // e.g. '2026-07-04' — day-level bucket, see datasource
  final double revenue;
  final double profit;

  const SalesTrendPoint({required this.label, required this.revenue, required this.profit});
}

/// One row of the Transaction Log table.
@immutable
class SalesReportRow {
  final String invoiceId;
  final DateTime date;
  final String cashier;
  final String paymentMethod;
  final double subtotal;
  final double discount;
  final double tax;
  final double grandTotal;
  final String status;

  const SalesReportRow({
    required this.invoiceId,
    required this.date,
    required this.cashier,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.grandTotal,
    required this.status,
  });
}

/// Full payload [SalesReportCubit] loads per query — everything
/// [ReportWorkspace] needs for one screen paint.
@immutable
class SalesReportData {
  final SalesReportSummary summary;
  final List<SalesTrendPoint> trend;
  final List<SalesReportRow> rows;
  final int totalEntries;

  const SalesReportData({
    required this.summary,
    required this.trend,
    required this.rows,
    required this.totalEntries,
  });
}
