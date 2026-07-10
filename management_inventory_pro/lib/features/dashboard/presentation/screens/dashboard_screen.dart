import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/dashboard/data/repository/dashboard_repository.dart';
import '../../../../core/dependency_injection/service_locator.dart';
import '../../../home/cubit/home_cubit.dart';
import '../../data/models/quick_action.dart';
import '../theme/dashboard_theme_extension.dart';
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
    // Layer DashboardThemeColors on top of the app's active theme
    // (light/dark/system) without core ever knowing this feature exists.
    final baseTheme = Theme.of(context);
    final themeWithDashboardColors = baseTheme.copyWith(
      extensions: {
        ...baseTheme.extensions.values,
        dashboardColorsFor(baseTheme.brightness),
      },
    );

    return Theme(
      data: themeWithDashboardColors,
      child: BlocProvider(
        create: (_) => DashboardCubit(getIt<DashboardRepository>())..loadDashboard(),
        child: const _DashboardView(),
      ),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isNarrow = constraints.maxWidth < 1000;
            final EdgeInsets basePadding = EdgeInsets.symmetric(
              horizontal: isNarrow ? 12.0 : 32.0,
              vertical: 24.0,
            );

            return SingleChildScrollView(
              controller: _scrollController,
              primary: false,
              padding: basePadding,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardHeader(
                      onRefresh: cubit.refresh,
                      onExport: cubit.export,
                      isLoading: state.isLoading,
                    ),
                    const SizedBox(height: 28),
                    QuickActionsSection(
                      onActionTap: (action) => _quickAction(action, homeCubit),
                    ),
                    const SizedBox(height: 20),
                    SummaryCardsSection(
                      summary: state.summary,
                      isLoading: state.isLoading,
                    ),
                    const SizedBox(height: 20),
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
                        Expanded(
                          flex: 3,
                          child: TopSellingSection(
                            products: state.topSellingProducts,
                            isLoading: state.isLoading,
                          ),
                        ),
                        const SizedBox(width: 20),
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
                    LowStockSection(
                      products: state.lowStockProducts,
                      isLoading: state.isLoading,
                      onRestock: (product) =>
                          context.read<HomeCubit>().restock(product),
                    ),
                    const SizedBox(height: 20),
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