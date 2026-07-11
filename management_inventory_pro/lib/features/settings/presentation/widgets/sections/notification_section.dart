import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import '../../../data/models/settings_model.dart';
import '../cards/settings_card.dart';
import '../fields/settings_switch_tile.dart';

/// "Notifications" card — a flat list of toggles for alerts & messaging.
class NotificationSection extends StatelessWidget {
  final NotificationSettings notifications;
  final ValueChanged<NotificationSettings> onChanged;

  const NotificationSection({super.key, required this.notifications, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Notifications',
      description: 'Alerts & messaging',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSwitchTile(
            title: 'Desktop Notifications',
            description: 'Show system notifications while the app is running',
            value: notifications.desktopNotifications,
            onChanged: (v) => onChanged(notifications.copyWith(desktopNotifications: v)),
          ),
          SizedBox(height: AppSpacing.lg),
          SettingsSwitchTile(
            title: 'Low Stock Alerts',
            description: 'Notify when a product crosses its threshold',
            value: notifications.lowStockAlerts,
            onChanged: (v) => onChanged(notifications.copyWith(lowStockAlerts: v)),
          ),
          SizedBox(height: AppSpacing.lg),
          SettingsSwitchTile(
            title: 'Backup Reminder',
            description: 'Remind me if an automatic backup has not run recently',
            value: notifications.backupReminder,
            onChanged: (v) => onChanged(notifications.copyWith(backupReminder: v)),
          ),
          SizedBox(height: AppSpacing.lg),
          SettingsSwitchTile(
            title: 'Subscription Reminder',
            description: 'Notify me before my plan renews or expires',
            value: notifications.subscriptionReminder,
            onChanged: (v) => onChanged(notifications.copyWith(subscriptionReminder: v)),
          ),
          SizedBox(height: AppSpacing.lg),
          SettingsSwitchTile(
            title: 'Notification Sound',
            description: 'Play a sound alongside desktop notifications',
            value: notifications.soundEnabled,
            onChanged: (v) => onChanged(notifications.copyWith(soundEnabled: v)),
          ),
        ],
      ),
    );
  }
}
