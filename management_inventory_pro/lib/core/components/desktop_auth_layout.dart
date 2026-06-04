import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../widgets/app_logo.dart';

class DesktopAuthLayout extends StatelessWidget {
  final Widget child;

  const DesktopAuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
