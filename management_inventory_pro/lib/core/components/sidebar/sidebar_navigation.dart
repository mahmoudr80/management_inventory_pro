import 'package:flutter/material.dart';
import '../../theme/app_dimens.dart';
import 'sidebar_navigation_item.dart';

class SidebarNavEntry {
  final Widget icon;
  final String label;
  const SidebarNavEntry({required this.icon, required this.label});
}

class SidebarNavigation extends StatelessWidget {
  final List<SidebarNavEntry> items;
  final int selectedIndex;
  final bool expanded;
  final ValueChanged<int> onItemSelected;

  const SidebarNavigation({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.expanded,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.xxs),
      itemBuilder: (context, index) {
        final item = items[index];
        return SidebarNavigationItem(
          icon: item.icon,
          label: item.label,
          isActive: selectedIndex == index,
          expanded: expanded,
          onTap: () => onItemSelected(index),
        );
      },
    );
  }
}