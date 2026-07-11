import 'package:flutter/material.dart';
import '../../theme/app_theme_extension.dart';
import '../../theme/app_dimens.dart';

class SidebarToggleButton extends StatelessWidget {
  final bool expanded;
  final VoidCallback onPressed;

  const SidebarToggleButton({super.key, required this.expanded, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: expanded ? 'Collapse sidebar' : 'Expand sidebar',
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        hoverColor: context.colors.sidebarHoverBg,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: AnimatedSwitcher(
            duration: AppAnimation.fast,
            child: Icon(
              expanded ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
              key: ValueKey<bool>(expanded),
              color: context.colors.sideBarItems,
              size: AppIconSize.md,
            ),
          ),
        ),
      ),
    );
  }
}