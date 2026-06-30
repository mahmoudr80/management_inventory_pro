import '../../data/models/adjustment_reason.dart';
import '../../data/models/stock_adjustment_item_model.dart';
import '../../data/models/stock_adjustment_model.dart';

sealed class StockAdjustmentState {}

class StockAdjustmentInitial extends StockAdjustmentState {}

class StockAdjustmentLoaded extends StockAdjustmentState {
  final StockAdjustmentModel adjustment;
  final String searchQuery;
  final List<StockAdjustmentItemModel> searchResults;
  final bool isSearching;
  final bool isDraftSaved;
  final String? selectedRowId;
  final bool showCompleteDialog;

  StockAdjustmentLoaded({
    required this.adjustment,
    this.searchQuery = '',
    this.searchResults = const [],
    this.isSearching = false,
    this.isDraftSaved = false,
    this.selectedRowId,
    this.showCompleteDialog = false,
  });

  StockAdjustmentLoaded copyWith({
    StockAdjustmentModel? adjustment,
    String? searchQuery,
    List<StockAdjustmentItemModel>? searchResults,
    bool? isSearching,
    bool? isDraftSaved,
    String? selectedRowId,
    bool clearSelectedRow = false,
    bool? showCompleteDialog,
  }) =>
      StockAdjustmentLoaded(
        adjustment: adjustment ?? this.adjustment,
        searchQuery: searchQuery ?? this.searchQuery,
        searchResults: searchResults ?? this.searchResults,
        isSearching: isSearching ?? this.isSearching,
        isDraftSaved: isDraftSaved ?? this.isDraftSaved,
        selectedRowId: clearSelectedRow ? null : selectedRowId ?? this.selectedRowId,
        showCompleteDialog: showCompleteDialog ?? this.showCompleteDialog,
      );
}

class StockAdjustmentCompleted extends StockAdjustmentState {
  final StockAdjustmentModel adjustment;
  StockAdjustmentCompleted({required this.adjustment});
}

class StockAdjustmentDiscarded extends StockAdjustmentState {}

class StockAdjustmentError extends StockAdjustmentState {
  final String message;
  StockAdjustmentError({required this.message});
}
