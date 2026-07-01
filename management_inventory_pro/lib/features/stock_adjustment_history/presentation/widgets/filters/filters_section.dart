import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/widgets/custom_text_field.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_model.dart';
import '../../../data/models/adjustment_reason.dart';
import '../../../data/models/adjustment_status.dart';
import '../../../data/models/date_range_filter.dart';
import '../../cubit/stock_adjustment_history_cubit.dart';
import '../../cubit/stock_adjustment_history_state.dart';
import '../../../../../core/theme/app_dimens.dart';
import 'date_range_dropdown.dart';
import 'filter_dropdown.dart';

typedef _EmployeeFilterViewModel = ({String? employee, List<AdjustmentModel> all});

/// Search input plus Date Range / Reason / Status / Created By dropdowns,
/// and a Reset action. Filtering is fully wired (search + the four
/// dropdowns) against the in-memory mock dataset.
class FiltersSection extends StatelessWidget {
  const FiltersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StockAdjustmentHistoryCubit>();

    return Container(
      padding: EdgeInsets.only(left: 2.w,right: 2.w,bottom: 5.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Wrap(
        spacing: 3.w,
        runSpacing: 12.h,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          BlocSelector<StockAdjustmentHistoryCubit,
              StockAdjustmentHistoryState, String>(
            selector: (state) => state.searchText,
            builder: (context, searchText) {
              return CustomTextField(label: searchText,hint: 'Search by ID, Product, or SKU...',
                onChanged:
              cubit.updateSearchText , hintStyle: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                prefixIcon: Icon(Icons.search_outlined,size: 28.r,),);
            },
          ),
          BlocSelector<StockAdjustmentHistoryCubit,
              StockAdjustmentHistoryState, DateRangeFilter>(
            selector: (state) => state.selectedDateRange,
            builder: (context, value) {
              return DateRangeDropdown(
                value: value,
                onChanged: cubit.updateDateRange,
              );
            },
          ),
          BlocSelector<StockAdjustmentHistoryCubit,
              StockAdjustmentHistoryState, AdjustmentReason?>(
            selector: (state) => state.selectedReason,
            builder: (context, value) {
              return FilterDropdown<AdjustmentReason>(
                value: value,
                allLabel: 'All Reasons',
                items: AdjustmentReason.values,
                labelBuilder: (reason) => reason.label,
                onChanged: cubit.updateReason,
              );
            },
          ),
          BlocSelector<StockAdjustmentHistoryCubit,
              StockAdjustmentHistoryState, AdjustmentStatus?>(
            selector: (state) => state.selectedStatus,
            builder: (context, value) {
              return FilterDropdown<AdjustmentStatus>(
                value: value,
                allLabel: 'All Statuses',
                items: AdjustmentStatus.values,
                labelBuilder: (status) => status.label,
                onChanged: cubit.updateStatus,
              );
            },
          ),
          BlocSelector<StockAdjustmentHistoryCubit, StockAdjustmentHistoryState,
              _EmployeeFilterViewModel>(
            selector: (state) =>
                (employee: state.selectedEmployee, all: state.adjustments),
            builder: (context, data) {
              final employees = data.all.map((a) => a.createdBy).toSet().toList()
                ..sort();
              return FilterDropdown<String>(
                value: data.employee,
                allLabel: 'Created By',
                items: employees,
                labelBuilder: (e) => e,
                onChanged: cubit.updateEmployee,
              );
            },
          ),
          TextButton(
            onPressed: cubit.resetFilters,
            child: Text(
              'Reset',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
