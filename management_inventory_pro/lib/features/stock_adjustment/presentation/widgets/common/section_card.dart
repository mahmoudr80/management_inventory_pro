import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_decoration.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const SectionCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Keep Theme.of(context) as the default surface so this still tracks
      // light/dark theme changes; AppColors.outlineVariant (via the shared
      // card() decoration) replaces the old hardcoded border color.
      decoration: AppDecorations.card(
        color: color ?? Theme.of(context).colorScheme.surface,
        radius: AppRadius.md,
      ),
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );
  }
}
