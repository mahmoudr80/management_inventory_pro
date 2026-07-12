import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/features/pos/data/models/pos_product.dart';
import 'package:management_inventory_pro/core/services/sale_calculator.dart';

class CartItemModel {
  final String id;
  final PosProduct product;
  final String variant;
  int quantity;

  CartItemModel({
    required this.product,
    this.variant = '',
    this.quantity = 1,
    required this.id,
  });

  double get lineTotal => product.price * quantity;

  Map<String, Object?> toMap() => {
    DatabaseConstants.idColumn: id,
    DatabaseConstants.productIdColumn: product.id,
    DatabaseConstants.sellingPriceColumn: product.price,
    DatabaseConstants.quantityColumn: quantity,
    DatabaseConstants.totalColumn: lineTotal,
    // Snapshot the product's cost at the exact moment this line was
    // added to a sale — the only point in the system where "current
    // cost" and "cost at time of sale" are guaranteed to be the same
    // value. Once written, this never changes even if the product's
    // cost_price is later updated by a new stock receipt.
    DatabaseConstants.costPriceAtSaleColumn: product.costPrice,
  };
}

class CartModel {
  final String id;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CartItemModel> items;

  /// Tax/discount breakdown for this cart, always produced by
  /// [SaleCalculator] — never computed here or by any widget. Defaults to
  /// [SaleTotals.zero] only for the very first instant a brand-new cart
  /// is constructed, before `PosCubit` immediately rebuilds it with real
  /// totals.
  final SaleTotals totals;

  const CartModel({
    required this.id,
    this.note,
    this.createdAt,
    this.updatedAt,
    required this.items,
    this.totals = const SaleTotals.zero(),
  });

  int get totalItems => items.length;

  num get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  /// Raw sum of line totals (`price * quantity`), before discount/tax.
  /// This is the value fed into [SaleCalculator.calculate] as its
  /// `subtotal` input — it is NOT what the customer pays. Use
  /// `totals.grandTotal` for that.
  double get rawItemsTotal =>
      items.fold(0.0, (sum, item) => sum + item.lineTotal);

  CartModel copyWith({
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CartItemModel>? items,
    SaleTotals? totals,
  }) {
    return CartModel(
      id: id,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      totals: totals ?? this.totals,
    );
  }

  Map<String, Object?> toMap() => {
    DatabaseConstants.idColumn: id,
    DatabaseConstants.totalItemColumn: totalItems,
    DatabaseConstants.totalQuantityColumn: totalQuantity,
    DatabaseConstants.subtotalColumn: totals.subtotal,
    DatabaseConstants.discountAmountColumn: totals.discountAmount,
    DatabaseConstants.taxEnabledColumn: totals.taxEnabled ? 1 : 0,
    DatabaseConstants.taxPercentageColumn: totals.taxPercentage,
    DatabaseConstants.taxAmountColumn: totals.taxAmount,
    // "total_amount" is the sale's grand total (post discount/tax),
    // matching what CompleteSaleButton confirms and charges.
    DatabaseConstants.totalAmountColumn: totals.grandTotal,
    DatabaseConstants.noteColumn: note,
    DatabaseConstants.createdAtColumn: (createdAt ?? DateTime.now())
        .toIso8601String()
        .split('.')
        .first
        .replaceFirst('T', ' '),
    DatabaseConstants.updatedAtColumn: (updatedAt ?? DateTime.now())
        .toIso8601String()
        .split('.')
        .first
        .replaceFirst('T', ' '),
  };
}