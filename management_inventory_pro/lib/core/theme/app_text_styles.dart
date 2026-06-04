import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get heading1 => TextStyle(
    fontSize: 32.sp.clamp(24, 40),
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading2 => TextStyle(
    fontSize: 24.sp.clamp(18.0, 30),
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get subtitle => TextStyle(
    fontSize: 16.sp.clamp(12, 20),
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle get body => TextStyle(
    fontSize: 14.sp.clamp(11, 17),
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: (12.sp).clamp(9.0, 15),
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle get buttonText => TextStyle(
    fontSize: 16.sp.clamp(12.0, 20),
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
  );
}
