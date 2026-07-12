import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:management_inventory_pro/core/storage/storage_service.dart';

import '../../../generated/assets.gen.dart';
import '../../dependency_injection/service_locator.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme_extension.dart';
import 'cubit/sidebar_cubit.dart';
import 'sidebar_footer.dart';
import 'sidebar_header.dart';
import 'sidebar_navigation.dart';

class SideBarLayout extends StatefulWidget {
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
  State<SideBarLayout> createState() => _SideBarLayoutState();
}

class _SideBarLayoutState extends State<SideBarLayout> {
  @override
  Widget build(BuildContext context) {
    // Very narrow desktop windows still auto-collapse regardless of the
    // saved preference; the preference itself is left untouched. Deferred
    // to a post-frame callback since it's a side effect triggered from
    // build().
    final isNarrow = Responsive.isCompact(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SidebarCubit>().applyResponsiveOverride(isNarrow: isNarrow);
    });

    final user = getIt<StorageService>().getAllUsers().first;

    final items = [
      SidebarNavEntry(icon: SvgPicture.asset(Assets.icons.dashboardIcon), label: 'Dashboard'),
      SidebarNavEntry(icon: SvgPicture.asset(Assets.icons.productIcon), label: 'Products'),
      SidebarNavEntry(icon: SvgPicture.asset(Assets.icons.supplierIcon), label: 'Suppliers'),
      SidebarNavEntry(icon: SvgPicture.asset(Assets.icons.stockReceipts), label: 'Stock Receipts'),
      SidebarNavEntry(icon: SvgPicture.asset(Assets.icons.posIcon), label: 'POS'),
      SidebarNavEntry(icon: SvgPicture.asset(Assets.icons.saleHistory), label: 'Sale History'),
      SidebarNavEntry(icon: SvgPicture.asset(Assets.icons.stockAdjustment), label: 'Stock Adjustments'),
      SidebarNavEntry(icon: SvgPicture.asset(Assets.icons.saleHistory), label: 'Adjustment History'),
      SidebarNavEntry(icon: SvgPicture.asset(Assets.icons.reportIcon), label: 'Reports'),
      SidebarNavEntry(icon: SvgPicture.asset(Assets.icons.settings), label: 'Settings'),
    ];

    return BlocSelector<SidebarCubit, SidebarState, bool>(
      selector: (state) => state.expanded,
      builder: (context, expanded) {
        final railWidth = expanded ? AppSize.sidebarWidth : AppSize.navigationRailWidth;

        return AnimatedContainer(
          duration: AppAnimation.normal,
          curve: Curves.easeInOut,
          width: railWidth,
          color: context.colors.backgroundSideBar,
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: expanded ? AppSpacing.sm : AppSpacing.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SidebarHeader(
                expanded: expanded,
                onToggle: () => context.read<SidebarCubit>().toggle(),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Expanded(
                child: SidebarNavigation(
                  items: items,
                  selectedIndex: widget.selectedIndex,
                  expanded: expanded,
                  onItemSelected: widget.onItemSelected,
                ),
              ),
              Container(
                height: AppBorder.thin,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                color: context.colors.sidebarDivider,
              ),
              SidebarFooter(
                userName: user.name,
                userImagePath: user.imagePath,
                expanded: expanded,
                onLogout: widget.onLogout,
              ),
            ],
          ),
        );
      },
    );
  }
}