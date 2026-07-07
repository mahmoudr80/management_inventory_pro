import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

class PaginationControls extends StatelessWidget {
  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final pages = _visiblePages();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PageButton(
          icon: Icons.chevron_left_rounded,
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        ...pages.map((p) {
          if (p == -1) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Text(
                '...',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary),
              ),
            );
          }
          return _PageNumberButton(
            page: p,
            isActive: p == currentPage,
            onTap: () => onPageChanged(p),
          );
        }),
        _PageButton(
          icon: Icons.chevron_right_rounded,
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }

  List<int> _visiblePages() {
    if (totalPages <= 5) return List.generate(totalPages, (i) => i + 1);
    final pages = <int>[];
    pages.add(1);
    if (currentPage > 3) pages.add(-1);
    for (var i = (currentPage - 1).clamp(2, totalPages - 1);
    i <= (currentPage + 1).clamp(2, totalPages - 1);
    i++) {
      pages.add(i);
    }
    if (currentPage < totalPages - 2) pages.add(-1);
    pages.add(totalPages);
    return pages;
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        width: AppSpacing.xl,
        height: AppSpacing.xl,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: AppSpacing.lg,
          color: onTap != null
              ? AppColors.textPrimary
              : AppColors.border,
        ),
      ),
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  const _PageNumberButton({
    required this.page,
    required this.isActive,
    required this.onTap,
  });
  final int page;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? null : onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        width: AppSpacing.xl,
        height: AppSpacing.xl,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          page.toString(),
          style: AppTextStyles.bodySm.copyWith(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? AppColors.surface : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
