import 'package:flutter/material.dart';
import '../../theme/app_theme_extension.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_text_styles.dart';
import 'sidebar_toggle_button.dart';

class SidebarHeader extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;

  const SidebarHeader({super.key, required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isNarrow = Responsive.isCompact(context);

    final logo = Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: context.colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(Icons.inventory_2, color: context.colors.onPrimary, size: AppIconSize.lg),
    );

    final titleBlock = expanded
        ? Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('OmniStock',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.headlineSm.copyWith(
                  color: context.colors.sideBarItemsActive, fontWeight: FontWeight.bold)),
          Text('Global Operations',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelCaps.copyWith(
                  color: context.colors.sideBarItems.withAlpha(125))),
        ],
      ),
    )
        : const SizedBox.shrink();

    if (!expanded) {
      return Column(
        children: [
          logo,
          const SizedBox(height: AppSpacing.xs),
          if (!isNarrow) SidebarToggleButton(expanded: expanded, onPressed: onToggle),
        ],
      );
    }

    return Row(
      children: [
        logo,
        Expanded(
          child: AnimatedSize(
            duration: AppAnimation.normal,
            alignment: Alignment.centerLeft,
            child: titleBlock,
          ),
        ),
        if (!isNarrow) SidebarToggleButton(expanded: expanded, onPressed: onToggle),
      ],
    );
  }
}
