import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_adjustment_item_model.dart';
import '../common/warning_badge.dart';

class MovementPreviewItem extends StatelessWidget {
  final StockAdjustmentItemModel item;

  const MovementPreviewItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isPositive = item.adjustmentQty > 0;
    final adjColor = isPositive ? context.colors.primary : context.colors.error;
    final adjPrefix = isPositive ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.standard),
        border: Border.all(color: context.colors.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
            message: item.productName,
            child: Text(
              item.productName,
              style: AppTextStyles.bodySm.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StockLabel(
                label: 'FROM',
                value: '${item.currentStock}',
                color: context.colors.textPrimary,
              ),
              Icon(Icons.arrow_forward,
                  size: AppIconSize.lg, color: context.colors.outline),
              _StockLabel(
                label: 'TO',
                value: '${item.newStock}',
                color: item.isNegativeInventory || item.isOutOfStock
                    ? context.colors.error
                    : isPositive
                    ? context.colors.primary
                    : context.colors.textPrimary,
              ),
              Container(
                width: AppBorder.thin,
                height: 24,
                color: context.colors.outlineVariant,
              ),
              Text(
                '$adjPrefix${item.adjustmentQty}',
                style: AppTextStyles.dataMono.copyWith(
                  fontWeight: FontWeight.w700,
                  color: adjColor,
                ),
              ),
            ],
          ),
          if (item.isNegativeInventory || item.isLowStock || item.isOutOfStock) ...[
            const SizedBox(height: AppSpacing.xs),
            WarningBadge(
              level: item.isNegativeInventory
                  ? WarningLevel.negative
                  : item.isOutOfStock
                  ? WarningLevel.out
                  : WarningLevel.low,
            ),
          ],
        ],
      ),
    );
  }
}

class _StockLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StockLabel(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: AppTextStyles.bodySm.copyWith(color: context.colors.outline)),
        Text(
          value,
          style: AppTextStyles.dataMono.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}