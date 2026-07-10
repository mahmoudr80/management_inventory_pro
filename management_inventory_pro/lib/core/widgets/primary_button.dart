import 'package:flutter/material.dart';

import '../theme/app_theme_extension.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

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
            backgroundColor: context.colors.primary,
            foregroundColor: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? SizedBox(
            height: AppIconSize.lg,
            width: AppIconSize.lg,
            child: CircularProgressIndicator(
              color: context.colors.surface,
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
        child: CircularProgressIndicator(
          color: context.colors.onPrimary,
          strokeWidth: 2,
        ),
      )
          : Icon(icon, size: AppIconSize.sm),
      label: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodySm.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colors.onPrimary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: context.colors.onPrimary,
        backgroundColor: context.colors.primary,
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