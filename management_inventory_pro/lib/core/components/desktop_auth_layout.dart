import 'package:flutter/material.dart';
import '../theme/app_dimens.dart';

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
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding * 2,
                vertical: AppSpacing.xxl,
              ),
              child: ConstrainedBox(
                // Intentional content cap for the auth form on wide/ultra-wide
                // desktop monitors (up to 2560px) — not a spacing value.
                constraints: const BoxConstraints(maxWidth: AppSize.authMaxWidthDesktop),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
