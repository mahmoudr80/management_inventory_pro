enum LowStockStatus { critical, warning, outOfStock }

class LowStockProduct {
  final String id;
  final String name;
  final int currentStock;
  final int minimumStock;
  final LowStockStatus status;

  const LowStockProduct({
    required this.id,
    required this.name,
    required this.currentStock,
    required this.minimumStock,
    required this.status,
  });
}
