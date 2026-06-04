import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MobileAuthLayout extends StatelessWidget {
  final Widget child;

  const MobileAuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    print('phone');
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: child,
        ),
      ),
    );
  }
}
