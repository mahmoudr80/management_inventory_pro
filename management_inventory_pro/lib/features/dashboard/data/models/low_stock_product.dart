import '../../../../core/database/database_constants.dart';

enum LowStockStatus { critical, warning, outOfStock }

class LowStockProductRef {
  final String id;
  final String name;
  final int currentStock;
  final int minimumStock;

  const LowStockProductRef({
    required this.id,
    required this.name,
    required this.currentStock,
    required this.minimumStock,
  });

  LowStockStatus get status {
    if (currentStock == 0) return LowStockStatus.outOfStock;
    if (currentStock <= minimumStock ~/ 2) {
      return LowStockStatus.critical;
    }
    return LowStockStatus.warning;
  }
  factory LowStockProductRef.fromMap(Map<String, Object?> map) {
    final current =
    (map[DatabaseConstants.currentStockColumn] as num).toInt();
    final minimum =
    (map[DatabaseConstants.minimumStockColumn] as num).toInt();

    return LowStockProductRef(
      id: map[DatabaseConstants.idColumn] as String,
      name: map[DatabaseConstants.nameColumn] as String,
      currentStock: current,
      minimumStock: minimum,
    );
  }
}
