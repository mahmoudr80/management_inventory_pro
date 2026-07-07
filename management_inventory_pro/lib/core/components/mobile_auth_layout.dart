import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_dimens.dart';

class MobileAuthLayout extends StatelessWidget {
  final Widget child;

  const MobileAuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl.w,
          vertical: AppSpacing.xxl.h,
        ),
        child: ConstrainedBox(
          // Intentional content cap for the auth form on narrow/mobile
          // widths — mirrors the tablet/desktop breakpoints, not a
          // spacing value.
          constraints: const BoxConstraints(maxWidth: AppSize.authMaxWidthMobile),
          child: child,
        ),
      ),
    );
  }
}
