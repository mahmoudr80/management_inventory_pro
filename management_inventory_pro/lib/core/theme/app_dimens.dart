import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Spacing tokens. Base unit is 4px per the design system's baseline grid.
class AppSpacing {
  AppSpacing._();

  static double get unit => 2.w;
  static double get gutter => 4.w;
  static double get marginDesktop => 6.w;
  static double get tableRowHeight => 40.h;
}

/// Corner-radius tokens.
class AppRadius {
  AppRadius._();

  static double get sm => 2.r;
  static double get standard => 4.r;
  static double get md => 6.r;
  static double get lg => 8.r;
  static double get xl => 12.r;
  static double get full => 9999.r;
}
