import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData ?icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false, this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return  icon==null?  SizedBox(
     // width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: CircularProgressIndicator(
                  color: AppColors.surface,
                  strokeWidth: 2.5,
                ),
              )
            : Text(text, style: AppTextStyles.buttonText),
      )
    ):ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 5.sp),
      label: Text(text, style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600,color: Colors.white)),
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.onPrimary,
        backgroundColor: AppColors.primary,
        elevation: 1,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}
