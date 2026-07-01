import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Static column header row for the adjustment history table.
class HistoryTableHeader extends StatelessWidget {
  const HistoryTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Widget label(String text, {int flex = 3, TextAlign align = TextAlign.left}) {
      return Expanded(
        flex: flex,
        child: Text(
          overflow: TextOverflow.ellipsis,
          text.toUpperCase(),
          textAlign: align,
          style: AppTextStyles.labelCaps,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
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
