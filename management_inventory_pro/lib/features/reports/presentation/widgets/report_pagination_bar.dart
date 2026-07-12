import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// Prev/page-number/Next control, matching the "Showing X to Y of Z
/// entries" footer in the reference UI. Purely presentational — the
/// owning cubit tracks the actual page index and page size.
class ReportPaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalEntries;
  final int pageSize;
  final ValueChanged<int> onPageChanged;

  const ReportPaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalEntries,
    required this.pageSize,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final start = totalEntries == 0 ? 0 : (currentPage - 1) * pageSize + 1;
    final end = (currentPage * pageSize).clamp(0, totalEntries);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $start to $end of $totalEntries entries',
            style: AppTextStyles.bodySm.copyWith(color: context.colors.textSecondary),
          ),
          Row(
            children: [
              _PageButton(
                label: 'Prev',
                enabled: currentPage > 1,
                onTap: () => onPageChanged(currentPage - 1),
              ),
              for (final page in _visiblePages())
                _PageButton(
                  label: '$page',
                  isActive: page == currentPage,
                  onTap: () => onPageChanged(page),
                ),
              _PageButton(
                label: 'Next',
                enabled: currentPage < totalPages,
                onTap: () => onPageChanged(currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<int> _visiblePages() {
    if (totalPages <= 5) return List.generate(totalPages, (i) => i + 1);
    final pages = <int>{1, totalPages, currentPage, currentPage - 1, currentPage + 1};
    return pages.where((p) => p >= 1 && p <= totalPages).toList()..sort();
  }
}

class _PageButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool enabled;
  final VoidCallback onTap;

  const _PageButton({
    required this.label,
    this.isActive = false,
    this.enabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xxs),
      child: OutlinedButton(
        onPressed: enabled ? onTap : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: isActive ? context.colors.primary : Colors.transparent,
          foregroundColor: isActive ? context.colors.onPrimary : context.colors.textSecondary,
          side: BorderSide(color: isActive ? context.colors.primary : context.colors.outlineVariant),
          minimumSize: const Size(32, 32),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
        ),
        child: Text(label, style: AppTextStyles.bodySm),
      ),
    );
  }
}
