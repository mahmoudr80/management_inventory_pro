import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/stock_adjustment/data/repository/stock_adjustment_repository.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/adjustment_reason.dart';
import '../../data/models/stock_adjustment_item_model.dart';
import '../../data/models/stock_adjustment_model.dart';
import 'stock_adjustment_state.dart';

class StockAdjustmentCubit extends Cubit<StockAdjustmentState> {
  StockAdjustmentCubit(this._repository) : super(StockAdjustmentInitial());
final StockAdjustmentRepository _repository;

  void initialize() {
    emit(StockAdjustmentLoaded(adjustment: StockAdjustmentModel(id: Uuid().v4(),
        status: AdjustmentStatus.completed)));
  }

  StockAdjustmentLoaded? get _loaded =>
      state is StockAdjustmentLoaded ? state as StockAdjustmentLoaded : null;

  void searchProducts(String query) {
    final loaded = _loaded;
    if (loaded == null) return;

    final q = query.toLowerCase().trim();
    if (q.isEmpty) {
      emit(loaded.copyWith(searchQuery: query, searchResults: [], isSearching: false));
      return;
    }

    final existingIds = loaded.adjustment.items.map((e) => e.productId).toSet();
    final results = loaded.adjustment.items
        .where((p) =>
            !existingIds.contains(p.productId) &&
            (p.productName.toLowerCase().contains(q) ||
                p.sku.toLowerCase().contains(q) ||
                (p.barcode??'').contains(q)))
        .toList();

    emit(loaded.copyWith(
      searchQuery: query,
      searchResults: results,
      isSearching: true,
    ));
  }

  void clearSearch() {
    final loaded = _loaded;
    if (loaded == null) return;
    emit(loaded.copyWith(searchQuery: '', searchResults: [], isSearching: false));
  }

  void addProduct(StockAdjustmentItemModel product) {
    final loaded = _loaded;
    if (loaded == null) return;

    final alreadyExists =
        loaded.adjustment.items.any((i) => i.productId == product.productId);
    if (alreadyExists) return;

    final newItem = product.copyWith(adjustmentQty: 0);
    final updated = List<StockAdjustmentItemModel>.from(loaded.adjustment.items)
      ..add(newItem);

    emit(loaded.copyWith(
      adjustment: loaded.adjustment.copyWith(items: updated),
      searchQuery: '',
      searchResults: [],
      isSearching: false,
      isDraftSaved: false,
    ));
  }

  void removeProduct(String itemId) {
    final loaded = _loaded;
    if (loaded == null) return;

    final updated =
        loaded.adjustment.items.where((i) => i.id != itemId).toList();

    emit(loaded.copyWith(
      adjustment: loaded.adjustment.copyWith(items: updated),
      isDraftSaved: false,
      clearSelectedRow: loaded.selectedRowId == itemId,
    ));
  }

  void updateAdjustmentQty(String itemId, int qty) {
    final loaded = _loaded;
    if (loaded == null) return;

    final updated = loaded.adjustment.items
        .map((i) => i.id == itemId ? i.copyWith(adjustmentQty: qty) : i)
        .toList();

    emit(loaded.copyWith(
      adjustment: loaded.adjustment.copyWith(items: updated),
      isDraftSaved: false,
    ));
  }

  void updateReason(AdjustmentReason? reason) {
    final loaded = _loaded;
    if (loaded == null) return;

    if (reason == null) {
      emit(loaded.copyWith(
        adjustment: loaded.adjustment.copyWith(clearReason: true),
        isDraftSaved: false,
      ));
    } else {
      emit(loaded.copyWith(
        adjustment: loaded.adjustment.copyWith(reason: reason),
        isDraftSaved: false,
      ));
    }
  }

  void selectRow(String? rowId) {
    final loaded = _loaded;
    if (loaded == null) return;
    if (loaded.selectedRowId == rowId) {
      emit(loaded.copyWith(clearSelectedRow: true));
    } else {
      emit(loaded.copyWith(selectedRowId: rowId));
    }
  }

  void saveDraft() {
    final loaded = _loaded;
    if (loaded == null) return;
    emit(loaded.copyWith(isDraftSaved: true));
  }

  void discardDraft() {
    final loaded = _loaded;
    if (loaded == null) return;

    final newAdjustment = StockAdjustmentModel(
      id: Uuid().v4(),
      createdBy: loaded.adjustment.createdBy,
      createdAt: DateTime.now(),
      status: AdjustmentStatus.draft,
      items: const [],
    );

    emit(
      loaded.copyWith(
        adjustment: newAdjustment,
        searchQuery: '',
        searchResults: const [],
        isDraftSaved: false,
        clearSelectedRow: true,
      ),
    );
  }
  void clearSuccessMessage() {
    final loaded = _loaded;
    if (loaded == null) return;

    emit(
      loaded.copyWith(
        clearSuccessMessage: true,
      ),
    );
  }
  void clearErrorMessage() {
    final loaded = _loaded;
    if (loaded == null) return;

    emit(
      loaded.copyWith(
        clearErrorMessage: true,
      ),
    );
  }
  void requestCompleteAdjustment() {
    final loaded = _loaded;
    if (loaded == null ) return;
    emit(loaded.copyWith(showCompleteDialog: true));
  }

  void dismissCompleteDialog() {
    final loaded = _loaded;
    if (loaded == null) return;
    emit(loaded.copyWith(showCompleteDialog: false));
  }

  Future<void> completeAdjustment() async {
    final loaded = _loaded;
    if (loaded == null) return;

    if(loaded.adjustment.reason==null){
      emit(
        loaded.copyWith(
          showCompleteDialog: false,
          errorMessage: 'you should choose a reason.',
        ),
      );
      return;
    }

    final response = await _repository.addStockAdjustment(
      loaded.adjustment,
    );

    switch (response) {
      case Success():
        final completed = loaded.adjustment.copyWith(
          status: AdjustmentStatus.completed,
        );

        emit(
          loaded.copyWith(
            adjustment: completed,
            showCompleteDialog: false,
            successMessage: 'Stock adjustment completed successfully.',
          ),
        );

      case Failure(errorModel: final error):
        emit(
          StockAdjustmentError(
            message: error.message,
          ),
        );
    }
  }}
