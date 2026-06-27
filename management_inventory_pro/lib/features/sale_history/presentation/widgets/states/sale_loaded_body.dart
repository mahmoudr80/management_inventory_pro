import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/details/sale_details_panel.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sales_filters_bar.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sales_summary_section.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sales_table/sales_table.dart';

import '../../../../home/cubit/home_cubit.dart';
import '../../cubit/sales_history_cubit.dart';

class SaleLoadedBody extends StatefulWidget {
  const SaleLoadedBody({super.key,required this.state});
  final SalesHistoryLoaded state;

  @override
  State<SaleLoadedBody> createState() => _SaleLoadedBodyState();
}

class _SaleLoadedBodyState extends State<SaleLoadedBody> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final homeState = context.read<HomeCubit>().state;

    if (homeState.action == PageAction.selectSale && homeState.selectSale!=null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SalesHistoryCubit>().selectSale(homeState.selectSale!);
        context.read<HomeCubit>().clearAction();
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Summary cards
        SalesSummarySection(summary: widget.state.summary),
        SizedBox(height: 16.h),

        // Filters bar
        SalesFiltersBar(filters: widget.state.filters),
        SizedBox(height: 16.h),

        // Main two-column area
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left – table (70%)
              Expanded(
                flex: 7,
                child: SalesTable(
                  sales: widget.state.pagedSales,
                  selectedSale: widget.state.selectedSale,
                  sortColumn: widget.state.sortColumn,
                  sortDirection: widget.state.sortDirection,
                  filteredTotal: widget.state.filteredSales.length,
                  currentPage: widget.state.currentPage,
                  totalPages: widget.state.totalPages,
                  pageSize: widget.state.pageSize,
                ),
              ),

              // Right – details panel (30%)  – only when a sale is selected
              if (widget.state.selectedSale != null) ...[
                SizedBox(width: 4.w),
                Expanded(
                  flex: 3,
                  child: SaleDetailsPanel(sale: widget.state.selectedSale!),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}


