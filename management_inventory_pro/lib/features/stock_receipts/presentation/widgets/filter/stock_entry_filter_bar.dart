import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/cubit/stock_entry_cubit.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/filter/status_toggle_group.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_filter.dart';
import '../../../data/models/stock_entry_status.dart';
import '../../../data/models/supplier_ref.dart';
import '../supplier_dropdown.dart';
import 'date_range_button.dart';

class StockEntryFilterBar extends StatefulWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final ValueChanged<StockEntryStatus?> onFilterStatus;
  final ValueChanged<SupplierRef?> onFilterSupplier;
  final ValueChanged<DateTimeRange?> onFilterDateRange;
  final VoidCallback onClearFilters;
  final SupplierRef? selectedSupplier;

  final StockEntryFilter? activeFilter;

  const StockEntryFilterBar({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.onFilterStatus,
    required this.onFilterSupplier,
    required this.onFilterDateRange,
    required this.onClearFilters,
    this.activeFilter, this.selectedSupplier,
  });

  @override
  State<StockEntryFilterBar> createState() => _StockEntryFilterBarState();
}

class _StockEntryFilterBarState extends State<StockEntryFilterBar> {
  DateTimeRange? _selectedDateRange;

  // ── Date picker ────────────────────────────────────────────────────────────

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) =>
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: AppColors.onPrimary,
                surface: AppColors.surfaceContainerLowest,
              ),
            ),
            child: child!,
          ),
    );

    if (picked != null) {
      setState(() => _selectedDateRange = picked);
      widget.onFilterDateRange(picked);
    } else if (_selectedDateRange != null && picked == null) {
      // User cancelled — do nothing; keep existing selection.
    }
  }

  void _clearDate() {
    setState(() => _selectedDateRange = null);
    widget.onFilterDateRange(null);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool get _hasActiveFilters {
    final f = widget.activeFilter;
    if (f == null) return false;
    return !f.isEmpty || widget.searchController.text.isNotEmpty;
  }

  String _formatDateRange(DateTimeRange dr) {
    String _d(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(
            2, '0')}/${d.year}';
    return '${_d(dr.start)} – ${_d(dr.end)}';
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        spacing: 12.w,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ── Search ─────────────────────────────────────────────────────────
          Expanded(
              child: BlocBuilder<StockEntryCubit, StockEntryState>(
                builder: (context, state) {
                  print(
                    'Builder selected supplier = ${state.selectedSupplier?.name}',
                  );
                  return SupplierDropdown(onChanged: (SupplierRef? supplier)
                  {
                    print('SELECTED On Change: ${supplier?.name}');
                    context.read<StockEntryCubit>()..selectSupplier(supplier)
                      ..search(supplier?.id ?? '');
                  }
                  ,
                    selected:state.selectedSupplier,
                    clear: state.filter.isEmpty,
                    );
                },
              )),
          // ── Date Range ─────────────────────────────────────────────────────
          Expanded(
            child: DateRangeButton(
              selectedRange: _selectedDateRange,
              onTap: _pickDateRange,
              onClear: _selectedDateRange != null ? _clearDate : null,
              formatDateRange: _formatDateRange,
            ),
          ),

          // ── Status toggles ─────────────────────────────────────────────────
          Expanded(
            child: StatusToggleGroup(
              activeStatus: widget.activeFilter?.status,
              onChanged: widget.onFilterStatus,
            ),
          ),

          // ── Clear all filters ──────────────────────────────────────────────
          if (_hasActiveFilters)
            TextButton.icon(
              onPressed: () {
                widget.searchController.clear();
                setState(() => _selectedDateRange = null);
                widget.onClearFilters();
              },
              icon: const Icon(Icons.filter_list_off, size: 15),
              label: Text('Clear', style: AppTextStyles.bodySm),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.outline,
                padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                visualDensity: VisualDensity.compact,
              ),
            ),
        ],
      ),
    );
  }
}

