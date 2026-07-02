import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/assets.gen.dart';
import '../theme/app_colors.dart';
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
    final List<_SidebarItem> items = [
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.dashboardIcon),icon: Icons.dashboard_outlined, label: 'Dashboard'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.productIcon),icon: Icons.inventory_2_outlined, label: 'Products'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.supplierIcon),icon: Icons.business_outlined, label: 'Suppliers'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.stockReceipts), label: 'Stock Receipts', icon: Icons.inventory),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.posIcon),icon: Icons.shopping_bag_outlined, label: 'POS'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.saleHistory),icon: Icons.menu_book_outlined, label: 'Sale History'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.stockAdjustment),icon: Icons.edit, label: 'Stock Adjustments'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.saleHistory),icon: Icons.menu_book_outlined, label: 'Adjustment History'),
      _SidebarItem(assetIcon: SvgPicture.asset(Assets.icons.settings),icon: Icons.settings_outlined, label: 'Settings'),
    ];

    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width/5),
      color: AppColors.backgroundSideBar,
      padding: EdgeInsets.symmetric(vertical: 15.h.clamp(10, 20),
          horizontal: 10.w.clamp(8,12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Logo area
          Row(
            spacing: 5.w,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: AppColors.onPrimary,
                  size: 30.r,
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OmniStock',
                    style: AppTextStyles.headlineSm.copyWith(
                      color: AppColors.sideBarItemsActive,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp.clamp(11, 19),
                    ),
                  ),
                  Text(
                    'Global Operations',
                    style: AppTextStyles.labelCaps.copyWith(
                      color: AppColors.sideBarItems.withAlpha(125),
                      fontSize: 9.sp.clamp(7, 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30.h.clamp(25, 35)),

          // Navigation Items
          Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => SizedBox(height: 4.h),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final bool isActive = selectedIndex == index;
              
                  return InkWell(
                    onTap: () => onItemSelected(index),
                    borderRadius: BorderRadius.circular(4.r),
                    child: AnimatedContainer(clipBehavior: Clip.antiAlias,

                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.only(left: 4.w,top: 10.h,bottom: 10.h ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.sideBarBackgroundActive
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        spacing: 5.w.clamp(3,7),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          item.assetIcon!=null?item.assetIcon!: Icon(
                            item.icon,
                            color: isActive
                                ? AppColors.sideBarItemsActive
                                : AppColors.sideBarItems,
                            size: 24.r,
                          ),
                          Text(
                            item.label,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySm.copyWith(
                              color: isActive
                                  ? AppColors.sideBarItemsActive
                                  : AppColors.sideBarItems,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                              fontSize: 13.sp.clamp(9, 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),


          // Divider
          Container(
            height: 1.0,
            width: 200,
            margin: EdgeInsets.symmetric(vertical: 12.h),
            color: AppColors.sideBarBackgroundActive.withAlpha(125),
          ),

          // Profile section at bottom
          Row(
            spacing: 5.w.clamp(3,7),
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 25.r.clamp(20, 30),
                backgroundColor: AppColors.primaryContainer,
                backgroundImage: Assets.images.userProfile.image().image,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Mahmoud Saeid',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.sideBarItemsActive,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp.clamp(9, 15),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Flutter Lead',
                      style: AppTextStyles.labelCaps.copyWith(
                        color: AppColors.sideBarItems.withAlpha(125),
                        fontSize: 8.sp.clamp(6, 14),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon:  Icon(
                  Icons.logout_rounded,
                  color: AppColors.sideBarItems,
                  size: 20.r.clamp(15, 25),
                ),
                onPressed: onLogout,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20.r.clamp(16, 23),
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
