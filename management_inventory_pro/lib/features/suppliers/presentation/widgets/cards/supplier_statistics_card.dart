import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_decoration.dart';
import '../../../../../core/theme/app_text_styles.dart';

class SupplierStatisticsCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final IconData icon;
  final Color? valueColor;

  const SupplierStatisticsCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.subtitle,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(color: context.colors.surfaceContainerLowest),
      padding: const EdgeInsets.all(5),
      child: Wrap(
        spacing: 4,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: AppTextStyles.labelCaps,
                ),
              ),
              Container(
                width: 36,
                height: 33,
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: context.colors.onSurfaceVariant),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyles.display.copyWith(
                  fontSize: 28,
                  color: valueColor ?? context.colors.onSurface,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 8),
                _Badge(
                  text: badge!,
                  color: badgeColor ?? context.colors.surfaceContainerHigh,
                  textColor: badgeTextColor ?? context.colors.onSurfaceVariant,
                ),
              ],
            ],
          ),
          
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: AppTextStyles.bodySm.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Badge({required this.text, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: AppTextStyles.labelCaps.copyWith(color: textColor, fontSize: 10)),
    );
  }
}