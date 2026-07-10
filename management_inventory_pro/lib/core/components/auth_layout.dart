import 'package:flutter/material.dart';
import '../theme/app_theme_extension.dart';
import '../utils/responsive.dart';
import 'mobile_auth_layout.dart';
import 'tablet_auth_layout.dart';
import 'desktop_auth_layout.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Responsive(
          mobile: MobileAuthLayout(child: child),
          tablet: TabletAuthLayout(child: child),
          desktop: DesktopAuthLayout(child: child),
        ),
      ),
    );
  }
}