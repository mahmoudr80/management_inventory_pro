import '../../../../core/database/database_constants.dart';
import 'adjustment_reason.dart';
import 'stock_adjustment_item_model.dart';

enum AdjustmentStatus { draft, completed, cancelled }

extension AdjustmentStatusX on AdjustmentStatus {
  String get label => switch (this) {
        AdjustmentStatus.draft => 'Draft',
        AdjustmentStatus.completed => 'Completed',
        AdjustmentStatus.cancelled => 'Cancelled',
      };
}

class StockAdjustmentModel {
  final String id;
  final String createdBy;
  final DateTime ?createdAt;
  final AdjustmentStatus status;
  final AdjustmentReason? reason;
  final List<StockAdjustmentItemModel> items;

  const StockAdjustmentModel({
    required this.id,
     this.createdBy='Admin',
     this.createdAt,
    required this.status,
    this.reason,
    this.items = const [],
  });

  int get totalIncrease =>
      items.fold(0, (s, i) => i.adjustmentQty > 0 ? s + i.adjustmentQty : s);

  int get totalDecrease =>
      items.fold(0, (s, i) => i.adjustmentQty < 0 ? s + i.adjustmentQty : s);

  int get netQtyChange => totalIncrease + totalDecrease;

  double get valuationImpact => items.fold(0.0, (s, i) => s + i.valueImpact);

  double get currentInventoryValue =>
      items.fold(0.0, (s, i) => s + i.currentStock * i.costPrice);

  double get projectedInventoryValue =>
      items.fold(0.0, (s, i) => s + i.newStock * i.costPrice);

  StockAdjustmentModel copyWith({
    AdjustmentStatus? status,
    AdjustmentReason? reason,
    bool clearReason = false,
    List<StockAdjustmentItemModel>? items,
  }) =>
      StockAdjustmentModel(
        id: id,
        createdBy: createdBy,
        createdAt: createdAt,
        status: status ?? this.status,
        reason: clearReason ? null : reason ?? this.reason,
        items: items ?? this.items,
      );

  factory StockAdjustmentModel.fromMap(Map<String, Object?> map) {
    return StockAdjustmentModel(
      id: map[DatabaseConstants.idColumn] as String,
      createdBy:
      (map[DatabaseConstants.createdByColumn] ?? 'Admin') as String,
      createdAt: DateTime.parse(
        map[DatabaseConstants.createdAtColumn] as String,
      ),
      status: AdjustmentStatus.values.firstWhere(
            (e) =>
        e.name ==
            ((map[DatabaseConstants.statusColumn] ?? 'draft') as String),
      ),
      reason: map[DatabaseConstants.reasonColumn] != null
          ? AdjustmentReason.values.firstWhere(
            (e) =>
        e.name ==
            (map[DatabaseConstants.reasonColumn] as String),
      )
          : null,
      items: const [],
    );
  }

  Map<String, Object?> toMap() {
    return {
      DatabaseConstants.idColumn: id,
      DatabaseConstants.createdByColumn: createdBy,
      DatabaseConstants.reasonColumn: reason?.name,
      DatabaseConstants.statusColumn: status.name,
      DatabaseConstants.totalItemColumn: items.length,
      DatabaseConstants.totalQuantityColumn: items.fold<int>(
        0,
            (sum, item) => sum + item.adjustmentQty.abs(),
      ),
      DatabaseConstants.totalInventoryValueChangeColumn: valuationImpact,
      DatabaseConstants.createdAtColumn: (createdAt??DateTime.now())
          .toIso8601String()
          .split('.')
          .first
          .replaceFirst('T', ' '),
    };
  }
}
