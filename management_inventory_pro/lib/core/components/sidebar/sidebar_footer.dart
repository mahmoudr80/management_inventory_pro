import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_theme_extension.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_text_styles.dart';

class SidebarFooter extends StatelessWidget {
  final String userName;
  final String userImagePath;
  final bool expanded;
  final VoidCallback onLogout;

  const SidebarFooter({
    super.key,
    required this.userName,
    required this.userImagePath,
    required this.expanded,
    required this.onLogout,
  });

  // Minimum width the expanded (avatar + name + logout) row needs
  // before it's safe to render without overflowing.
  static const double _expandedRowMinWidth = 160;

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: AppIconSize.lg,
      backgroundColor: context.colors.primaryContainer,
      backgroundImage: FileImage(File(userImagePath)),
    );

    final logoutButton = IconButton(
      icon: Icon(Icons.logout_rounded,
          color: context.colors.sideBarItems, size: AppIconSize.md),
      onPressed: onLogout,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      tooltip: 'Logout',
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Trust the real available width, not just the `expanded` flag —
        // the sidebar width animates and `expanded` can flip before the
        // width has finished animating, which is what caused the overflow.
        final canShowExpanded =
            expanded && constraints.maxWidth >= _expandedRowMinWidth;

        if (!canShowExpanded) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(message: userName, child: avatar),
              const SizedBox(height: AppSpacing.sm),
              logoutButton,
            ],
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            avatar,
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                userName,
                style: AppTextStyles.bodySm.copyWith(
                  color: context.colors.sideBarItemsActive,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            logoutButton,
          ],
        );
      },
    );
  }
}