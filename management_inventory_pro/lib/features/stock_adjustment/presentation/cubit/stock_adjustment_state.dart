import '../../data/models/stock_adjustment_item_model.dart';
import '../../data/models/stock_adjustment_model.dart';

sealed class StockAdjustmentState {
  const StockAdjustmentState();
}

/// Initial state before loading mock data or creating a new adjustment.
final class StockAdjustmentInitial extends StockAdjustmentState {
  const StockAdjustmentInitial();
}

/// Optional loading state.
final class StockAdjustmentLoading extends StockAdjustmentState {
  const StockAdjustmentLoading();
}

/// Main screen state.
/// The page should spend almost all of its lifetime in this state.
final class StockAdjustmentLoaded extends StockAdjustmentState {
  const StockAdjustmentLoaded({
    required this.adjustment,
    this.searchQuery = '',
    this.searchResults = const [],
    this.isSearching = false,
    this.isSaving = false,
    this.isDraftSaved = false,
    this.selectedRowId,
    this.showCompleteDialog = false,
    this.successMessage,
    this.errorMessage,
  });

  /// Current draft adjustment.
  final StockAdjustmentModel adjustment;

  /// Product search query.
  final String searchQuery;

  /// Filtered search results.
  final List<StockAdjustmentItemModel> searchResults;

  /// Indicates whether search is currently active.
  final bool isSearching;

  /// Indicates whether the adjustment is currently being completed.
  final bool isSaving;

  /// Whether the draft has been saved.
  final bool isDraftSaved;

  /// Selected table row.
  final String? selectedRowId;

  /// Triggers confirmation dialog.
  final bool showCompleteDialog;

  /// One-time success message.
  ///
  /// Emit, show snackbar, then clear.
  final String? successMessage;

  /// One-time error message.
  ///
  /// Emit, show snackbar/dialog, then clear.
  final String? errorMessage;

  StockAdjustmentLoaded copyWith({
    StockAdjustmentModel? adjustment,
    String? searchQuery,
    List<StockAdjustmentItemModel>? searchResults,
    bool? isSearching,
    bool? isSaving,
    bool? isDraftSaved,
    String? selectedRowId,
    bool clearSelectedRow = false,
    bool? showCompleteDialog,
    String? successMessage,
    bool clearSuccessMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return StockAdjustmentLoaded(
      adjustment: adjustment ?? this.adjustment,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      isSaving: isSaving ?? this.isSaving,
      isDraftSaved: isDraftSaved ?? this.isDraftSaved,
      selectedRowId: clearSelectedRow
          ? null
          : (selectedRowId ?? this.selectedRowId),
      showCompleteDialog:
      showCompleteDialog ?? this.showCompleteDialog,
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Fatal screen error.
///
/// Used when the page cannot continue,
/// such as failing to load required data.
final class StockAdjustmentError extends StockAdjustmentState {
  const StockAdjustmentError({
    required this.message,
  });

  final String message;
}