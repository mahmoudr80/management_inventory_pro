import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Brand logo used on auth screens and empty states.
///
/// Refactor notes (responsive_rules.md):
/// - Dropped `flutter_screenutil` (unused on this widget) in favor of the
///   `core/theme` constants so sizing stays consistent across the desktop
///   breakpoints instead of scaling arbitrarily.
/// - The brand label is capped with `ConstrainedBox` + ellipsis so a
///   long/localized product name never overflows in a narrow sidebar.
class AppLogo extends StatelessWidget {
  final double? size;
  final bool showText;

  const AppLogo({super.key, this.size, this.showText = true});

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? AppIconSize.xl * 3.75; // 120 -> derived from scale

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(logoSize / 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.inventory_2_rounded,
            color: AppColors.surface,
            size: logoSize * 0.6,
          ),
        ),
        if (showText) ...[
          SizedBox(height: AppSpacing.lg),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: logoSize * 2.5),
            child: Text(
              'OmniStock',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.primaryDark,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
