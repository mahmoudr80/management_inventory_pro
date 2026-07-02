import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData ?icon;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false, this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return icon==null?SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.primary,
                ),
              ),
      ),
    ):
    OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 5.sp),
      label: Text(text, style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onSurfaceVariant,
        backgroundColor: AppColors.surfaceContainerLowest,
        side: BorderSide(color: AppColors.outline),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}
