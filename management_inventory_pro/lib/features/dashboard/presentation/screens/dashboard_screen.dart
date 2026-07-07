import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/dashboard/data/repository/dashboard_repository.dart';
import '../../../../core/dependency_injection/service_locator.dart';
import '../../../home/cubit/home_cubit.dart';
import '../../data/models/quick_action.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/charts/orders_chart_card.dart';
import '../widgets/charts/sales_chart_card.dart';
import '../widgets/common/loading_card.dart';
import '../widgets/header/dashboard_header.dart';
import '../widgets/insights/business_insights_card.dart';
import '../widgets/inventory/inventory_value_card.dart';
import '../widgets/inventory/low_stock_section.dart';
import '../widgets/quick_actions/quick_actions_section.dart';
import '../widgets/recent_sales/recent_sales_section.dart';
import '../widgets/stock_entries/recent_stock_entries_section.dart';
import '../widgets/summary/summary_cards_section.dart';
import '../widgets/top_selling/top_selling_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(getIt<DashboardRepository>())..loadDashboard(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  void _quickAction(QuickAction action, HomeCubit cubit) {
    switch (action.id) {
      case 'new_sale':
        cubit.openNewSale();
        break;
      case 'new_stock_entry':
        cubit.openStockEntryForCreate();
        break;
      case 'add_product':
        cubit.openProductsForCreate();
        break;
      case 'view_inventory':
        cubit.openProductList();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final cubit = context.read<DashboardCubit>();
        final homeCubit = context.read<HomeCubit>();
        // Use LayoutBuilder for responsive decisions
        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isNarrow = constraints.maxWidth < 1000;
            // Base padding – shrink on very small screens
            final EdgeInsets basePadding = EdgeInsets.symmetric(
              horizontal: isNarrow ? 12.0 : 32.0,
              vertical: 24.0,
            );

            return SingleChildScrollView(
              padding: basePadding,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──────────────────────────────────────────────
                    DashboardHeader(
                      onRefresh: cubit.refresh,
                      onExport: cubit.export,
                      isLoading: state.isLoading,
                    ),
                    const SizedBox(height: 28),
                    // ── Quick Actions ────────────────────────────────────────
                    QuickActionsSection(
                      onActionTap: (action) => _quickAction(action, homeCubit),
                    ),
                    const SizedBox(height: 20),
                    // ── KPI Cards ────────────────────────────────────────────
                    SummaryCardsSection(
                      summary: state.summary,
                      isLoading: state.isLoading,
                    ),
                    const SizedBox(height: 20),
                    // ── Charts ───────────────────────────────────────────────
                    isNarrow
                        ? Column(
                            children: [
                              SalesChartCard(
                                weeklyRevenue: state.weeklyRevenue,
                                isLoading: state.isLoading,
                              ),
                              const SizedBox(height: 20),
                              OrdersChartCard(
                                weeklyOrders: state.weeklyOrders,
                                isLoading: state.isLoading,
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SalesChartCard(
                                  weeklyRevenue: state.weeklyRevenue,
                                  isLoading: state.isLoading,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: OrdersChartCard(
                                  weeklyOrders: state.weeklyOrders,
                                  isLoading: state.isLoading,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 20),
                    // ── Top Selling + Inventory Value + Insights ─────────────
                    isNarrow
                        ? Column(
                            children: [
                              TopSellingSection(
                                products: state.topSellingProducts,
                                isLoading: state.isLoading,
                              ),
                              const SizedBox(height: 20),
                              if (state.summary != null)
                                InventoryValueCard(summary: state.summary!),
                              const SizedBox(height: 16),
                              BusinessInsightsCard(
                                insights: state.businessInsights,
                                onGenerateReport: () {},
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Main growing area – top selling list
                              Expanded(
                                flex: 3,
                                child: TopSellingSection(
                                  products: state.topSellingProducts,
                                  isLoading: state.isLoading,
                                ),
                              ),
                              const SizedBox(width: 20),
                              // Side panel – inventory + insights
                              Flexible(
                                flex: 2,
                                child: Column(
                                  children: [
                                    if (state.summary != null)
                                      InventoryValueCard(summary: state.summary!),
                                    const SizedBox(height: 16),
                                    BusinessInsightsCard(
                                      insights: state.businessInsights,
                                      onGenerateReport: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 20),
                    // ── Low Stock Alerts ─────────────────────────────────────
                    LowStockSection(
                      products: state.lowStockProducts,
                      isLoading: state.isLoading,
                      onRestock: (product) =>
                          context.read<HomeCubit>().restock(product),
                    ),
                    const SizedBox(height: 20),
                    // ── Recent Sales + Recent Stock Entries ──────────────────
                    isNarrow
                        ? Column(
                            children: [
                              RecentSalesSection(
                                sales: state.recentSales,
                                isLoading: state.isLoading,
                                onSelectSale: (sale) =>
                                    context.read<HomeCubit>().selectSale(sale),
                              ),
                              const SizedBox(height: 20),
                              RecentStockEntriesSection(
                                entries: state.recentStockEntries,
                                isLoading: state.isLoading,
                                onSelectEntry: (entry) =>
                                    context.read<HomeCubit>().selectEntry(entry),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: RecentSalesSection(
                                  sales: state.recentSales,
                                  isLoading: state.isLoading,
                                  onSelectSale: (sale) =>
                                      context.read<HomeCubit>().selectSale(sale),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 2,
                                child: RecentStockEntriesSection(
                                  entries: state.recentStockEntries,
                                  isLoading: state.isLoading,
                                  onSelectEntry: (entry) =>
                                      context.read<HomeCubit>().selectEntry(entry),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
