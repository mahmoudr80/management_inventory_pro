import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.sm),
      color: AppColors.surfaceContainerLow,
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
              style: AppTextStyles.bodySm.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Cashier',
              style: AppTextStyles.bodySm.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
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
    required this.label, required this.flex, required this.column,
    required this.activeColumn, required this.direction, required this.onSort,
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
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySm.copyWith(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              isActive && direction == SortDirection.ascending
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              size: AppSpacing.md,
              color: isActive ? AppColors.primary : AppColors.border,
            ),
          ],
        ),
      ),
    );
  }
}