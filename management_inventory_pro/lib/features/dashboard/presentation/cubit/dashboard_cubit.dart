import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/mock/dashboard_mock_data.dart';
import '../../data/models/quick_action.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // Simulate network / DB fetch delay
    await Future.delayed(const Duration(milliseconds: 600));

    emit(
      DashboardState(
        summary: DashboardMockData.summary,
        quickActions: DashboardMockData.quickActions,
        topSellingProducts: DashboardMockData.topSellingProducts,
        lowStockProducts: DashboardMockData.lowStockProducts,
        recentSales: DashboardMockData.recentSales,
        recentStockEntries: DashboardMockData.recentStockEntries,
        businessInsights: DashboardMockData.businessInsights,
        weeklyRevenue: DashboardMockData.weeklyRevenue,
        weeklyOrders: DashboardMockData.weeklyOrders,
        isLoading: false,
      ),
    );
  }

  Future<void> refresh() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(isLoading: false));
  }

  void export() {
    // No-op: mock implementation — would trigger file export in production.
  }

  void openQuickAction(QuickAction action) {
    // No-op: mock implementation — would navigate in production.

  }

  void selectSale(String saleId) {
    emit(state.copyWith(selectedSaleId: saleId));
  }

  void clearSelectedSale() {
    emit(
      DashboardState(
        summary: state.summary,
        quickActions: state.quickActions,
        topSellingProducts: state.topSellingProducts,
        lowStockProducts: state.lowStockProducts,
        recentSales: state.recentSales,
        recentStockEntries: state.recentStockEntries,
        businessInsights: state.businessInsights,
        weeklyRevenue: state.weeklyRevenue,
        weeklyOrders: state.weeklyOrders,
        isLoading: state.isLoading,
      ),
    );
  }

  void selectStockEntry(String receiptId) {
    emit(state.copyWith(selectedStockEntryId: receiptId));
  }

  void clearSelectedStockEntry() {
    emit(
      DashboardState(
        summary: state.summary,
        quickActions: state.quickActions,
        topSellingProducts: state.topSellingProducts,
        lowStockProducts: state.lowStockProducts,
        recentSales: state.recentSales,
        recentStockEntries: state.recentStockEntries,
        businessInsights: state.businessInsights,
        weeklyRevenue: state.weeklyRevenue,
        weeklyOrders: state.weeklyOrders,
        isLoading: state.isLoading,
      ),
    );
  }
}
