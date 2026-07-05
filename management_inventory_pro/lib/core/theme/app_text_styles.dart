import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display
  static TextStyle get display => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.64,
    color: AppColors.textPrimary,
  );

  // Headline Medium
  static TextStyle get headlineMd => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  // Headline Small
  static TextStyle get headlineSm => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // Body Large
  static TextStyle get bodyLg => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // Body Medium
  static TextStyle get bodyMd => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  // Body Small
  static TextStyle get bodySm => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.38,
    color: AppColors.textSecondary,
  );

  // Label
  static TextStyle get labelCaps => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.45,
    letterSpacing: 0.55,
    color: AppColors.textSecondary,
  );

  // Monospace
  static TextStyle get dataMono => const TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.54,
    color: AppColors.textPrimary,
  );

  // Button
  static TextStyle get buttonText => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );

  // Compatibility aliases
  static TextStyle get heading1 => display;
  static TextStyle get heading2 => headlineMd;
  static TextStyle get subtitle => headlineSm;
  static TextStyle get body => bodyMd;
  static TextStyle get bodySmall => bodySm;
}