import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                '...',
                style: TextStyle(fontSize: 4.sp, color: const Color(0xFF6B7280)),
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
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: 24.r,
        height: 24.r,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 28.r,
          color: onTap != null
              ? const Color(0xFF374151)
              : const Color(0xFFD1D5DB),
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
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: 22.r,
        height: 22.r,
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          page.toString(),
          style: TextStyle(
            fontSize: 4.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }
}
