import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../data/models/stock_adjustment_model.dart';
import 'adjustment_information.dart';

class AdjustmentHeader extends StatelessWidget {
  final StockAdjustmentModel adjustment;

  const AdjustmentHeader({super.key, required this.adjustment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        top: AppSpacing.md,
        right: AppSpacing.lg,
      ),
      child: PageHeader(
        title: 'Stock Adjustment',
        actions: [AdjustmentInformation(adjustment: adjustment)],
      ),
    );
  }
}
