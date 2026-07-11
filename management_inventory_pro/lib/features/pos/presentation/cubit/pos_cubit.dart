import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/core/services/sale_calculator.dart';
import 'package:management_inventory_pro/features/pos/data/repository/pos_repository.dart';
import 'package:management_inventory_pro/features/settings/data/models/settings_business_data.dart';
import 'package:management_inventory_pro/features/settings/data/repository/settings_repository.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/pos_product.dart';
import 'pos_state.dart';

class PosCubit extends Cubit<PosState> {
  PosCubit(this._repository, {SettingsRepository? settingsRepository})
      : _settingsRepository = settingsRepository,
        super(PosState.initial()) {
    _settingsFuture = _loadTaxSettings();
  }

  final PosRepository _repository;
  final SettingsRepository? _settingsRepository;
  final Uuid _uuid = const Uuid();

  late final Future<SettingsBusinessData?> _settingsFuture;

  Future<SettingsBusinessData?> _loadTaxSettings() async {
    final repository = _settingsRepository;
    if (repository == null) return null;

    final result = await repository.getBusinessSettings();
    return switch (result) {
      Success(data: final data) => data,
      Failure() => null,
    };
  }

  Future<void> addToCart(PosProduct product) async {
    try {
      final currentCart = state.cart;

      if (currentCart == null) {
        final newItem = _createItem(product);
        final newCart = await _rebuildCart(
          CartModel(
            id: _uuid.v4(),
            items: const [],
            createdAt: DateTime.now(),
          ),
          [newItem],
        );

        emit(
          state.copyWith(
            status: PosStatus.success,
            actionStatus: ActionStatus.addItem,
            cart: newCart,
            clearError: true,
          ),
        );
        return;
      }

      final updatedItems = [...currentCart.items];
      final existingIndex = updatedItems.indexWhere(
            (item) => item.product.id == product.id,
      );

      if (existingIndex != -1) {
        final existingItem = updatedItems[existingIndex];
        updatedItems[existingIndex] = _copyItemWithQuantity(
          existingItem,
          existingItem.quantity + 1,
        );
      } else {
        updatedItems.add(_createItem(product));
      }

      final rebuiltCart = await _rebuildCart(currentCart, updatedItems);

      emit(
        state.copyWith(
          status: PosStatus.success,
          actionStatus: ActionStatus.addItem,
          cart: rebuiltCart,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> increaseQuantity(String productId) async {
    try {
      final currentCart = state.cart;
      if (currentCart == null) return;

      final updatedItems = [...currentCart.items];
      final index = updatedItems.indexWhere(
            (item) => item.product.id == productId,
      );
      if (index == -1) return;

      final item = updatedItems[index];
      updatedItems[index] = _copyItemWithQuantity(item, item.quantity + 1);

      final rebuiltCart = await _rebuildCart(currentCart, updatedItems);

      emit(
        state.copyWith(
          status: PosStatus.success,
          actionStatus: ActionStatus.increaseQuantity,
          cart: rebuiltCart,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> decreaseQuantity(String productId) async {
    try {
      final currentCart = state.cart;
      if (currentCart == null) return;

      final updatedItems = [...currentCart.items];
      final index = updatedItems.indexWhere(
            (item) => item.product.id == productId,
      );
      if (index == -1) return;

      final item = updatedItems[index];

      if (item.quantity > 1) {
        updatedItems[index] = _copyItemWithQuantity(item, item.quantity - 1);
      } else {
        updatedItems.removeAt(index);
      }

      final rebuiltCart = await _rebuildCart(currentCart, updatedItems);

      emit(
        state.copyWith(
          status: PosStatus.success,
          actionStatus: ActionStatus.decreaseQuantity,
          cart: rebuiltCart,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> removeItem(String productId) async {
    try {
      final currentCart = state.cart;
      if (currentCart == null) return;

      final updatedItems = currentCart.items
          .where((item) => item.product.id != productId)
          .toList(growable: false);

      final rebuiltCart = await _rebuildCart(currentCart, updatedItems);

      emit(
        state.copyWith(
          status: PosStatus.success,
          actionStatus: ActionStatus.removeItem,
          cart: rebuiltCart,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> clearCart() async {
    try {
      emit(
        state.copyWith(
          status: PosStatus.success,
          actionStatus: ActionStatus.clearCart,
          resetCart: true,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void setProducts(List<PosProduct> products) {
    try {
      final allProducts = List<PosProduct>.unmodifiable(products);
      final filtered = _filterProducts(allProducts, state.searchQuery);

      emit(
        state.copyWith(
          allProducts: allProducts,
          filteredProducts: filtered,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void searchProducts(String query) {
    try {
      final normalizedQuery = query.trim();
      final filtered = _filterProducts(state.allProducts, normalizedQuery);

      emit(
        state.copyWith(
          searchQuery: normalizedQuery,
          filteredProducts: filtered,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PosStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Finalizes the current sale.
  ///
  /// FIX: previously, if [state.cart] was null this method emitted
  /// [PosStatus.loading] and then returned with no follow-up emission —
  /// the UI would show a permanent loading spinner with no way to
  /// recover. It now emits [PosStatus.failure] in that case instead, so
  /// "complete sale" with an empty cart always resolves to a visible,
  /// actionable state.
  Future<void> completeSale() async {
    if (state.cart == null) {
      emit(
        state.copyWith(
          status: PosStatus.failure,
          actionStatus: ActionStatus.completeSale,
          errorMessage: 'Cannot complete sale: cart is empty.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: PosStatus.loading,
        actionStatus: ActionStatus.completeSale,
        clearError: true,
      ),
    );

    final response = await _repository.completeSale(state.cart!);
    switch (response) {
      case Success():
        emit(
          state.copyWith(
            status: PosStatus.success,
            actionStatus: ActionStatus.completeSale,
            resetCart: true,
            clearError: true,
          ),
        );
      case Failure(errorModel: final error):
        emit(
          state.copyWith(
            status: PosStatus.failure,
            errorMessage: error.message,
          ),
        );
    }
  }

  CartItemModel _createItem(PosProduct product) {
    return CartItemModel(
      id: _uuid.v4(),
      product: product,
      variant: product.category,
      quantity: 1,
    );
  }

  CartItemModel _copyItemWithQuantity(CartItemModel item, int quantity) {
    return CartItemModel(
      id: item.id,
      product: item.product,
      variant: item.variant,
      quantity: quantity,
    );
  }

  List<PosProduct> _filterProducts(List<PosProduct> products, String query) {
    if (query.isEmpty) {
      return List<PosProduct>.unmodifiable(products);
    }

    final normalizedQuery = query.toLowerCase();

    return products.where((product) {
      final name = product.name.toLowerCase();
      final sku = (product.sku ?? '').toLowerCase();
      final barcode = (product.barcode ?? '').toLowerCase();

      return name.contains(normalizedQuery) ||
          sku.contains(normalizedQuery) ||
          barcode.contains(normalizedQuery);
    }).toList(growable: false);
  }

  Future<CartModel> _rebuildCart(
      CartModel baseCart,
      List<CartItemModel> items,
      ) async {
    final settings = await _settingsFuture;

    final rawTotal = items.fold<double>(
      0,
          (sum, item) => sum + item.lineTotal,
    );

    final totals = SaleCalculator.calculate(
      subtotal: rawTotal,
      discountAmount: 0,
      taxEnabled: settings?.taxEnabled ?? false,
      taxPercentage: settings?.taxPercentage ?? 0,
      // TODO(tax): SettingsBusinessData does not expose `prices_include_tax`
      // yet. Hardcoded to false (catalog prices are tax-exclusive) so this
      // compiles against the current Settings model. Once the Settings
      // feature adds `pricesIncludeTax` to SettingsBusinessData, swap this
      // back to `settings?.pricesIncludeTax ?? false` — no other POS code
      // needs to change, SaleCalculator already handles both branches.
      pricesIncludeTax: false,
    );

    return baseCart.copyWith(
      items: items,
      totals: totals,
      updatedAt: DateTime.now(),
    );
  }
}