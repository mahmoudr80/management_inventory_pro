import 'package:management_inventory_pro/features/dashboard/data/models/recent_sale.dart';
import 'package:management_inventory_pro/features/dashboard/data/models/recent_stock_entry.dart';
import 'package:management_inventory_pro/features/dashboard/data/models/top_selling_product.dart';
import 'business_insight.dart';
import 'dashboard_summary.dart';
import 'low_stock_product.dart';
class DashboardModel {
  final DashboardSummary summary;
  final List<TopSellingProductRef> topSellingProducts;
  final List<LowStockProductRef> lowStockProducts;
  final List<RecentSaleRef> recentSales;
  final List<RecentStockEntryRef> recentStockEntries;
  final List<BusinessInsight> businessInsights;
  final List<double> weeklyRevenue;
  final List<double> weeklyOrders;

  const DashboardModel({
    required this.summary,
    required this.topSellingProducts,
    required this.lowStockProducts,
    required this.recentSales,
    required this.recentStockEntries,
    required this.businessInsights,
    required this.weeklyRevenue,
    required this.weeklyOrders,
  });

  DashboardModel copyWith({
    DashboardSummary? summary,
    List<TopSellingProductRef>? topSellingProducts,
    List<LowStockProductRef>? lowStockProducts,
    List<RecentSaleRef>? recentSales,
    List<RecentStockEntryRef>? recentStockEntries,
    List<BusinessInsight>? businessInsights,
    List<double>? weeklyRevenue,
    List<double>? weeklyOrders,
  }) {
    return DashboardModel(
      summary: summary ?? this.summary,
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,
      lowStockProducts: lowStockProducts ?? this.lowStockProducts,
      recentSales: recentSales ?? this.recentSales,
      recentStockEntries:
      recentStockEntries ?? this.recentStockEntries,
      businessInsights: businessInsights ?? this.businessInsights,
      weeklyRevenue: weeklyRevenue ?? this.weeklyRevenue,
      weeklyOrders: weeklyOrders ?? this.weeklyOrders,
    );
  }
}