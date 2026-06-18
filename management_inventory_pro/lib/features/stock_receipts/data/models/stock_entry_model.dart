import 'package:management_inventory_pro/features/stock_receipts/data/models/stock_entry_line_model.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/stock_entry_status.dart';

class StockEntryModel {
  final String id;          // e.g. "REC-2024-0892"
  final String? supplierId;
  final String? supplierName; // denormalized for display
  final DateTime receiptDate;
  final List<StockEntryLineModel> lines;
  final String? notes;
  final StockEntryStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StockEntryModel({
    required this.id,
    this.supplierId,
    this.supplierName,
    required this.receiptDate,
    required this.lines,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // ── Computed ───────────────────────────────────────────────────────────────

  int get totalItems => lines.fold(0, (sum, l) => sum + l.quantity);

  double get totalValue => lines.fold(0.0, (sum, l) => sum + l.lineTotal);

  // ── Factory / serialisation ────────────────────────────────────────────────

  factory StockEntryModel.fromMap(Map<String, dynamic> map) {
    return StockEntryModel(
      id: map['id'] as String,
      supplierId: map['supplier_id'] as String?,
      supplierName: map['supplier_name'] as String?,
      receiptDate: DateTime.parse(map['receipt_date'] as String),
      lines: (map['lines'] as List<dynamic>)
          .map((e) => StockEntryLineModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      notes: map['notes'] as String?,
      status: StockEntryStatus.fromString(map['status'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'supplier_id': supplierId,
        'supplier_name': supplierName,
        'receipt_date': receiptDate.toIso8601String(),
        'lines': lines.map((l) => l.toMap()).toList(),
        'notes': notes,
        'status': status.value,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  StockEntryModel copyWith({
    String? id,
    String? supplierId,
    String? supplierName,
    DateTime? receiptDate,
    List<StockEntryLineModel>? lines,
    String? notes,
    StockEntryStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      StockEntryModel(
        id: id ?? this.id,
        supplierId: supplierId ?? this.supplierId,
        supplierName: supplierName ?? this.supplierName,
        receiptDate: receiptDate ?? this.receiptDate,
        lines: lines ?? this.lines,
        notes: notes ?? this.notes,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}

class ProductRef {
  final String id;
  final String name;
  final String? sku;
  final String? unitId;
  final String? unitName;

  const ProductRef({
    required this.id,
    required this.name,
    this.sku,
    this.unitId,
    this.unitName,
  });
}


