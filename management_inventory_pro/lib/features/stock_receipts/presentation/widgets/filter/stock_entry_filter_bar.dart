import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/cubit/stock_entry_cubit.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/filter/status_toggle_group.dart';

import '../../../../../core/theme/app_theme_extension.dart';
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
    this.activeFilter,
    this.selectedSupplier,
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
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: context.colors.primary,
            onPrimary: context.colors.onPrimary,
            surface: context.colors.surfaceContainerLowest,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => _selectedDateRange = picked);
      widget.onFilterDateRange(picked);
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
    String d(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    return '${d(dr.start)} – ${d(dr.end)}';
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 750;
        final double? width = isNarrow
            ? (constraints.maxWidth < 500
            ? double.infinity
            : (constraints.maxWidth - 44) / 2)
            : null;

        final supplierDropdownWidget = BlocBuilder<StockEntryCubit, StockEntryState>(
          builder: (context, state) {
            return SupplierDropdown(
              onChanged: (SupplierRef? supplier) {
                context.read<StockEntryCubit>()
                  ..selectSupplier(supplier)
                  ..search(supplier?.id ?? '');
              },
              selected: state.selectedSupplier,
              clear: state.filter.isEmpty,
            );
          },
        );

        final dateRangeWidget = DateRangeButton(
          selectedRange: _selectedDateRange,
          onTap: _pickDateRange,
          onClear: _selectedDateRange != null ? _clearDate : null,
          formatDateRange: _formatDateRange,
        );

        final statusToggleWidget = StatusToggleGroup(
          activeStatus: widget.activeFilter?.status,
          onChanged: widget.onFilterStatus,
        );

        final clearWidget = _hasActiveFilters
            ? TextButton.icon(
          onPressed: () {
            widget.searchController.clear();
            setState(() => _selectedDateRange = null);
            widget.onClearFilters();
          },
          icon: const Icon(Icons.filter_list_off, size: 15),
          label: Text('Clear', style: AppTextStyles.bodySm),
          style: TextButton.styleFrom(
            foregroundColor: context.colors.outline,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            visualDensity: VisualDensity.compact,
          ),
        )
            : null;

        if (isNarrow) {
          return Container(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.colors.outlineVariant),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(width: width, child: supplierDropdownWidget),
                SizedBox(width: width, child: dateRangeWidget),
                SizedBox(width: double.infinity, child: statusToggleWidget),
                if (clearWidget != null) clearWidget,
              ],
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.colors.outlineVariant),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: supplierDropdownWidget),
              const SizedBox(width: 12),
              Expanded(child: dateRangeWidget),
              const SizedBox(width: 12),
              Expanded(child: statusToggleWidget),
              if (clearWidget != null) ...[
                const SizedBox(width: 12),
                clearWidget,
              ],
            ],
          ),
        );
      },
    );
  }
}