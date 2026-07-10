import 'package:flutter/material.dart';

import '../theme/app_theme_extension.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

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
            foregroundColor: context.colors.primary,
            side: BorderSide(color: context.colors.primary, width: AppBorder.medium),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          child: isLoading
              ? SizedBox(
            height: AppIconSize.lg,
            width: AppIconSize.lg,
            child: CircularProgressIndicator(
              color: context.colors.primary,
              strokeWidth: 2.5,
            ),
          )
              : Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.buttonText.copyWith(color: context.colors.primary),
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
        child: CircularProgressIndicator(
          color: context.colors.onSurfaceVariant,
          strokeWidth: 2,
        ),
      )
          : Icon(icon, size: AppIconSize.sm),
      label: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: context.colors.onSurfaceVariant,
        backgroundColor: context.colors.surfaceContainerLowest,
        side: BorderSide(color: context.colors.outline),
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