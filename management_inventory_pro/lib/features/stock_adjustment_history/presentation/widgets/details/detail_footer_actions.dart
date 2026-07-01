import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_status.dart';

/// Footer action row in the right detail panel: Print + Export PDF are
/// always shown; "Continue Editing" only appears for Draft adjustments —
/// this is an explicit business rule, not a styling choice.
class DetailFooterActions extends StatelessWidget {
  const DetailFooterActions({
    super.key,
    required this.status,
    required this.onPrint,
    required this.onExportPdf,
    required this.onContinueEditing,
  });

  final AdjustmentStatus status;
  final VoidCallback onPrint;
  final VoidCallback onExportPdf;
  final VoidCallback onContinueEditing;

  @override
  Widget build(BuildContext context) {
    final isDraft = status == AdjustmentStatus.draft;

    return Container(
      padding: EdgeInsets.symmetric(vertical:  20.h,horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _OutlinedFooterButton(
                  icon: Icons.print_outlined,
                  label: 'Print',
                  onPressed: onPrint,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _OutlinedFooterButton(
                  icon: Icons.picture_as_pdf_outlined,
                  label: 'Export PDF',
                  onPressed: onExportPdf,
                ),
              ),
            ],
          ),
          if (isDraft) ...[
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinueEditing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimaryContainer,
                  elevation: 0,
                  side: BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
                child: Text(
                  'Continue Editing',
                  style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OutlinedFooterButton extends StatelessWidget {
  const _OutlinedFooterButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28.r),
      label: Text(label, style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w700)),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onSurface,
        side: BorderSide(color: AppColors.outline),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}
