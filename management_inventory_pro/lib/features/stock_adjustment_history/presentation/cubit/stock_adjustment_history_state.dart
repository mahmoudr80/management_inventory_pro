import 'package:equatable/equatable.dart';

import '../../data/models/adjustment_history_kpis.dart';
import '../../data/models/adjustment_model.dart';
import '../../data/models/adjustment_reason.dart';
import '../../data/models/adjustment_status.dart';
import '../../data/models/date_range_filter.dart';

/// Load lifecycle for the history list.
enum StockAdjustmentHistoryStatus { initial, loading, loaded, error }

/// Single immutable state object for [StockAdjustmentHistoryCubit].
///
/// Filtering is derived (pure) via [filteredAdjustments] so the table,
/// KPI cards, and detail panel can each select only the slice of state
/// they actually depend on with `BlocSelector`.
class StockAdjustmentHistoryState extends Equatable {
  const StockAdjustmentHistoryState({
    this.status = StockAdjustmentHistoryStatus.initial,
    this.adjustments = const [],
    this.selectedAdjustment,
    this.searchText = '',
    this.selectedDateRange = DateRangeFilter.last30Days,
    this.selectedReason,
    this.selectedStatus,
    this.selectedEmployee,
    this.loading = false,
    this.error,
  });

  final StockAdjustmentHistoryStatus status;
  final List<AdjustmentModel> adjustments;
  final AdjustmentModel? selectedAdjustment;

  final String searchText;
  final DateRangeFilter selectedDateRange;
  final AdjustmentReason? selectedReason;
  final AdjustmentStatus? selectedStatus;
  final String? selectedEmployee;

  final bool loading;
  final String? error;

  bool get hasActiveFilters =>
      searchText.isNotEmpty ||
      selectedDateRange != DateRangeFilter.last30Days ||
      selectedReason != null ||
      selectedStatus != null ||
      selectedEmployee != null;

  /// Adjustments after applying search + filters. Pure derivation — does
  /// not mutate state, so it's safe to call from `build` methods.
  List<AdjustmentModel> get filteredAdjustments {
    final now = DateTime.now();
    final query = searchText.trim().toLowerCase();

    return adjustments.where((adjustment) {
      if (!selectedDateRange.includes(adjustment.dateTime, now)) return false;
      if (selectedReason != null && adjustment.reason != selectedReason) {
        return false;
      }
      if (selectedStatus != null && adjustment.status != selectedStatus) {
        return false;
      }
      if (selectedEmployee != null &&
          adjustment.createdBy != selectedEmployee) {
        return false;
      }
      if (query.isNotEmpty) {
        final matchesId = adjustment.id.toLowerCase().contains(query);
        final matchesProduct = adjustment.products.any(
          (product) =>
              product.productName.toLowerCase().contains(query) ||
              product.sku.toLowerCase().contains(query),
        );
        if (!matchesId && !matchesProduct) return false;
      }
      return true;
    }).toList();
  }

  AdjustmentHistoryKpis get kpis =>
      AdjustmentHistoryKpis.fromAdjustments(adjustments);
  static const _unset = Object();
  StockAdjustmentHistoryState copyWith({
    StockAdjustmentHistoryStatus? status,
    List<AdjustmentModel>? adjustments,
    Object? selectedAdjustment=_unset,
    bool clearSelectedAdjustment = false,
    String? searchText,
    DateRangeFilter? selectedDateRange,
    AdjustmentReason? selectedReason,
    bool clearSelectedReason = false,
    AdjustmentStatus? selectedStatus,
    bool clearSelectedStatus = false,
    String? selectedEmployee,
    bool clearSelectedEmployee = false,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return StockAdjustmentHistoryState(
      status: status ?? this.status,
      adjustments: adjustments ?? this.adjustments,
      selectedAdjustment: (selectedAdjustment==_unset ? this.selectedAdjustment : selectedAdjustment as AdjustmentModel?),
      searchText: searchText ?? this.searchText,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      selectedReason: clearSelectedReason
          ? null
          : (selectedReason ?? this.selectedReason),
      selectedStatus: clearSelectedStatus
          ? null
          : (selectedStatus ?? this.selectedStatus),
      selectedEmployee: clearSelectedEmployee
          ? null
          : (selectedEmployee ?? this.selectedEmployee),
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        status,
        adjustments,
        selectedAdjustment,
        searchText,
        selectedDateRange,
        selectedReason,
        selectedStatus,
        selectedEmployee,
        loading,
        error,
      ];
}
