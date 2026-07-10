import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';

class HistoryTableHeader extends StatelessWidget {
  const HistoryTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Widget label(String text, {int flex = 3, TextAlign align = TextAlign.left}) {
      return Expanded(
        flex: flex,
        child: Tooltip(
          message: text.toUpperCase(),
          child: Text(
            overflow: TextOverflow.ellipsis,
            text.toUpperCase(),
            textAlign: align,
            style: AppTextStyles.labelCaps,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceBright,
        border: Border(bottom: BorderSide(color: context.colors.outlineVariant)),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.md),
      child: Row(
        children: [
          label('Adjustment ID', flex: 3),
          label('Date & Time', flex: 3),
          label('Reason', flex: 3),
          label('Products', flex: 2),
          label('Qty Change', flex: 2),
          label('Value', flex: 3,align: TextAlign.center),
          label('Created By', flex: 3),
          label('Status', flex: 2),
        ],
      ),
    );
  }
}