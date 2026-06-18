import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_decoration.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_line_model.dart';
import '../entry_line_row.dart';

class StockEntryLineTable extends StatelessWidget {
  const StockEntryLineTable({super.key, required this.lines, required this.onLineChanged, required this.onRemoveLine, required this.onAddLine});
  final List<StockEntryLineModel> lines;
  final Function(int, StockEntryLineModel) onLineChanged;
  final Function(int) onRemoveLine;
  final VoidCallback onAddLine;
  @override
  Widget build(BuildContext context) {
    return   Container(
        decoration: AppDecorations.card(),
        child: Column(
          children: [
            // Table header row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  SizedBox(width: 32.w, child: Text('#', style: AppTextStyles.labelCaps)),
                  Expanded(flex: 4, child: Text('PRODUCT NAME / SKU', style: AppTextStyles.labelCaps)),
                  Expanded(flex: 2, child: Center(child: Text('QTY', style: AppTextStyles.labelCaps))),
                  Expanded(flex: 2, child: Center(child: Text('COST PRICE', style: AppTextStyles.labelCaps))),
                  Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text('TOTAL', style: AppTextStyles.labelCaps))),
                  SizedBox(width: 40.w),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.outlineVariant),
            // Lines
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lines.length,
              separatorBuilder: (_, _) =>
              const Divider(height: 1, color: AppColors.outlineVariant),
              itemBuilder: (_, index) => EntryLineRow(
                index: index,
                line: lines[index],
                onChanged: (updated) => onLineChanged(index, updated),
                onRemove: () => onRemoveLine(index),
              ),
            ),
            // Add row button
            const Divider(height: 1, color: AppColors.outlineVariant),
            InkWell(
              onTap: onAddLine,
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    Icon(Icons.add, color: AppColors.primary, size: 18),
                    SizedBox(width: 8.w),
                    Text(
                      'Start typing to add a product...',
                      style: AppTextStyles.bodyMd
                          .copyWith(color: AppColors.outline),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  }
}
