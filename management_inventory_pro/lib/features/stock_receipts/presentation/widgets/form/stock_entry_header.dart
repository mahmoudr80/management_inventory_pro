import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class StockEntryHeader extends StatelessWidget {
  const StockEntryHeader({super.key,required this.isEditMode,required this.receiptId});
final bool isEditMode;
final String receiptId;
  @override
  Widget build(BuildContext context) {
    return   Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditMode ? 'Edit Stock Receipt' : 'New Stock Receipt',
                style: AppTextStyles.display,
              ),
            ],
          ),
          const Spacer(),
          // Receipt ID badge
          if (receiptId.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Row(
                children: [
                  Text(
                    'RECEIPT ID: ',
                    style: AppTextStyles.labelCaps,
                  ),
                  Text(
                    receiptId,
                    style: AppTextStyles.dataMono
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
        ],
      );

  }
}
