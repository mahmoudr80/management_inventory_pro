import 'package:flutter/material.dart';
import '../../theme/app_theme_extension.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_text_styles.dart';

class SidebarNavigationItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool isActive;
  final bool expanded;
  final VoidCallback onTap;

  const SidebarNavigationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      hoverColor: context.colors.sidebarHoverBg,
      child: AnimatedContainer(
        clipBehavior: Clip.antiAlias,
        duration: AppAnimation.fast,
        padding: EdgeInsets.symmetric(
          horizontal: expanded ? AppSpacing.sm : AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive ? context.colors.sideBarBackgroundActive : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isActive
              ? Border(left: BorderSide(color: context.colors.sidebarActiveIndicator, width: AppBorder.thick))
              : null,
        ),
        child: expanded
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySm.copyWith(
                  color: isActive ? context.colors.sideBarItemsActive : context.colors.sideBarItems,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        )
            : Center(child: icon),
      ),
    );

    return expanded ? content : Tooltip(message: label, child: content);
  }
}