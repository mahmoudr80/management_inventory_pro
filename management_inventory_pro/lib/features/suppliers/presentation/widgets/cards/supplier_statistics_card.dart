import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
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
      decoration: AppDecorations.card(color: AppColors.surfaceContainerLowest),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
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
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyles.display.copyWith(
                  fontSize: 28,
                  color: valueColor ?? AppColors.onSurface,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 8),
                _Badge(
                  text: badge!,
                  color: badgeColor ?? AppColors.surfaceContainerHigh,
                  textColor: badgeTextColor ?? AppColors.onSurfaceVariant,
                ),
              ],
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Expanded(child: Text(subtitle!, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant))),
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
