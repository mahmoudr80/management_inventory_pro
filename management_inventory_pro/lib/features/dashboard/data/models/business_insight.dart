enum InsightSeverity { info, warning, alert }

enum InsightType {
  revenueGrowth,
  lowStock,
  topSeller,
  inventoryValue,
  salesIncrease,
}

class BusinessInsight {
  final String id;
  final String title;
  final String description;
  final InsightSeverity severity;

  const BusinessInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
  });
}