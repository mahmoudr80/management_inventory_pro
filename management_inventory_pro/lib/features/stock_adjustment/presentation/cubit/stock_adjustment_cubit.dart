import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/mock/mock_adjustments.dart';
import '../../data/mock/mock_products.dart';
import '../../data/models/adjustment_reason.dart';
import '../../data/models/stock_adjustment_item_model.dart';
import '../../data/models/stock_adjustment_model.dart';
import 'stock_adjustment_state.dart';

class StockAdjustmentCubit extends Cubit<StockAdjustmentState> {
  StockAdjustmentCubit() : super(StockAdjustmentInitial());

  void initialize() {
    emit(StockAdjustmentLoaded(adjustment: MockAdjustments.sampleDraft));
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
    final results = MockProductCatalog.products
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
    emit(StockAdjustmentDiscarded());
  }

  void requestCompleteAdjustment() {
    final loaded = _loaded;
    if (loaded == null) return;
    emit(loaded.copyWith(showCompleteDialog: true));
  }

  void dismissCompleteDialog() {
    final loaded = _loaded;
    if (loaded == null) return;
    emit(loaded.copyWith(showCompleteDialog: false));
  }

  void completeAdjustment() {
    final loaded = _loaded;
    if (loaded == null) return;

    final completed = loaded.adjustment.copyWith(
      status: AdjustmentStatus.completed,
    );
    emit(StockAdjustmentCompleted(adjustment: completed));
  }
}
