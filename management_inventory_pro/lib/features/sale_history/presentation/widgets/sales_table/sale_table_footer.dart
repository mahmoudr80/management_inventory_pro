import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      color: const Color(0xFFF9FAFB),
      child: Row(
        children: [
          Text(
            'Showing $start to $end of $filteredTotal results',
            style: TextStyle(
              fontSize: 4.sp,
              color: const Color(0xFF6B7280),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
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


