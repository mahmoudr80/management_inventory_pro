import 'package:equatable/equatable.dart';

import 'product_adjustment_model.dart';

/// Aggregated summary for the right-panel "Adjustment Summary" card.
class AdjustmentSummaryModel extends Equatable {
  const AdjustmentSummaryModel({
    required this.skuCount,
    required this.totalIncrease,
    required this.totalDecrease,
    required this.inventoryValueDelta,
  });

  final int skuCount;
  final int totalIncrease;
  final int totalDecrease;
  final double inventoryValueDelta;

  int get totalUnitsMoved => totalIncrease + totalDecrease;

  /// Builds a summary from product lines and the adjustment's overall
  /// value impact (mock valuation, not a real costing engine).
  factory AdjustmentSummaryModel.fromProducts(
    List<ProductAdjustmentModel> products,
    double inventoryValueDelta,
  ) {
    var increase = 0;
    var decrease = 0;
    for (final product in products) {
      if (product.adjustmentQty > 0) {
        increase += product.adjustmentQty;
      } else {
        decrease += product.adjustmentQty.abs();
      }
    }
    return AdjustmentSummaryModel(
      skuCount: products.length,
      totalIncrease: increase,
      totalDecrease: decrease,
      inventoryValueDelta: inventoryValueDelta,
    );
  }

  @override
  List<Object?> get props => [
        skuCount,
        totalIncrease,
        totalDecrease,
        inventoryValueDelta,
      ];
}
