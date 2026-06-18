import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EntrySummaryFooter extends StatelessWidget {
  final int totalItems;
  final double subtotal;
  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const EntrySummaryFooter({
    super.key,
    required this.totalItems,
    required this.subtotal,
    required this.isLoading,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: const Border(
          top: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          // ── Items count ────────────────────────────────────────────────
          _SummaryChip(
            label: 'ITEMS',
            value: totalItems.toString(),
          ),

          SizedBox(width: 16.w),

          // ── Subtotal ───────────────────────────────────────────────────
          _SummaryChip(
            label: 'SUBTOTAL',
            value: '\$${subtotal.toStringAsFixed(2)}',
            valueMono: true,
          ),

          const Spacer(),

          // ── Cancel ────────────────────────────────────────────────────
          OutlinedButton(
            onPressed: isLoading ? null : onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
              side: const BorderSide(color: AppColors.outlineVariant),
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('Cancel', style: AppTextStyles.bodyMd),
          ),

          SizedBox(width: 12.w),

          // ── Save ──────────────────────────────────────────────────────
          ElevatedButton.icon(
            onPressed: isLoading ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              disabledBackgroundColor:
                  AppColors.primary.withOpacity(0.5),
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            icon: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onPrimary,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(
              isLoading ? 'Saving…' : 'Save & Update Stock',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary Chip ──────────────────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final bool valueMono;

  const _SummaryChip({
    required this.label,
    required this.value,
    this.valueMono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.labelCaps),
          SizedBox(height: 2.h),
          Text(
            value,
            style: valueMono
                ? AppTextStyles.dataMono.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onBackground,
                  )
                : AppTextStyles.headlineSm,
          ),
        ],
      ),
    );
  }
}
