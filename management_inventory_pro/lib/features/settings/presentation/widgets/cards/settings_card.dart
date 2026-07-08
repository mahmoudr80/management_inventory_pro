import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_decoration.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

/// The card shell every settings section is wrapped in: title, optional
/// description, then arbitrary [child] content — matching the bordered,
/// shadow-less "Level 1" surface used across the app (see DESIGN.md).
///
/// [accentColor] draws a left rule and tints the title, used to make the
/// Backup & Restore card visually stand out per spec, without every other
/// section having to know about that special case.
class SettingsCard extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;
  final Widget? trailing;
  final Color? accentColor;

  const SettingsCard({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.trailing,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppDecorations.card().copyWith(
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant, width: AppBorder.thin),
          right: BorderSide(color: AppColors.outlineVariant, width: AppBorder.thin),
          bottom: BorderSide(color: AppColors.outlineVariant, width: AppBorder.thin),
          left: BorderSide(
            color: accentColor ?? AppColors.outlineVariant,
            width: accentColor != null ? 3 : AppBorder.thin,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.headlineSm.copyWith(
                        color: accentColor ?? AppColors.textPrimary,
                      ),
                    ),
                    if (description != null) ...[
                      SizedBox(height: AppSpacing.xxs),
                      Text(
                        description!,
                        style: AppTextStyles.bodySm,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Divider(height: 1, color: AppColors.outlineVariant),
          SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}
