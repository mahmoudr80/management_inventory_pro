import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/supplier_ref.dart';
import '../supplier_dropdown.dart';

class StockEntryInfoSection extends StatelessWidget {
  const StockEntryInfoSection({super.key, required this.receiptDate,  this.selectedSupplier,required this.onChanged, this.onTap});
final DateTime receiptDate;
final SupplierRef? selectedSupplier;
final void Function(SupplierRef?) onChanged;
final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return   Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SUPPLIER', style: AppTextStyles.labelCaps),
                SizedBox(height: 6.h),
                SupplierDropdown(
                  selected: selectedSupplier,
                  onChanged:onChanged,
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RECEIPT DATE', style: AppTextStyles.labelCaps),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap:onTap,
                  child: Container(
                    height: 46.h,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${receiptDate.year}-'
                                '${receiptDate.month.toString().padLeft(2, '0')}-'
                                '${receiptDate.day.toString().padLeft(2, '0')}',
                            style: AppTextStyles.bodyMd,
                          ),
                        ),
                        Icon(Icons.calendar_today_outlined,
                            size: 18, color: AppColors.outline),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  }

}

