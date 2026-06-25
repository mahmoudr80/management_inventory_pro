import 'package:equatable/equatable.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/pos_product.dart';

/// High level lifecycle status of the POS cart operations.
enum PosStatus {
  initial,
  loading,
  success,
  failure,
}

/// Identifies which specific cart action most recently produced the
/// current states.
///
/// Lets the UI react to a specific action (e.g. show a "Sale completed"
/// snackbar only when [ActionStatus.completeSale] succeeds, or flash an
/// item row when [ActionStatus.addItem] fires) without diffing the whole
/// states object.
enum ActionStatus {
  none,
  addItem,
  removeItem,
  increaseQuantity,
  decreaseQuantity,
  clearCart,
  completeSale,
}

/// Immutable states for the POS (Point of Sale) feature.
///
/// [PosState] never exposes a way to mutate [cart] (or anything inside it)
/// in place. Every change is produced by [PosCubit] via [copyWith], which
/// always returns a brand new instance.
class PosState extends Equatable {
  final PosStatus status;
  final ActionStatus actionStatus;
  final CartModel? cart;
  final String? errorMessage;

  /// Every product currently loaded for the POS screen (i.e. already
  /// fetched from the repository). Search filters this list — it is never
  /// touched by [PosCubit.searchProducts] itself, only read from.
  final List<PosProduct> allProducts;

  /// The subset of [allProducts] that matches [searchQuery]. This is what
  /// the product grid should render. Equal to [allProducts] whenever
  /// [searchQuery] is empty.
  final List<PosProduct> filteredProducts;

  /// The current search term, already trimmed of leading/trailing spaces.
  /// Empty string means "no active search" (show everything).
  final String searchQuery;

  const PosState({
    this.status = PosStatus.initial,
    this.actionStatus = ActionStatus.none,
    this.cart,
    this.errorMessage,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.searchQuery = '',
  });

  /// The cubit's starting states: nothing loaded yet, no cart, no error.
  factory PosState.initial() => const PosState();

  /// Number of unique product line items in the cart. `0` when there is
  /// no cart yet.
  int get totalItems => cart?.totalItems ?? 0;

  /// Sum of all item quantities in the cart. `0` when there is no cart yet.
  num get totalQuantity => cart?.totalQuantity ?? 0;

  /// Sum of (quantity × sellingPrice) for every item in the cart. `0` when
  /// there is no cart yet.
  num get totalAmount => cart?.totalAmount ?? 0;

  /// True when there is a cart and it contains at least one item.
  bool get hasItems => cart != null && cart!.items.isNotEmpty;

  /// True when a search is active but it matched nothing — the trigger for
  /// the "No products found" empty states in the UI.
  bool get hasNoSearchResults => searchQuery.isNotEmpty && filteredProducts.isEmpty;

  /// Returns a copy of this states with the given fields replaced.
  ///
  /// [cart] and [errorMessage] are nullable fields. Dart's `??` operator
  /// alone can't distinguish "field not passed" from "field explicitly set
  /// to null", so [resetCart] and [clearError] are provided as explicit
  /// flags to null out those fields on purpose (e.g. resetting the cart
  /// after [ActionStatus.completeSale], or clearing a stale error once a
  /// later action succeeds).
  PosState copyWith({
    PosStatus? status,
    ActionStatus? actionStatus,
    CartModel? cart,
    bool resetCart = false,
    String? errorMessage,
    bool clearError = false,
    List<PosProduct>? allProducts,
    List<PosProduct>? filteredProducts,
    String? searchQuery,
  }) {
    return PosState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      cart: resetCart ? null : (cart ?? this.cart),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        status,
        actionStatus,
        cart,
        errorMessage,
        allProducts,
        filteredProducts,
        searchQuery,
      ];

  @override
  String toString() {
    return 'PosState(status: $status, actionStatus: $actionStatus, '
        'totalItems: $totalItems, totalQuantity: $totalQuantity, '
        'totalAmount: $totalAmount, errorMessage: $errorMessage, '
        'searchQuery: "$searchQuery", allProducts: ${allProducts.length}, '
        'filteredProducts: ${filteredProducts.length})';
  }
}
