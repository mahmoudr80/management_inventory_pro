import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Outlined action button (solid/icon variants).
///
/// Refactor notes (responsive_rules.md):
/// - Removed `flutter_screenutil`; sizing now derives from `AppSize` /
///   `AppSpacing` / `AppIconSize` for consistency with `PrimaryButton`.
/// - Label wrapped in `Flexible` + ellipsis so it truncates gracefully
///   instead of overflowing when the button sits in a constrained toolbar.
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return SizedBox(
        width: double.infinity,
        height: AppSize.buttonHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: AppBorder.medium),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: AppIconSize.lg,
                  width: AppIconSize.lg,
                  child: const CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.buttonText.copyWith(color: AppColors.primary),
                ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              height: AppIconSize.sm,
              width: AppIconSize.sm,
              child: const CircularProgressIndicator(
                color: AppColors.onSurfaceVariant,
                strokeWidth: 2,
              ),
            )
          : Icon(icon, size: AppIconSize.sm),
      label: Flexible(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onSurfaceVariant,
        backgroundColor: AppColors.surfaceContainerLowest,
        side: const BorderSide(color: AppColors.outline),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xxs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}
