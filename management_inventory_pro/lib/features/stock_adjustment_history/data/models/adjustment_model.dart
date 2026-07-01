import 'package:equatable/equatable.dart';

import 'adjustment_reason.dart';
import 'adjustment_status.dart';
import 'adjustment_summary_model.dart';
import 'product_adjustment_model.dart';

/// A single stock adjustment audit record.
class AdjustmentModel extends Equatable {
  const AdjustmentModel({
    required this.id,
    required this.dateTime,
    required this.reason,
    required this.status,
    required this.createdBy,
    required this.valueImpact,
    required this.products,
  });

  final String id;
  final DateTime dateTime;
  final AdjustmentReason reason;
  final AdjustmentStatus status;
  final String createdBy;

  /// Total EGP valuation delta caused by this adjustment.
  final double valueImpact;
  final List<ProductAdjustmentModel> products;

  int get productCount => products.length;

  /// Net signed quantity change across all product lines.
  int get qtyChange =>
      products.fold<int>(0, (sum, product) => sum + product.adjustmentQty);

  AdjustmentSummaryModel get summary =>
      AdjustmentSummaryModel.fromProducts(products, valueImpact);

  @override
  List<Object?> get props => [
        id,
        dateTime,
        reason,
        status,
        createdBy,
        valueImpact,
        products,
      ];
}
