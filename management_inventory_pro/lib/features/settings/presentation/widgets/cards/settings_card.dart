import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_decoration.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

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
    final baseDecoration = AppDecorations.card();
    // Reuse whatever radius the design system already defines for cards,
    // instead of hardcoding it here.
    final radius = (baseDecoration.borderRadius as BorderRadius?) ?? BorderRadius.zero;

    return ClipRRect(
      // Clips the accent stripe to the card's rounded corners so it can't
      // poke a square edge out past the border.
      borderRadius: radius,
      child: Container(
        width: double.infinity,
        decoration: baseDecoration.copyWith(
          // Uniform border on all four sides — this is what was breaking
          // when the left side got a different color/width for the accent.
          border: Border.all(
            color: context.colors.outlineVariant,
            width: AppBorder.thin,
          ),
        ),
        child: Stack(
          children: [
            if (accentColor != null)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 3, color: accentColor),
              ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.cardPadding),
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
                              style: AppTextStyles.headlineSm
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
                  Divider(height: 1, color: context.colors.outlineVariant),
                  SizedBox(height: AppSpacing.lg),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}