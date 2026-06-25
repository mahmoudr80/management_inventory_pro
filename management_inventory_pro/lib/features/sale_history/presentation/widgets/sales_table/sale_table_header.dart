import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/sales_history_cubit.dart';

class SaleTableHeader extends StatelessWidget {
  const SaleTableHeader({super.key,
    required this.sortColumn,
    required this.sortDirection,
    required this.onSort,
  });

  final SortColumn sortColumn;
  final SortDirection sortDirection;
  final ValueChanged<SortColumn> onSort;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      color: const Color(0xFFF9FAFB),
      child: Row(
        children: [
          _HeaderCell(
            label: 'Sale ID',
            flex: 2,
            column: SortColumn.saleId,
            activeColumn: sortColumn,
            direction: sortDirection,
            onSort: onSort,
          ),
          _HeaderCell(
            label: 'Date & Time',
            flex: 3,
            column: SortColumn.dateTime,
            activeColumn: sortColumn,
            direction: sortDirection,
            onSort: onSort,
          ),
          _HeaderCell(
            label: 'Items',
            flex: 1,
            column: SortColumn.itemsCount,
            activeColumn: sortColumn,
            direction: sortDirection,
            onSort: onSort,
          ),
          _HeaderCell(
            label: 'Qty',
            flex: 1,
            column: SortColumn.quantity,
            activeColumn: sortColumn,
            direction: sortDirection,
            onSort: onSort,
          ),
          _HeaderCell(
            label: 'Total Amount',
            flex: 2,
            column: SortColumn.totalAmount,
            activeColumn: sortColumn,
            direction: sortDirection,
            onSort: onSort,
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Payment',
              style: TextStyle(
                fontSize: 4.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Cashier',
              style: TextStyle(
                fontSize: 4.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.label,
    required this.flex,
    required this.column,
    required this.activeColumn,
    required this.direction,
    required this.onSort,
  });

  final String label;
  final int flex;
  final SortColumn column;
  final SortColumn activeColumn;
  final SortDirection direction;
  final ValueChanged<SortColumn> onSort;

  @override
  Widget build(BuildContext context) {
    final isActive = column == activeColumn;
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => onSort(column),
        borderRadius: BorderRadius.circular(4.r),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 4.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF6B7280),
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(width: 2.w),
              Icon(
                isActive && direction == SortDirection.ascending
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 5.r,
                color: isActive
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFD1D5DB),
              ),
            ],
          ),
        ),
      ),
    );
  }
}