import 'package:management_inventory_pro/features/pos/data/models/pos_product.dart';

import '../../../sale_history/data/models/sale_item_model.dart';

class RecentSale {
  final String id;
  final DateTime date;
  final String cashier;
  final double amount;
  final SaleStatus status;
  final PaymentMethod paymentMethod;
  final List<RecentSaleItem> items;

  const RecentSale({
    required this.id,
    required this.date,
    required this.cashier,
    required this.amount,
    required this.status,
    this.items = const [],
    this.paymentMethod=PaymentMethod.cash,
  });
}

class RecentSaleItem {
  final PosProduct product;
  final int quantity;
  final String id;
  final double sellingPrice;

  const RecentSaleItem({
    required this.product,
    required this.quantity,
    required this.sellingPrice, required this.id,
  });

  double get total => quantity * sellingPrice;
}