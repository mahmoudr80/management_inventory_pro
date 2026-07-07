import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_adjustment_model.dart';

class InventoryValueSummary extends StatelessWidget {
  final StockAdjustmentModel adjustment;

  const InventoryValueSummary({super.key, required this.adjustment});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final impact = adjustment.valuationImpact;
    final impactColor = impact >= 0 ? AppColors.primary : AppColors.error;
    final impactPrefix = impact >= 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVENTORY VALUATION IMPACT',
            style:
                AppTextStyles.labelCaps.copyWith(color: AppColors.primaryDark),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.xs,
            children: [
              Text(
                '$impactPrefix${fmt.format(impact)}',
                style: AppTextStyles.dataMono.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: impactColor,
                ),
              ),
              Text(
                'EGP',
                style: AppTextStyles.bodySm.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
