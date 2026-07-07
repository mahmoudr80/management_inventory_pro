import 'package:flutter/material.dart';
import '../../../data/models/sale_model.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key, required this.sale});

  final SaleModel sale;

  @override
  Widget build(BuildContext context) {
    // All values derived from SaleModel & SaleItemModel — no extra fields needed
    final subtotal = sale.totalAmount;
    final totalQty = sale.totalQuantity;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
            message: 'Payment Summary',
            child: Text(
              'Payment Summary',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          _SummaryRow(
            label: 'Total Items',
            value: sale.totalItems.toString(),
          ),
          _SummaryRow(
            label: 'Total Quantity',
            value: totalQty.toString(),
          ),
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${subtotal.toStringAsFixed(2)}',
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: const Divider(height: 1, color: AppColors.border),
          ),
          _SummaryRow(
            label: 'Total',
            value: '\$${subtotal.toStringAsFixed(2)}',
            labelStyle: AppTextStyles.headlineSm.copyWith(
              fontWeight: FontWeight.w700,
            ),
            valueStyle: AppTextStyles.headlineSm.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Tooltip(
              message: label,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle ??
                    AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Tooltip(
            message: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: valueStyle ??
                  AppTextStyles.bodyMd.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
