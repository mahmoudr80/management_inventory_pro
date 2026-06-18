import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class StockEntryNotesSection extends StatelessWidget {
  const StockEntryNotesSection({super.key, required this.notesController});
final TextEditingController notesController;
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notes (optional)', style: AppTextStyles.labelCaps),
          SizedBox(height: 6.h),
          TextFormField(
            controller: notesController,
            maxLines: 3,
            style: AppTextStyles.bodyMd,
            decoration: InputDecoration(
              hintText: 'Internal notes about this receipt...',
              hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      );

  }
}
