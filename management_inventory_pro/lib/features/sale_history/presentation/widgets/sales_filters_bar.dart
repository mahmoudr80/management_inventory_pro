import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sale_search_field.dart';
import '../../../../core/widgets/dropdown_item.dart';
import '../../../../core/widgets/filter_dropdown.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/theme/app_decoration.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.md),
      decoration: AppDecorations.card(
        color: context.colors.surface,
        borderColor: context.colors.border,
      ),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SaleSearchField(searchController: _searchController,),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: _DateRangeDropdown(
              value: widget.filters.dateRangeFilter,
              onChanged: cubit.setDateRangeFilter,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: _PaymentMethodDropdown(
              value: widget.filters.paymentMethod,
              onChanged: cubit.setPaymentMethod,
            ),
          ),
          if (widget.filters.hasActiveFilters)
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                cubit.resetFilters();
              },
              icon: const Icon(Icons.refresh_rounded, size: AppIconSize.md),
              label: Text('Reset', style: AppTextStyles.bodyMd),
              style: TextButton.styleFrom(
                foregroundColor: context.colors.textSecondary,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              ),
            ),
        ],
      ),
    );
  }
}

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
      icon: Icons.calendar_today_rounded,
      label: 'Date',
      selectedItem: DropdownItem(
        id: value,
        label: _label(value),
      ),
      items: DateRangeFilter.values
          .map(
            (e) => DropdownItem<DateRangeFilter>(
          id: e,
          label: _label(e),
        ),
      )
          .toList(),
      onChanged: (item) {
        if (item != null) {
          onChanged(item.id);
        }
      },
    );
  }
}

class _PaymentMethodDropdown extends StatelessWidget {
  const _PaymentMethodDropdown({required this.value, required this.onChanged});

  final PaymentMethod value;
  final ValueChanged<PaymentMethod> onChanged;

  String _label(PaymentMethod m) => switch (m) {
    PaymentMethod.mixed => 'All Payment Methods',
    PaymentMethod.cash => 'Cash',
    PaymentMethod.card => 'Card',
  };

  @override
  Widget build(BuildContext context) {
    final paymentMethodItems = PaymentMethod.values
        .map(
          (e) => DropdownItem<PaymentMethod>(
        id: e,
        label: _label(e),
      ),
    )
        .toList();

    return FilterDropdown<PaymentMethod>(
      icon: Icons.payment_rounded,
      label: 'Payment Method',
      items: paymentMethodItems,
      selectedItem: paymentMethodItems.firstWhere((e) => e.id == value),
      onChanged: (item) {
        if (item != null) {
          onChanged(item.id);
        }
      },
    );
  }
}