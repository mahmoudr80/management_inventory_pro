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

   RecentSaleRef({
    required this.id,
    required this.date,
    required this.cashier,
    required this.totalAmount,
    required this.status,
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
      cashier: map[DatabaseConstants.cashierNameColumn] as String,
      totalAmount: (map[DatabaseConstants.totalAmountColumn] as num).toDouble(),
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
  factory RecentSaleItemRef.fromMap(Map<String, Object?> map) {
    return RecentSaleItemRef(
      id: map[DatabaseConstants.saleItemId] as String,
      quantity: (map[DatabaseConstants.quantityColumn] as num).toInt(),
      sellingPrice:
      (map[DatabaseConstants.sellingPriceColumn] as num).toDouble(),
      product: PosProduct(
        id: map[DatabaseConstants.productIdColumn] as String,
        name: map[DatabaseConstants.nameColumn] as String,
        price: (map[DatabaseConstants.productPrice] as num).toDouble(),
        imageUrl: map[DatabaseConstants.imageUrlColumn] as String?,
        sku: map[DatabaseConstants.skuColumn] as String?,
        barcode: map[DatabaseConstants.barcodeColumn] as String?,
      ),
    );
  }
}