import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';
import 'pagination_controls.dart';

class SaleTableFooter extends StatelessWidget {
  const SaleTableFooter({super.key,
    required this.filteredTotal,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.onPageChanged,
  });

  final int filteredTotal;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final start = (currentPage - 1) * pageSize + 1;
    final end = (currentPage * pageSize).clamp(0, filteredTotal);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      color: context.colors.surfaceContainerLow,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: AppSpacing.md,
        children: [
          Text(
            'Showing $start to $end of $filteredTotal results',
            style: AppTextStyles.bodySm.copyWith(
              color: context.colors.textSecondary,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          PaginationControls(
            currentPage: currentPage,
            totalPages: totalPages,
            onPageChanged: onPageChanged,
          ),
        ],
      ),
    );
  }
}