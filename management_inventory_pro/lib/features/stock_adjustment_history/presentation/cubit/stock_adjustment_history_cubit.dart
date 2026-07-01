import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/adjustment_model.dart';
import '../../data/models/adjustment_reason.dart';
import '../../data/models/adjustment_status.dart';
import '../../data/models/date_range_filter.dart';
import '../../data/repositories/mock_stock_adjustment_history_repository.dart';
import 'stock_adjustment_history_state.dart';

class StockAdjustmentHistoryCubit extends Cubit<StockAdjustmentHistoryState> {
  StockAdjustmentHistoryCubit(this._repository)
      : super(const StockAdjustmentHistoryState());

  final StockAdjustmentHistoryRepository _repository;

  Future<void> loadAdjustments() async {
    emit(state.copyWith(
      status: StockAdjustmentHistoryStatus.loading,
      loading: true,
      clearError: true,
    ));
    try {
      final adjustments = await _repository.getAdjustments();
      emit(state.copyWith(
        status: StockAdjustmentHistoryStatus.loaded,
        adjustments: adjustments,
        loading: false,
       //  selectedAdjustment: adjustments.isNotEmpty ? adjustments.first : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StockAdjustmentHistoryStatus.error,
        loading: false,
        error: 'Failed to load adjustment history. Please try again.',
      ));
    }
  }

  Future<void> refresh() => loadAdjustments();

  void selectAdjustment(AdjustmentModel adjustment) {
    if (state.selectedAdjustment?.id == adjustment.id) return;
    emit(state.copyWith(selectedAdjustment: adjustment));
  }

  void clearSelection() {
    emit(state.copyWith(selectedAdjustment: null));
  }

  void updateSearchText(String value) {
    emit(state.copyWith(searchText: value));
  }

  void updateDateRange(DateRangeFilter range) {
    emit(state.copyWith(selectedDateRange: range));
  }

  void updateReason(AdjustmentReason? reason) {
    emit(state.copyWith(
      selectedReason: reason,
      clearSelectedReason: reason == null,
    ));
  }

  void updateStatus(AdjustmentStatus? status) {
    emit(state.copyWith(
      selectedStatus: status,
      clearSelectedStatus: status == null,
    ));
  }

  void updateEmployee(String? employee) {
    emit(state.copyWith(
      selectedEmployee: employee,
      clearSelectedEmployee: employee == null,
    ));
  }

  void resetFilters() {
    emit(state.copyWith(
      searchText: '',
      selectedDateRange: DateRangeFilter.last30Days,
      clearSelectedReason: true,
      clearSelectedStatus: true,
      clearSelectedEmployee: true,
    ));
  }
}
