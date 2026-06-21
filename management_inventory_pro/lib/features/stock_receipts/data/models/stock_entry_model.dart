import 'package:management_inventory_pro/features/stock_receipts/data/models/stock_entry_line_model.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/stock_entry_status.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/supplier_ref.dart';

import '../../../../core/database/database_constants.dart';

class StockEntryModel {
  final String id;          // e.g. "REC-2024-0892"
  final SupplierRef supplier;
  final DateTime receiptDate;
  final List<StockEntryLineModel> lines;
  final String? notes;
  final StockEntryStatus ?status;
  final DateTime ?createdAt;
  final DateTime ?updatedAt;
  final int ?totalItems;
  final double? totalQuantity;
  final double ?totalCost;
  const StockEntryModel({
    required this.id,
    required this.supplier,
    required this.receiptDate,
    required this.lines,
    this.notes,
     this.status,
     this.createdAt,
     this.updatedAt, this.totalItems=0, this.totalQuantity=0, this.totalCost=0,
  });



  // ── Factory / serialisation ────────────────────────────────────────────────

  factory StockEntryModel.fromMap(Map<String, dynamic> map) {
    return StockEntryModel(
      id: map[DatabaseConstants.stockEntryIdColumn] as String,
      receiptDate: DateTime.parse(map[DatabaseConstants.receiptDateColumn] as String),
      lines:[],
      notes: map[DatabaseConstants.noteColumn] as String?,
      status: StockEntryStatus.verified,
      createdAt: DateTime.parse(map[DatabaseConstants.createdAtColumn] as String),
      updatedAt: DateTime.parse(map[DatabaseConstants.updatedAtColumn] as String),
        supplier: SupplierRef.fromMap(map),
      totalCost:  map[DatabaseConstants.totalCostColumn] as double?,
      totalItems:  map[DatabaseConstants.totalItemColumn] as int?,
      totalQuantity:  map[DatabaseConstants.totalQuantityColumn] as double?,
    );

  }

  Map<String, dynamic> toMap() => {
        DatabaseConstants.idColumn: id,
        DatabaseConstants.supplierIdColumn: supplier.id,
        DatabaseConstants.receiptDateColumn: receiptDate.toIso8601String()
            .split('.')
            .first
            .replaceFirst('T', ' ').toString(),
        DatabaseConstants.noteColumn: notes,
        DatabaseConstants.createdAtColumn: (createdAt??DateTime.now()).toIso8601String()
            .split('.')
            .first
            .replaceFirst('T', ' ').toString(),
        DatabaseConstants.updatedAtColumn: (updatedAt??DateTime.now()).toIso8601String()
            .split('.')
            .first
            .replaceFirst('T', ' ').toString(),
        DatabaseConstants.totalItemColumn: totalItems,
        DatabaseConstants.totalQuantityColumn: totalQuantity,
        DatabaseConstants.totalCostColumn: totalCost,

      };

  StockEntryModel copyWith({
    String? id,
   SupplierRef ?supplier,
    DateTime? receiptDate,
    List<StockEntryLineModel>? lines,
    String? notes,
    StockEntryStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      StockEntryModel(
        id: id ?? this.id,
        supplier: supplier ?? this.supplier,
        receiptDate: receiptDate ?? this.receiptDate,
        lines: lines ?? this.lines,
        notes: notes ?? this.notes,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}



