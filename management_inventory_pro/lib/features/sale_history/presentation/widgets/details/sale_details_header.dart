import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/sale_item_model.dart';
import '../../../data/models/sale_model.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

class SaleDetailsHeader extends StatelessWidget {
  const SaleDetailsHeader({super.key, required this.sale});

  final SaleModel sale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Sale ID row with status badge
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.infoContainer,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.receipt_rounded,
                  size: AppIconSize.xl,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Tooltip(
                  message: sale.id,
                  child: Text(
                    sale.id,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineSm,
                  ),
                ),
              ),
              _StatusBadge(status: sale.status),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.border),
          SizedBox(height: AppSpacing.md),

          // Info grid
          _InfoRow(
            label: 'Date & Time',
            value: DateFormat('MMM d, yyyy hh:mm a').format(sale.createdAt),
          ),
          SizedBox(height: AppSpacing.sm),
          _InfoRow(
            label: 'Cashier',
            value: sale.cashierName,
          ),
          SizedBox(height: AppSpacing.sm),
          _InfoRow(
            label: 'Payment Method',
            value: switch (sale.paymentMethod) {
              PaymentMethod.cash => 'Cash',
              PaymentMethod.card => 'Card',
              PaymentMethod.mixed => 'Mixed',
            },
          ),
          if (sale.notes != null && sale.notes!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            _InfoRow(
              label: 'Notes',
              value: sale.notes!,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final SaleStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      SaleStatus.completed => ('Completed', AppColors.successContainer, AppColors.success),
      SaleStatus.refunded  => ('Refunded',  AppColors.warningContainer, AppColors.warning),
      SaleStatus.cancelled => ('Cancelled', AppColors.errorContainer, AppColors.error),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.labelCaps.copyWith(color: fg),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tooltip(
          message: label,
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Flexible(
          child: Tooltip(
            message: value,
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMd.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
