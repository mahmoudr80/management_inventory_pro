import '../../../../core/database/database_constants.dart';

class TopSellingProductRef {
  final String id;
  final String name;
  final String sku;
  final int unitsSold;
  final double revenue;
  final double performancePercent;

  const TopSellingProductRef({
    required this.id,
    required this.name,
    required this.sku,
    required this.unitsSold,
    required this.revenue,
    required this.performancePercent,
  });
  factory TopSellingProductRef.fromMap(Map<String, Object?> map) {
    return TopSellingProductRef(
      id: map[DatabaseConstants.idColumn] as String,
      name: map[DatabaseConstants.nameColumn] as String,
      sku: map[DatabaseConstants.skuColumn] as String? ?? '',
      unitsSold: (map[DatabaseConstants.unitSold] as num).toInt(),
      revenue: (map[DatabaseConstants.revenue] as num).toDouble(),
      performancePercent:
      (map[DatabaseConstants.profit] as num).toDouble(),
    );
  }
}
