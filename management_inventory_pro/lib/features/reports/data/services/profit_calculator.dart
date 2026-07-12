/// Single source of truth for profit-related math across every report
/// datasource (Sales Report, Profit Report, ...).
///
/// Previously each datasource re-derived this formula independently in
/// raw SQL, and they'd drifted apart: Sales Report subtracted discount
/// before computing profit, Profit Report did not, so the two reports
/// disagreed on profit for the exact same date range whenever a sale had
/// a discount. Both datasources must call this instead of writing the
/// arithmetic themselves.
///
/// Formula (fixed):
///   netRevenue = subtotal - discount
///   profit     = netRevenue - cost
class ProfitCalculator {
  ProfitCalculator._();

  static double netRevenue({
    required double subtotal,
    required double discount,
  }) =>
      subtotal - discount;

  static double profit({
    required double subtotal,
    required double discount,
    required double cost,
  }) =>
      netRevenue(subtotal: subtotal, discount: discount) - cost;

  /// [revenue] is the denominator the caller wants margin expressed
  /// against (gross subtotal for both reports today, unchanged from
  /// prior behavior). Returns 0 rather than dividing by zero.
  static double marginPercent({
    required double revenue,
    required double profit,
  }) =>
      revenue == 0 ? 0 : (profit / revenue) * 100;
}