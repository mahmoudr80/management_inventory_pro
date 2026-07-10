import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_adjustment_model.dart';
import 'adjustment_status_chip.dart';

class AdjustmentInformation extends StatelessWidget {
  final StockAdjustmentModel adjustment;

  const AdjustmentInformation({super.key, required this.adjustment});

  @override
  Widget build(BuildContext context) {
    // Wrap instead of Row so the meta fields fall onto a second line
    // instead of overflowing on narrower windows.
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: [
        _MetaField(label: 'ADJ NUMBER', value: adjustment.id),
        _MetaField(label: 'CREATED BY', value: adjustment.createdBy),
        _MetaField(
          label: 'DATE/TIME',
          value: DateFormat('MMM d, yyyy · HH:mm')
              .format(adjustment.createdAt ?? DateTime.now()),
        ),
        AdjustmentStatusChip(status: adjustment.status),
      ],
    );
  }
}

class _MetaField extends StatelessWidget {
  final String label;
  final String value;

  const _MetaField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.labelCaps),
          const SizedBox(height: AppSpacing.xxs),
          Tooltip(
            message: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextStyles.bodyMd.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}