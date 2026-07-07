import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class TabletAuthLayout extends StatelessWidget {
  final Widget child;
  const TabletAuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xxxl.w,
                vertical: AppSpacing.xxxl.h,
              ),
              child: ConstrainedBox(
                // Intentional content cap for the auth form on tablet
                // widths — mirrors the mobile/desktop breakpoints, not a
                // spacing value.
                constraints: BoxConstraints(maxWidth: AppSize.authMaxWidthTablet),
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.xxxl.r),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.xxl.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 30.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
