import 'package:management_inventory_pro/features/sale_history/data/models/sale_item_model.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/product_ref.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/supplier_ref.dart';

import '../../../../core/database/database_constants.dart';

enum StockEntryStatus { received, inTransit, pending, cancelled }

class RecentStockEntryRef {
  final String receiptId;
  final SupplierRef supplier;
  final double totalCost;
  final StockEntryStatus status;
  final DateTime date;
  final List<RecentStockEntryLineRef> items;

  const RecentStockEntryRef({
    required this.receiptId,
    required this.supplier,
    required this.totalCost,
    required this.status,
    required this.date,
    this.items = const [],
  });
  int get totalItems => items.length;

  int get totalQuantity =>
      items.fold(0, (sum, e) => sum + e.quantity);

  factory RecentStockEntryRef.fromMap(Map<String, Object?> map) {
    return RecentStockEntryRef(
      receiptId: map[DatabaseConstants.stockEntryIdColumn] as String,
      supplier: SupplierRef(
        id: map[DatabaseConstants.supplierIdColumn] as String?,
        name: map[DatabaseConstants.companyNameColumn] as String,
      ),
      totalCost: (map[DatabaseConstants.totalCostColumn] as num).toDouble(),
      status: StockEntryStatus.received,
      date: DateTime.parse(
        map[DatabaseConstants.receiptDateColumn] as String,
      ),
      items: [],
    );
  }
}

class RecentStockEntryLineRef {
  final ProductRef product;
  final String id;
  final int quantity;
  final double unitCost;

  const RecentStockEntryLineRef({
    required this.product,
    required this.quantity,
    required this.unitCost, required this.id,
  });

  double get total => quantity * unitCost;
  factory RecentStockEntryLineRef.fromMap(Map<String, Object?> map) {
    return RecentStockEntryLineRef(
      id: map[DatabaseConstants.lineIdAlias] as String,
      product: ProductRef.fromMap(map),
      quantity: (map[DatabaseConstants.quantityColumn] as num).toInt(),
      unitCost: (map[DatabaseConstants.costPriceColumn] as num).toDouble(),
    );
  }
}