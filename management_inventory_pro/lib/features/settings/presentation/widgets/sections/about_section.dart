import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

import '../../../data/models/settings_model.dart';
import '../cards/settings_card.dart';

/// "About" card — read-only app/license/support info, plus a link to the
/// privacy policy. Nothing here is editable, so it skips the Cubit
/// entirely and just renders [about] as-is.
class AboutSection extends StatelessWidget {
  final AboutInfo about;
  final VoidCallback? onOpenPrivacyPolicy;

  const AboutSection({super.key, required this.about, this.onOpenPrivacyPolicy});

  String get _licenseLabel {
    switch (about.licenseStatus) {
      case LicenseStatus.active:
        return 'Active';
      case LicenseStatus.trial:
        return 'Trial';
      case LicenseStatus.expired:
        return 'Expired';
    }
  }

  Color _licenseColor(BuildContext context) {
    switch (about.licenseStatus) {
      case LicenseStatus.active:
        return context.colors.success;
      case LicenseStatus.trial:
        return context.colors.warning;
      case LicenseStatus.expired:
        return context.colors.error;
    }
  }

  String get _planLabel {
    switch (about.subscriptionPlan) {
      case SubscriptionPlan.free:
        return 'Free';
      case SubscriptionPlan.starter:
        return 'Starter';
      case SubscriptionPlan.business:
        return 'Business';
      case SubscriptionPlan.enterprise:
        return 'Enterprise';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'About',
      description: 'Version ${about.version}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.xxl,
            runSpacing: AppSpacing.md,
            children: [
              _infoItem('Application', about.appName),
              _infoItem('Version', about.version),
              _infoItem('Database Version', about.databaseVersion),
              _infoItem('Subscription', '$_planLabel Plan'),
              _statusItem('License Status', _licenseLabel, _licenseColor(context)),
              _infoItem('Support', about.supportEmail),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Divider(height: 1, color: context.colors.outlineVariant),
          SizedBox(height: AppSpacing.md),
          InkWell(
            onTap: onOpenPrivacyPolicy,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.privacy_tip_outlined, size: AppIconSize.sm, color: context.colors.primary),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'Privacy Policy',
                  style: AppTextStyles.bodySm.copyWith(color: context.colors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.labelCaps),
          SizedBox(height: AppSpacing.xxs),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyMd),
        ],
      ),
    );
  }

  Widget _statusItem(String label, String value, Color color) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.labelCaps),
          SizedBox(height: AppSpacing.xxs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              value,
              style: AppTextStyles.bodySm.copyWith(color: color, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
