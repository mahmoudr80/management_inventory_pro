import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/widgets/secondary_button.dart';
import '../../../models/settings_model.dart';
import '../cards/backup_information_card.dart';
import '../cards/settings_card.dart';
import '../fields/settings_switch_tile.dart';
import '../fields/settings_text_field.dart';

/// "Backup & Restore" card — this is the one section the spec calls out
/// to visually stand out, since it protects customer data. Achieved via
/// [SettingsCard.accentColor] (a colored left rule + tinted title) rather
/// than a heavier one-off treatment, so it still reads as part of the
/// same design system.
class BackupSection extends StatelessWidget {
  final BackupSettings backup;
  final ValueChanged<BackupSettings> onChanged;
  final VoidCallback? onManualBackup;
  final VoidCallback? onRestore;

  const BackupSection({
    super.key,
    required this.backup,
    required this.onChanged,
    this.onManualBackup,
    this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Backup & Restore',
      description: 'Data redundancy',
      accentColor: AppColors.error,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 720;

          final form = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsSwitchTile(
                title: 'Automatic Backup',
                description: 'Back up the database daily in the background',
                value: backup.automaticBackup,
                onChanged: (v) => onChanged(backup.copyWith(automaticBackup: v)),
              ),
              SizedBox(height: AppSpacing.lg),
              SettingsTextField(
                label: 'Backup Folder',
                initialValue: backup.backupFolder,
                onChanged: (v) => onChanged(backup.copyWith(backupFolder: v)),
              ),
              SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Manual Backup',
                      icon: Icons.backup_outlined,
                      onPressed: onManualBackup ?? () {},
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SecondaryButton(
                      text: 'Restore from File',
                      icon: Icons.restore_outlined,
                      onPressed: onRestore ?? () {},
                    ),
                  ),
                ],
              ),
            ],
          );

          final info = BackupInformationCard(
            databaseSizeMb: backup.databaseSizeMb,
            lastBackup: backup.lastBackup,
            storageUsagePercent: backup.storageUsagePercent,
          );

          if (isNarrow) {
            return Column(children: [form, SizedBox(height: AppSpacing.lg), info]);
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: form),
              SizedBox(width: AppSpacing.lg),
              Expanded(flex: 2, child: info),
            ],
          );
        },
      ),
    );
  }
}
