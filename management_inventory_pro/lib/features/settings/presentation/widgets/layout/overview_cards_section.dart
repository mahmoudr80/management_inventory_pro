import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';

import '../../../models/settings_model.dart';
import '../cards/information_card.dart';

/// Four-up row of at-a-glance KPI cards, wrapping on narrower desktop
/// widths per the spec ("Cards should automatically wrap on smaller
/// desktop widths").
class OverviewCardsSection extends StatelessWidget {
  final SettingsModel settings;

  const OverviewCardsSection({super.key, required this.settings});

  String get _subscriptionLabel {
    switch (settings.about.subscriptionPlan) {
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

  String get _lastBackupLabel {
    final diff = DateTime.now().difference(settings.backup.lastBackup);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.lg,
      children: [
        InformationCard(
          icon: Icons.storefront_rounded,
          label: 'STORE',
          value: settings.general.storeName,
          caption: settings.general.businessType,
        ),
        InformationCard(
          icon: Icons.workspace_premium_rounded,
          label: 'SUBSCRIPTION',
          value: '$_subscriptionLabel Plan',
          caption: settings.about.version,
        ),
        InformationCard(
          icon: Icons.storage_rounded,
          label: 'DATABASE SIZE',
          value: '${settings.backup.databaseSizeMb.toStringAsFixed(1)} MB',
          caption: '${settings.backup.storageUsagePercent.toStringAsFixed(0)}% of quota used',
        ),
        InformationCard(
          icon: Icons.cloud_done_rounded,
          label: 'LAST BACKUP',
          value: _lastBackupLabel,
          caption: settings.backup.automaticBackup ? 'Automatic backup on' : 'Automatic backup off',
        ),
      ],
    );
  }
}
