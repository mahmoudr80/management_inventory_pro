import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Display style (display-lg/md)
  static TextStyle get display => TextStyle(
    fontFamily: 'Inter',
    fontSize: 32.sp.clamp(24.0, 40.0),
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    letterSpacing: -0.02 * 32,
    color: AppColors.textPrimary,
  );

  // Headline Medium
  static TextStyle get headlineMd => TextStyle(
    fontFamily: 'Inter',
    fontSize: 20.sp.clamp(16.0, 24.0),
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: -0.01 * 20,
    color: AppColors.textPrimary,
  );

  // Headline Small
  static TextStyle get headlineSm => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.sp.clamp(14.0, 20.0),
    fontWeight: FontWeight.w600,
    height: 24 / 16,
    color: AppColors.textPrimary,
  );

  // Body Large
  static TextStyle get bodyLg => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.sp.clamp(14.0, 20.0),
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textPrimary,
  );

  // Body Medium
  static TextStyle get bodyMd => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.sp.clamp(12.0, 16.0),
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textPrimary,
  );

  // Body Small
  static TextStyle get bodySm => TextStyle(
    fontFamily: 'Inter',
    fontSize: 13.sp.clamp(11.0, 15.0),
    fontWeight: FontWeight.w400,
    height: 18 / 13,
    color: AppColors.textSecondary,
  );

  // Label Caps
  static TextStyle get labelCaps => TextStyle(
    fontFamily: 'Inter',
    fontSize: 11.sp.clamp(9.0, 13.0),
    fontWeight: FontWeight.w600,
    height: 16 / 11,
    letterSpacing: 0.05 * 11,
    color: AppColors.textSecondary,
  );

  // Data Mono (JetBrains Mono for numbers/SKUs)
  static TextStyle get dataMono => TextStyle(
    fontFamily: 'JetBrainsMono', // Standard fallback or configured font
    fontSize: 13.sp.clamp(11.0, 15.0),
    fontWeight: FontWeight.w400,
    height: 20 / 13,
    color: AppColors.textPrimary,
  );

  // Compatibility get properties for existing widgets
  static TextStyle get heading1 => display;
  static TextStyle get heading2 => headlineMd;
  static TextStyle get subtitle => headlineSm;
  static TextStyle get body => bodyMd;
  static TextStyle get bodySmall => bodySm;
  static TextStyle get buttonText => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.sp.clamp(12.0, 16.0),
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );
}
