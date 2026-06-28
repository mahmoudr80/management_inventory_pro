import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/dashboard/data/repository/dashboard_repository.dart';
import '../../data/models/quick_action.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardState());
final DashboardRepository _repository;
  Future<void> loadDashboard() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );

    final response = await _repository.getDashboard();
    switch(response){
      case Success(data:final dashboard):
        emit(
          state.copyWith(
            summary: dashboard.summary,
            topSellingProducts: dashboard.topSellingProducts,
            lowStockProducts: dashboard.lowStockProducts,
            recentSales: dashboard.recentSales,
            recentStockEntries: dashboard.recentStockEntries,
            businessInsights: dashboard.businessInsights,
            weeklyRevenue: dashboard.weeklyRevenue,
            weeklyOrders: dashboard.weeklyOrders,
            isLoading: false,
          ),
        );
      case Failure(errorModel:final error):
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: error.message,
          ),
        );
    }
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
