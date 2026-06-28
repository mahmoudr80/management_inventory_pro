class DashboardSummary {
  final double todayRevenue;
  final double yesterdayRevenue;
  final int todayOrders;
  final double avgOrderValue;
  final int totalProducts;
  final int activeCategories;
  final int lowStockCount;
  final double inventoryValue;
  final double inventoryTurnoverChange;

  const DashboardSummary({
    required this.todayRevenue,
    required this.yesterdayRevenue,
    required this.todayOrders,
    required this.avgOrderValue,
    required this.totalProducts,
    required this.activeCategories,
    required this.lowStockCount,
    required this.inventoryValue,
    required this.inventoryTurnoverChange,
  });

  double get revenueChangePercent =>
      yesterdayRevenue == 0
          ? 0
          : ((todayRevenue - yesterdayRevenue) / yesterdayRevenue) * 100;
  bool get hasRevenueGrowth => revenueChangePercent > 0;

  DashboardSummary copyWith({
    double? todayRevenue,
    double? yesterdayRevenue,
    int? todayOrders,
    double? avgOrderValue,
    int? totalProducts,
    int? activeCategories,
    int? lowStockCount,
    double? inventoryValue,
    double? inventoryTurnoverChange,
  }) {
    return DashboardSummary(
      todayRevenue: todayRevenue ?? this.todayRevenue,
      yesterdayRevenue: yesterdayRevenue ?? this.yesterdayRevenue,
      todayOrders: todayOrders ?? this.todayOrders,
      avgOrderValue: avgOrderValue ?? this.avgOrderValue,
      totalProducts: totalProducts ?? this.totalProducts,
      activeCategories: activeCategories ?? this.activeCategories,
      lowStockCount: lowStockCount ?? this.lowStockCount,
      inventoryValue: inventoryValue ?? this.inventoryValue,
      inventoryTurnoverChange:
          inventoryTurnoverChange ?? this.inventoryTurnoverChange,
    );
  }
  const DashboardSummary.empty()
      : todayRevenue = 0,
        yesterdayRevenue = 0,
        todayOrders = 0,
        avgOrderValue = 0,
        totalProducts = 0,
        activeCategories = 0,
        lowStockCount = 0,
        inventoryValue = 0,
        inventoryTurnoverChange = 0;
}
