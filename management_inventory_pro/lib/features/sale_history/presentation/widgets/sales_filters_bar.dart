import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/filter_dropdown.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sale_search_field.dart';
import '../../data/models/sale_item_model.dart';
import '../cubit/sales_history_cubit.dart';

class SalesFiltersBar extends StatefulWidget {
  const SalesFiltersBar({super.key, required this.filters});

  final ActiveFilters filters;

  @override
  State<SalesFiltersBar> createState() => _SalesFiltersBarState();
}

class _SalesFiltersBarState extends State<SalesFiltersBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: widget.filters.searchQuery);
  }

  @override
  void didUpdateWidget(SalesFiltersBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters.searchQuery != _searchController.text) {
      _searchController.text = widget.filters.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        spacing: 5.w,
        children: [
          // Search
          SaleSearchField(searchController: _searchController,),

          // Date range filter
          Expanded(flex: 1,
            child: _DateRangeDropdown(
              value: widget.filters.dateRangeFilter,
              onChanged: cubit.setDateRangeFilter,
            ),
          ),

          // Payment method filter
          Expanded(flex: 1,
            child: _PaymentMethodDropdown(
              value: widget.filters.paymentMethod,
              onChanged: cubit.setPaymentMethod,
            ),
          ),

          // Reset
          if (widget.filters.hasActiveFilters)
            Container(
              margin: EdgeInsets.only(top: 22.h),
              child: TextButton.icon(
                onPressed: () {
                  _searchController.clear();
                  cubit.resetFilters();
                },
                icon: Icon(Icons.refresh_rounded, size: 5.sp),
                label: Text('Reset', style: TextStyle(fontSize: 4.sp)),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6B7280),
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _DateRangeDropdown extends StatelessWidget {
  const _DateRangeDropdown({required this.value, required this.onChanged});

  final DateRangeFilter value;
  final ValueChanged<DateRangeFilter> onChanged;

  String _label(DateRangeFilter f) => switch (f) {
        DateRangeFilter.today => 'Today',
        DateRangeFilter.yesterday => 'Yesterday',
        DateRangeFilter.last7Days => 'Last 7 Days',
        DateRangeFilter.thisMonth => 'This Month',
        DateRangeFilter.custom => 'Custom Range',
      };

  @override
  Widget build(BuildContext context) {
    return FilterDropdown<DateRangeFilter>(
      value: value,
      icon: Icons.calendar_today_rounded,
      items: DateRangeFilter.values,
      labelBuilder: _label,
      onChanged: onChanged,
    );
  }
}

class _PaymentMethodDropdown extends StatelessWidget {
  const _PaymentMethodDropdown({required this.value, required this.onChanged});

  final PaymentMethod value;
  final ValueChanged<PaymentMethod> onChanged;

  // `mixed` acts as "All Payment Methods" sentinel in the filter
  String _label(PaymentMethod m) => switch (m) {
        PaymentMethod.mixed => 'All Payment Methods',
        PaymentMethod.cash => 'Cash',
        PaymentMethod.card => 'Card',
      };

  @override
  Widget build(BuildContext context) {
    return FilterDropdown(value: value, icon: Icons.payment_rounded,
        items: PaymentMethod.values, labelBuilder: _label, onChanged: onChanged);
  }
}


