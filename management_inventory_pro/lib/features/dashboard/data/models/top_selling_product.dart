class TopSellingProduct {
  final String id;
  final String name;
  final String sku;
  final int unitsSold;
  final double revenue;
  final double performancePercent;

  const TopSellingProduct({
    required this.id,
    required this.name,
    required this.sku,
    required this.unitsSold,
    required this.revenue,
    required this.performancePercent,
  });
}
