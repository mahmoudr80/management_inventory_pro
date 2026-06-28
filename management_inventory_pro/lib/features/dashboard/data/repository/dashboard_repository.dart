import 'package:management_inventory_pro/features/dashboard/data/datasource/dashboard_datasource.dart';

import '../../../../core/networking/api_result.dart';
import '../models/business_insight.dart';
import '../models/dashboard_model.dart';
import '../models/dashboard_summary.dart';
import '../models/low_stock_product.dart';
import '../models/top_selling_product.dart';

class DashboardRepository {
  final DashboardDatasource _datasource;

  const DashboardRepository(this._datasource);
  Future<ApiResult<DashboardModel>> getDashboard() async {
    final dashboard = await _datasource.getDashboard();

    return ApiResult.success(
      dashboard.copyWith(
        businessInsights: _buildBusinessInsights(
          dashboard.summary,
          dashboard.lowStockProducts,
          dashboard.topSellingProducts,
        ),
      ),
    );
  }
  List<BusinessInsight> _buildBusinessInsights(
      DashboardSummary summary,
      List<LowStockProductRef> lowStock,
      List<TopSellingProductRef> topSelling,
      ) {
    final insights = <BusinessInsight>[];

    if (summary.hasRevenueGrowth) {
      insights.add(
        BusinessInsight(
          id: 'revenue_growth',
          title:
          'Sales up ${summary.revenueChangePercent.toStringAsFixed(1)}% today',
          description:
          'Revenue increased compared with yesterday.',
          severity: InsightSeverity.info,
        ),
      );
    }

    if (lowStock.isNotEmpty) {
      insights.add(
        BusinessInsight(
          id: 'low_stock',
          title: '${lowStock.length} products need restocking',
          description:
          'Some products have reached or fallen below minimum stock.',
          severity: InsightSeverity.warning,
        ),
      );
    }

    if (topSelling.isNotEmpty) {
      insights.add(
        BusinessInsight(
          id: 'top_seller',
          title: '${topSelling.first.name} is today\'s top seller',
        description:
        '${topSelling.first.unitsSold} units sold.',
          severity: InsightSeverity.info,
        ),
      );
    }

    return insights;
  }
}