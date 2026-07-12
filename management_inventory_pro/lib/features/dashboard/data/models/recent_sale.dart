import 'package:management_inventory_pro/features/pos/data/models/pos_product.dart';

import '../../../../core/database/database_constants.dart';
import '../../../sale_history/data/models/sale_item_model.dart';

class RecentSaleRef {
  final String id;
  final DateTime date;
  final String cashier;
  final double totalAmount;
  final SaleStatus status;
  final PaymentMethod paymentMethod;
  final List<RecentSaleItemRef> items;

  /// Tax-exclusive, pre-discount sum of line items, exactly as persisted
  /// on the sale at checkout time.
  final double subtotal;

  final double discountAmount;

  final bool taxEnabled;

  /// The tax percentage actually applied to this sale. `0` when
  /// [taxEnabled] is false.
  final double taxPercentage;

  final double taxAmount;

   RecentSaleRef({
    required this.id,
    required this.date,
    required this.cashier,
    required this.totalAmount,
    required this.status,
    required this.subtotal,
    required this.discountAmount,
    required this.taxEnabled,
    required this.taxPercentage,
    required this.taxAmount,
    List<RecentSaleItemRef>? items,
    this.paymentMethod=PaymentMethod.cash,
  }) : items = items ?? <RecentSaleItemRef>[];
  int get totalItems => items.length;

  int get totalQuantity =>
      items.fold(0, (sum, e) => sum + e.quantity);

  factory RecentSaleRef.fromMap(Map<String, Object?> map) {
    return RecentSaleRef(
      id: map[DatabaseConstants.saleIdColumn] as String,
      date: DateTime.parse(
        map[DatabaseConstants.createdAtColumn] as String,
      ),
      cashier: (map[DatabaseConstants.cashierNameColumn] as String?) ?? 'Admin',
      totalAmount: (map[DatabaseConstants.totalAmountColumn] as num).toDouble(),
      subtotal: ((map[DatabaseConstants.subtotalColumn] as num?) ?? 0).toDouble(),
      discountAmount: ((map[DatabaseConstants.discountAmountColumn] as num?) ?? 0).toDouble(),
      taxEnabled: ((map[DatabaseConstants.taxEnabledColumn] as int?) ?? 0) == 1,
      taxPercentage: ((map[DatabaseConstants.taxPercentageColumn] as num?) ?? 0).toDouble(),
      taxAmount: ((map[DatabaseConstants.taxAmountColumn] as num?) ?? 0).toDouble(),
      paymentMethod: PaymentMethod.values.firstWhere(
            (e) => e.name == map[DatabaseConstants.paymentMethodColumn],
        orElse: () => PaymentMethod.cash,
      ),
      status: SaleStatus.values.firstWhere(
            (e) => e.name == map[DatabaseConstants.statusColumn],
        orElse: () => SaleStatus.completed,
      ),
      items: [],
    );
  }}

class RecentSaleItemRef {
  final PosProduct product;
  final int quantity;
  final String id;
  final double sellingPrice;

  const RecentSaleItemRef({
    required this.product,
    required this.quantity,
    required this.sellingPrice, required this.id,
  });

  double get total => quantity * sellingPrice;
// recent_sale.dart
  factory RecentSaleItemRef.fromMap(Map<String, Object?> map) {
    return RecentSaleItemRef(
      id: map[DatabaseConstants.saleItemId] as String,
      quantity: (map[DatabaseConstants.quantityColumn] as num).toInt(),
      sellingPrice: (map[DatabaseConstants.sellingPriceColumn] as num).toDouble(),
      product: PosProduct(
        id: map[DatabaseConstants.productIdColumn] as String,
        name: map[DatabaseConstants.nameColumn] as String,
        price: (map[DatabaseConstants.productPrice] as num).toDouble(),
        costPrice: ((map[DatabaseConstants.costPriceAtSaleColumn] as num?) ??
            (map[DatabaseConstants.productCostPrice] as num?) ??
            0)
            .toDouble(),
        imageUrl: map[DatabaseConstants.imageUrlColumn] as String?,
        sku: map[DatabaseConstants.skuColumn] as String?,
        barcode: map[DatabaseConstants.barcodeColumn] as String?,
      ),
    );
  }
}