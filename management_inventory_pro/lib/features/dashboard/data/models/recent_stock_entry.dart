import 'package:management_inventory_pro/features/sale_history/data/models/sale_item_model.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/product_ref.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/supplier_ref.dart';

enum StockEntryStatus { received, inTransit, pending, cancelled }

class RecentStockEntry {
  final String receiptId;
  final SupplierRef supplier;
  final double totalCost;
  final StockEntryStatus status;
  final DateTime date;
  final List<RecentStockEntryLine> items;

  const RecentStockEntry({
    required this.receiptId,
    required this.supplier,
    required this.totalCost,
    required this.status,
    required this.date,
    this.items = const [],
  });
}

class RecentStockEntryLine {
  final ProductRef product;
  final String id;
  final int quantity;
  final double unitCost;

  const RecentStockEntryLine({
    required this.product,
    required this.quantity,
    required this.unitCost, required this.id,
  });

  double get total => quantity * unitCost;
}