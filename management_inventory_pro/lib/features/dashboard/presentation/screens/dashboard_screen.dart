import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      create: (_) => DashboardCubit()..loadDashboard(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();
  void quicAction(QuickAction action,HomeCubit cubit){
    switch(action.id){
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

        return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
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
                  if (state.quickActions.isEmpty && state.isLoading)
                    const LoadingCard(height: 96)
                  else
                    QuickActionsSection(
                      actions: state.quickActions,
                      onActionTap: (action) {
                      quicAction(action, context.read<HomeCubit>());
                      }
                    ),
                  const SizedBox(height: 20),

                  // ── KPI Cards ────────────────────────────────────────────
                  SummaryCardsSection(
                    summary: state.summary,
                    isLoading: state.isLoading,
                  ),
                  const SizedBox(height: 20),

                  // ── Charts ───────────────────────────────────────────────
                  Row(
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TopSellingSection(
                          products: state.topSellingProducts,
                          isLoading: state.isLoading,
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 280,
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
                    onRestock: (product) => context.read<HomeCubit>().restock(product),
                  ),
                  const SizedBox(height: 20),

                  // ── Recent Sales + Recent Stock Entries ──────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RecentSalesSection(
                          sales: state.recentSales,
                          isLoading: state.isLoading,
                          onSelectSale: (sale){
                        context.read<HomeCubit>().selectSale(sale);
                        },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: RecentStockEntriesSection(
                          entries: state.recentStockEntries,
                          isLoading: state.isLoading,
                          onSelectEntry: (entry) {
                            context.read<HomeCubit>().selectEntry(entry);
                          }
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
  }
}
