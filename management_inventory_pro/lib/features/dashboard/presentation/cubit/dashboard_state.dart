import '../../data/models/business_insight.dart';
import '../../data/models/dashboard_summary.dart';
import '../../data/models/low_stock_product.dart';
import '../../data/models/quick_action.dart';
import '../../data/models/recent_sale.dart';
import '../../data/models/recent_stock_entry.dart';
import '../../data/models/top_selling_product.dart';

class DashboardState {
  final DashboardSummary? summary;
  final List<QuickAction> quickActions;
  final List<TopSellingProductRef> topSellingProducts;
  final List<LowStockProductRef> lowStockProducts;
  final List<RecentSaleRef> recentSales;
  final List<RecentStockEntryRef> recentStockEntries;
  final List<BusinessInsight> businessInsights;
  final List<double> weeklyRevenue;
  final List<double> weeklyOrders;
  final bool isLoading;
  final String? errorMessage;
  final String? selectedSaleId;
  final String? selectedStockEntryId;

  const DashboardState({
    this.summary,
    this.quickActions = const [],
    this.topSellingProducts = const [],
    this.lowStockProducts = const [],
    this.recentSales = const [],
    this.recentStockEntries = const [],
    this.businessInsights = const [],
    this.weeklyRevenue = const [],
    this.weeklyOrders = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedSaleId,
    this.selectedStockEntryId,
  });

  bool get hasData => summary != null;

  DashboardState copyWith({
    DashboardSummary? summary,
    List<QuickAction>? quickActions,
    List<TopSellingProductRef>? topSellingProducts,
    List<LowStockProductRef>? lowStockProducts,
    List<RecentSaleRef>? recentSales,
    List<RecentStockEntryRef>? recentStockEntries,
    List<BusinessInsight>? businessInsights,
    List<double>? weeklyRevenue,
    List<double>? weeklyOrders,
    bool? isLoading,
    String? errorMessage,
    String? selectedSaleId,
    String? selectedStockEntryId,
  }) {
    return DashboardState(
      summary: summary ?? this.summary,
      quickActions: quickActions ?? this.quickActions,
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,
      lowStockProducts: lowStockProducts ?? this.lowStockProducts,
      recentSales: recentSales ?? this.recentSales,
      recentStockEntries: recentStockEntries ?? this.recentStockEntries,
      businessInsights: businessInsights ?? this.businessInsights,
      weeklyRevenue: weeklyRevenue ?? this.weeklyRevenue,
      weeklyOrders: weeklyOrders ?? this.weeklyOrders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedSaleId: selectedSaleId ?? this.selectedSaleId,
      selectedStockEntryId: selectedStockEntryId ?? this.selectedStockEntryId,
    );
  }
}
