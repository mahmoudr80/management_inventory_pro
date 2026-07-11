import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/features/sale_history/data/models/sale_item_model.dart';

/// A completed sale, as persisted in the `sales` table.
///
/// Design notes:
/// * [subtotal], [discountAmount], [taxEnabled], [taxPercentage],
///   [taxAmount] and [totalAmount] are always the exact values that were
///   computed by `SaleCalculator` and saved at the moment the sale was
///   completed (see `PosCubit.completeSale` / `CartModel.toMap`). They
///   are read straight back from the `sales` row in [SaleModel.fromMap]
///   and are **never** recalculated here — a historical sale must keep
///   showing whatever tax/discount actually applied at checkout, even if
///   tax settings change afterwards.
/// * [totalAmount] in particular used to be a getter that resummed
///   `item.total` across [items]. That was wrong: it silently ignored
///   any discount/tax that had been charged and just re-derived a raw
///   total from current line items. It is now a plain stored field
///   sourced from the persisted `total_amount` column.
class SaleModel {
  final String id;

  final List<SaleItemModel> items;

  final String? notes;

  /// Raw sum of line items, tax-exclusive, before discount — exactly as
  /// computed by `SaleCalculator` at checkout time.
  final double subtotal;

  final double discountAmount;

  final bool taxEnabled;

  /// The tax percentage that was actually applied to this sale. `0` when
  /// [taxEnabled] is false.
  final double taxPercentage;

  final double taxAmount;

  /// Final amount the customer paid for this sale (post discount/tax),
  /// as persisted — never recomputed from [items].
  final double totalAmount;

  final String cashierName;

  final PaymentMethod paymentMethod;

  final SaleStatus status;

  final DateTime createdAt;

  final DateTime updatedAt;

  const SaleModel({
    required this.id,
    required this.items,
    required this.cashierName,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.subtotal,
    required this.discountAmount,
    required this.taxEnabled,
    required this.taxPercentage,
    required this.taxAmount,
    required this.totalAmount,
    this.notes,
  });

  int get totalItems => items.length;

  int get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);

  bool get isCompleted => status == SaleStatus.completed;

  factory SaleModel.fromMap({
    required String saleId,
    required Map<String, Object?> map,
  }) {
    return SaleModel(
      id: saleId,
      items: [],
      cashierName: (map[DatabaseConstants.cashierNameColumn] ?? 'Admin') as String,

      paymentMethod: PaymentMethod.values.firstWhere(
            (e) => e.name.toLowerCase() ==
            ((map[DatabaseConstants.paymentMethodColumn] ?? 'Cash') as String).toLowerCase(),
      ),

      status: SaleStatus.values.firstWhere(
            (e) => e.name.toLowerCase() ==
            ((map[DatabaseConstants.statusColumn] ?? 'Completed') as String).toLowerCase(),
      ),

      notes: map[DatabaseConstants.noteColumn] as String?,

      subtotal: ((map[DatabaseConstants.subtotalColumn] as num?) ?? 0).toDouble(),
      discountAmount: ((map[DatabaseConstants.discountAmountColumn] as num?) ?? 0).toDouble(),
      taxEnabled: ((map[DatabaseConstants.taxEnabledColumn] as int?) ?? 0) == 1,
      taxPercentage: ((map[DatabaseConstants.taxPercentageColumn] as num?) ?? 0).toDouble(),
      taxAmount: ((map[DatabaseConstants.taxAmountColumn] as num?) ?? 0).toDouble(),
      totalAmount: ((map[DatabaseConstants.totalAmountColumn] as num?) ?? 0).toDouble(),

      createdAt: DateTime.parse(
        map[DatabaseConstants.createdAtColumn] as String,
      ),
      updatedAt: DateTime.parse(
        map[DatabaseConstants.updatedAtColumn] as String,
      ),
    );
  }
}