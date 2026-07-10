import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:management_inventory_pro/core/storage/storage_service.dart';

import '../../generated/assets.gen.dart';
import '../dependency_injection/service_locator.dart';
import '../theme/app_theme_extension.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class SideBarLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onLogout;

  const SideBarLayout({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final user = getIt<StorageService>().getAllUsers().first;
    debugPrint(user.imagePath);
    final List<_SidebarItem> items = [
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.dashboardIcon), icon: Icons.dashboard_outlined, label: 'Dashboard'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.productIcon), icon: Icons.inventory_2_outlined, label: 'Products'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.supplierIcon), icon: Icons.business_outlined, label: 'Suppliers'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.stockReceipts), label: 'Stock Receipts', icon: Icons.inventory),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.posIcon), icon: Icons.shopping_bag_outlined, label: 'POS'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.saleHistory), icon: Icons.menu_book_outlined, label: 'Sale History'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.stockAdjustment), icon: Icons.edit, label: 'Stock Adjustments'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.saleHistory), icon: Icons.menu_book_outlined, label: 'Adjustment History'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.settings), icon: Icons.settings_outlined, label: 'Settings'),
    ];

    final bool collapsed = Responsive.isCompact(context);
    final double railWidth = collapsed ? AppSize.navigationRailWidth : AppSize.sidebarWidth;

    return AnimatedContainer(
      duration: AppAnimation.normal,
      width: railWidth,
      color: context.colors.backgroundSideBar,
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: collapsed ? AppSpacing.xs : AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: context.colors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: context.colors.onPrimary,
                  size: AppIconSize.lg,
                ),
              ),
              if (!collapsed) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Tooltip(
                        message: 'OmniStock',
                        child: Text(
                          'OmniStock',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.headlineSm.copyWith(
                            color: context.colors.sideBarItemsActive,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'Global Operations',
                        child: Text(
                          'Global Operations',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelCaps.copyWith(
                            color: context.colors.sideBarItems.withAlpha(125),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),

          Expanded(
            child: ListView.separated(
              primary: false,
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.xxs),
              itemBuilder: (context, index) {
                final item = items[index];
                final bool isActive = selectedIndex == index;

                final Widget icon = SizedBox(
                  width: AppIconSize.lg,
                  height: AppIconSize.lg,
                  child: item.assetIcon ??
                      Icon(
                        item.icon,
                        color: isActive ? context.colors.sideBarItemsActive : context.colors.sideBarItems,
                        size: AppIconSize.lg,
                      ),
                );

                final Widget navItem = InkWell(
                  onTap: () => onItemSelected(index),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: AnimatedContainer(
                    clipBehavior: Clip.antiAlias,
                    duration: AppAnimation.fast,
                    padding: EdgeInsets.symmetric(
                      horizontal: collapsed ? AppSpacing.xs : AppSpacing.sm,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? context.colors.sideBarBackgroundActive : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: collapsed
                        ? Center(child: icon)
                        : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        icon,
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: Text(
                            item.label,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySm.copyWith(
                              color: isActive ? context.colors.sideBarItemsActive : context.colors.sideBarItems,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                return collapsed ? Tooltip(message: item.label, child: navItem) : navItem;
              },
            ),
          ),

          Container(
            height: AppBorder.thin,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            color: context.colors.sideBarBackgroundActive.withAlpha(125),
          ),

          if (collapsed)
            Column(
              children: [
                Tooltip(
                  message: user.name,
                  child:  CircleAvatar(
                    radius: AppIconSize.lg,
                    backgroundColor: context.colors.primaryContainer,
                    backgroundImage:  FileImage(
                      File(user.imagePath),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                IconButton(
                  icon: Icon(
                    Icons.logout_rounded,
                    color: context.colors.sideBarItems,
                    size: AppIconSize.md,
                  ),
                  onPressed: onLogout,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Logout',
                ),
              ],
            )
          else
            Wrap(
              children: [
                CircleAvatar(
                  radius: AppIconSize.lg,
                  backgroundColor: context.colors.primaryContainer,
                  backgroundImage:  FileImage(
                    File(user.imagePath),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.name,
                      style: AppTextStyles.bodySm.copyWith(
                        color: context.colors.sideBarItemsActive,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  ],
                ),
                SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: Icon(
                    Icons.logout_rounded,
                    color: context.colors.sideBarItems,
                    size: AppIconSize.md,
                  ),
                  onPressed: onLogout,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Logout',
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final Widget? assetIcon;
  final String label;

  _SidebarItem({required this.icon, required this.label, this.assetIcon});
}