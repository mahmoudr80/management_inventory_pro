import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Resulting stock health of a product after an adjustment is applied.
enum ProductStockStatus {
  healthy,
  low,
  outOfStock;

  String get label {
    switch (this) {
      case ProductStockStatus.healthy:
        return 'HEALTHY';
      case ProductStockStatus.low:
        return 'LOW';
      case ProductStockStatus.outOfStock:
        return 'OUT OF STOCK';
    }
  }

  Color get color {
    switch (this) {
      case ProductStockStatus.healthy:
        return AppColors.success;
      case ProductStockStatus.low:
        return AppColors.warning;
      case ProductStockStatus.outOfStock:
        return AppColors.error;
    }
  }

  /// Derive the status from a resulting stock quantity using simple
  /// operational thresholds (mock data only).
  static ProductStockStatus fromQuantity(int newStock) {
    if (newStock <= 0) return ProductStockStatus.outOfStock;
    if (newStock <= 15) return ProductStockStatus.low;
    return ProductStockStatus.healthy;
  }
}
