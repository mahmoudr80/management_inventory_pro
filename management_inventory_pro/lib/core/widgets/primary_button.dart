import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Filled action button (solid/icon variants).
///
/// Refactor notes (responsive_rules.md):
/// - Removed `flutter_screenutil`; height/padding/icon size now come from
///   `AppSize` / `AppSpacing` / `AppIconSize` so the button doesn't stretch
///   or shrink oddly across the supported desktop resolutions.
/// - Label is wrapped in `Flexible` + ellipsis so long button text (e.g.
///   localized strings) never overflows the button bounds.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
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
        height: AppSize.buttonHeight,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? SizedBox(
                  height: AppIconSize.lg,
                  width: AppIconSize.lg,
                  child: const CircularProgressIndicator(
                    color: AppColors.surface,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.buttonText,
                ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              height: AppIconSize.sm,
              width: AppIconSize.sm,
              child: const CircularProgressIndicator(
                color: AppColors.onPrimary,
                strokeWidth: 2,
              ),
            )
          : Icon(icon, size: AppIconSize.sm),
      label: Flexible(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySm.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onPrimary,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.onPrimary,
        backgroundColor: AppColors.primary,
        elevation: 1,
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
