import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';
import 'package:management_inventory_pro/core/widgets/custom_text_field.dart';
import '../../../data/models/adjustment_model.dart';
import '../../../data/models/adjustment_reason.dart';
import '../../../data/models/adjustment_status.dart';
import '../../../data/models/date_range_filter.dart';
import '../../cubit/stock_adjustment_history_cubit.dart';
import '../../cubit/stock_adjustment_history_state.dart';
import 'date_range_dropdown.dart';
import 'filter_dropdown.dart';

typedef _EmployeeFilterViewModel = ({String? employee, List<AdjustmentModel> all});

/// Search input plus Date Range / Reason / Status / Created By dropdowns,
/// and a Reset action. Filtering is fully wired (search + the four
/// dropdowns) against the in-memory mock dataset.
///
/// The search field owns a [TextEditingController] so its value and the
/// cubit's `searchText` stay in sync in both directions: typing pushes to
/// the cubit via `onChanged`, and external changes (e.g. Reset) push back
/// into the field via a `BlocListener`. Previously the field's live value
/// was fed into its `label` slot instead of its actual text, so the typed
/// text floated as a label and Reset didn't visibly clear the box.
class FiltersSection extends StatefulWidget {
  const FiltersSection({super.key});

  @override
  State<FiltersSection> createState() => _FiltersSectionState();
}

class _FiltersSectionState extends State<FiltersSection> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final initialText =
        context.read<StockAdjustmentHistoryCubit>().state.searchText;
    _searchController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StockAdjustmentHistoryCubit>();

    return BlocListener<StockAdjustmentHistoryCubit, StockAdjustmentHistoryState>(
      listenWhen: (previous, current) =>
          previous.searchText != current.searchText,
      listener: (context, state) {
        // Only overwrite when the change didn't originate from this field's
        // own onChanged (i.e. Reset or any other external state change), so
        // we never fight the user's cursor while they're typing.
        if (_searchController.text != state.searchText) {
          _searchController.value = _searchController.value.copyWith(
            text: state.searchText,
            selection: TextSelection.collapsed(offset: state.searchText.length),
            composing: TextRange.empty,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: AppSpacing.xxs,
          right: AppSpacing.xxs,
          bottom: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          border: Border.all(color: AppColors.outlineVariant),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSize.searchFieldMaxWidth,
                minWidth: AppSize.searchFieldMinWidth,
              ),
              child: CustomTextField(
                controller: _searchController,
                label: 'Search',
                hint: 'Search by ID, Product, or SKU...',
                onChanged: cubit.updateSearchText,
                hintStyle: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                prefixIcon: const Icon(Icons.search_outlined, size: AppIconSize.lg),
              ),
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
              child: Tooltip(
                message: 'Reset Filters',
                child: Text(
                  'Reset',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
