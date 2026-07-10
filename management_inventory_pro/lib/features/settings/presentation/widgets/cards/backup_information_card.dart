import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

/// Solid-primary info panel summarizing backup health: database size,
/// last backup timestamp, and a storage-usage progress bar. Styled after
/// the "Tax Engine Preview" panel in the reference design — a filled
/// primary surface used to draw the eye to data the user should trust.
class BackupInformationCard extends StatelessWidget {
  final double databaseSizeMb;
  final DateTime lastBackup;
  final double storageUsagePercent;

  const BackupInformationCard({
    super.key,
    required this.databaseSizeMb,
    required this.lastBackup,
    required this.storageUsagePercent,
  });

  String get _lastBackupLabel {
    final diff = DateTime.now().difference(lastBackup);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DATABASE HEALTH',
            style: AppTextStyles.labelCaps.copyWith(color: context.colors.onPrimary.withOpacity(0.75)),
          ),
          SizedBox(height: AppSpacing.md),
          _row(context, 'Database Size', '${databaseSizeMb.toStringAsFixed(1)} MB'),
          _row(context, 'Last Backup', _lastBackupLabel),
          SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: (storageUsagePercent / 100).clamp(0, 1),
              minHeight: 6,
              backgroundColor: context.colors.onPrimary.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(context.colors.onPrimary),
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Storage usage: ${storageUsagePercent.toStringAsFixed(0)}%',
            style: AppTextStyles.bodySm.copyWith(color: context.colors.onPrimary.withOpacity(0.85)),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMd.copyWith(color: context.colors.onPrimary.withOpacity(0.85))),
          Text(
            value,
            style: AppTextStyles.bodyMd.copyWith(color: context.colors.onPrimary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
