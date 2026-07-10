import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_adjustment_item_model.dart';
import 'movement_preview_item.dart';

class MovementPreview extends StatelessWidget {
  final List<StockAdjustmentItemModel> items;

  const MovementPreview({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final filtered = items.where((i) => i.adjustmentQty != 0).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            children: [
              Text('MOVEMENT PREVIEW', style: AppTextStyles.labelCaps),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Divider(color: context.colors.outlineVariant),
              ),
            ],
          ),
        ),
        if (filtered.isEmpty)
          Text(
            'No adjustments yet',
            style: AppTextStyles.bodySm.copyWith(
              color: context.colors.outline,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          ...filtered.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: MovementPreviewItem(item: item),
            ),
          ),
      ],
    );
  }
}