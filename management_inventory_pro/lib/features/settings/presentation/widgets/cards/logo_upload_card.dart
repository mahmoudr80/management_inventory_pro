import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import '../../theme/settings_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

/// Drop-zone used to upload/replace the store logo in the Store
/// Information section. Purely presentational — [onTap] is left to the
/// caller to wire to a file picker once persistence exists.
///
/// Uses a solid outline rather than a true dashed border: Flutter has no
/// built-in dashed `BoxBorder`, and a hand-rolled `CustomPainter` for a
/// single static drop-zone isn't worth the extra file/complexity here.
class LogoUploadCard extends StatelessWidget {
  final String? logoPath;
  final VoidCallback? onTap;
  final String acceptedFormats;

  const LogoUploadCard({
    super.key,
    this.logoPath,
    this.onTap,
    this.acceptedFormats = 'SVG, PNG, JPG (Max 2MB)',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: 260,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: context.colors.outlineVariant,
            width: AppBorder.medium,
            style: BorderStyle.solid,
          ),
          color: context.settingsColors.surfaceContainerLow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                logoPath == null ? Icons.upload_file_rounded : Icons.image_rounded,
                color: context.colors.primary,
                size: AppIconSize.lg,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              logoPath == null ? 'Upload Store Logo' : 'Replace Store Logo',
              style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: AppSpacing.xxs),
            Text(
              acceptedFormats,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySm,
            ),
          ],
        ),
      ),
    );
  }
}
