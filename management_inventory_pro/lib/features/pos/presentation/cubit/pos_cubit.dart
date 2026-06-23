import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/pos/data/repository/pos_repository.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/pos_product.dart';
import 'pos_state.dart';

/// Cubit responsible for all POS cart and product-search business logic:
/// adding, updating and removing cart items, clearing the cart, completing
/// a sale, and filtering the already-loaded product catalog as the
/// cashier types into the search bar.
///
/// Design notes:
/// * State is never mutated in place. Every list is copied (`[...list]`)
///   before being changed, and every changed item/cart is rebuilt as a new
///   object via its `copyWith`/constructor rather than having a field
///   reassigned on the existing instance.
/// * Totals ([CartModel.totalItems], [CartModel.totalQuantity],
///   [CartModel.totalAmount]) are *never* incremented or decremented by
///   hand. They are always recalculated from scratch from the current list
///   of cart items (see [_rebuildCart]) so they can never drift out of
///   sync with the actual line items.
/// * Search never re-fetches from a repository. [setProducts] is the only
///   entry point for new product data (called by the data-loading layer);
///   [searchProducts] only ever re-filters [PosState.allProducts], which is
///   left completely untouched — only [PosState.filteredProducts] changes.
class PosCubit extends Cubit<PosState> {
  PosCubit(this._repository) : super(PosState.initial());
  final PosRepository _repository;
  final Uuid _uuid = const Uuid();

  // ---------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------

  /// Adds [product] to the cart.
  ///
  /// * If there is no cart yet, a new [CartModel] is created with a single
  ///   [CartItemModel] for [product].
  /// * If [product] is already in the cart, its line item's quantity is
  ///   incremented by 1.
  /// * Otherwise a new [CartItemModel] is appended to the cart.
  Future<void> addToCart(PosProduct product) async {
    try {
      final currentCart = state.cart;

      if (currentCart == null) {
        final newItem = _createItem(product);
        final newCart = _rebuildCart(
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

      final rebuiltCart = _rebuildCart(currentCart, updatedItems);

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

  /// Increases by 1 the quantity of the cart item whose product matches
  /// [productId].
  ///
  /// No-op if there is no cart or the product isn't in it.
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

      final rebuiltCart = _rebuildCart(currentCart, updatedItems);

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

  /// Decreases by 1 the quantity of the cart item whose product matches
  /// [productId].
  ///
  /// If the item's quantity is greater than 1, it is simply decremented.
  /// If the item's quantity is exactly 1, the item is removed from the
  /// cart entirely instead of letting it sit at quantity 0.
  ///
  /// No-op if there is no cart or the product isn't in it.
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

      final rebuiltCart = _rebuildCart(currentCart, updatedItems);

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

  /// Removes the cart item whose product matches [productId] entirely,
  /// regardless of its current quantity.
  ///
  /// No-op if there is no cart or the product isn't in it.
  Future<void> removeItem(String productId) async {
    try {
      final currentCart = state.cart;
      if (currentCart == null) return;

      final updatedItems = currentCart.items
          .where((item) => item.product.id != productId)
          .toList(growable: false);

      final rebuiltCart = _rebuildCart(currentCart, updatedItems);

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

  /// Removes every item from the cart and resets it (the next [addToCart]
  /// call will start a brand new [CartModel]).
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

  /// Registers (or refreshes) the full catalog of already-loaded products
  /// for the POS screen.
  ///
  /// Call this once the product-fetching layer (e.g. `ProductCubit`)
  /// successfully loads data — never re-fetches anything itself. The
  /// current [PosState.searchQuery] (if any) is immediately re-applied to
  /// [products] so an in-progress search stays consistent if the catalog
  /// refreshes underneath it.
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

  /// Filters the already-loaded [PosState.allProducts] by [query] and
  /// updates [PosState.filteredProducts] accordingly.
  ///
  /// * Never touches the database/repository — it only re-filters products
  ///   that are already in memory.
  /// * Case-insensitive, and ignores leading/trailing whitespace.
  /// * Matches against product name, SKU, and barcode.
  /// * An empty (or whitespace-only) [query] shows every product again.
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
  /// Emits [PosStatus.loading] while the (simulated) transaction is being
  /// processed, then emits [PosStatus.success] with
  /// [ActionStatus.completeSale] once it finishes and clears the cart so
  /// the POS screen is ready for the next customer.
  Future<void> completeSale() async {
    emit(
      state.copyWith(
        status: PosStatus.loading,
        actionStatus: ActionStatus.completeSale,
        clearError: true,
      ),
    );
    if(state.cart==null) {
      return;
    }
    final response =await _repository.completeSale(state.cart!);
    switch(response){
      case Success():
        emit(
          state.copyWith(
            status: PosStatus.success,
            actionStatus: ActionStatus.completeSale,
            resetCart: true,
            clearError: true,
          ),
        );
      case Failure(errorModel:final error):
        emit(
          state.copyWith(
            status: PosStatus.failure,
            errorMessage: error.message,
          ),
        );
    }

  }

  // ---------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------

  /// Builds a brand new [CartItemModel] with quantity 1 for [product].
  CartItemModel _createItem(PosProduct product) {
    return CartItemModel(
      id: _uuid.v4(),
      product: product,
      variant: product.category,
      quantity: 1,
    );
  }

  /// Returns a *new* [CartItemModel] with [quantity] applied, leaving
  /// [item] itself untouched (never does `item.quantity = ...`).
  CartItemModel _copyItemWithQuantity(CartItemModel item, int quantity) {
    return CartItemModel(
      id: item.id,
      product: item.product,
      variant: item.variant,
      quantity: quantity,
    );
  }

  /// Sum of (quantity × sellingPrice) across all [items].
  double _calculateTotalAmount(List<CartItemModel> items) {
    return items.fold<double>(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  /// Sum of all item quantities across [items].
  double _calculateTotalQuantity(List<CartItemModel> items) {
    return items.fold<double>(0, (sum, item) => sum + item.quantity);
  }

  /// Number of unique product line items in [items].
  int _calculateTotalItems(List<CartItemModel> items) {
    return items.length;
  }

  /// Returns a new, unmodifiable list containing only the [products] whose
  /// name, SKU, or barcode contains [query] (case-insensitive).
  ///
  /// [query] is expected to already be trimmed by the caller. An empty
  /// [query] short-circuits to "everything matches".
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

  /// Returns a new [CartModel] derived from [baseCart], with [items]
  /// applied and every total recalculated from scratch.
  ///
  /// Previously stored totals are never trusted or carried forward — they
  /// are always derived fresh from the current item list, which is the
  /// only way to guarantee they can't go stale or get out of sync.
  CartModel _rebuildCart(CartModel baseCart, List<CartItemModel> items) {
    return baseCart.copyWith(
      items: items,
      totalItems: _calculateTotalItems(items),
      totalQuantity: _calculateTotalQuantity(items),
      totalAmount: _calculateTotalAmount(items),
      updatedAt: DateTime.now(),
    );
  }
}
