import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_decoration.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

/// Compact overview card: icon, "Label-Caps" title, and a headline value —
/// used for the four summary tiles at the top of the Settings page
/// (Store, Subscription, Database Size, Last Backup).
class InformationCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? caption;
  final Color? iconColor;

  const InformationCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.caption,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 220),
      padding: EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppIconSize.xl,
            height: AppIconSize.xl,
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, size: AppIconSize.md, color: iconColor ?? AppColors.primary),
          ),
          SizedBox(height: AppSpacing.md),
          Text(label, style: AppTextStyles.labelCaps),
          SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.headlineMd,
          ),
          if (caption != null) ...[
            SizedBox(height: AppSpacing.xxs),
            Text(
              caption!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm,
            ),
          ],
        ],
      ),
    );
  }
}
