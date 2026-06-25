import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/details/sale_details_panel.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sales_filters_bar.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sales_summary_section.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sales_table/sales_table.dart';

import '../../cubit/sales_history_cubit.dart';

class SaleLoadedBody extends StatelessWidget {
  const SaleLoadedBody({super.key,required this.state});
  final SalesHistoryLoaded state;

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Summary cards
        SalesSummarySection(summary: state.summary),
        SizedBox(height: 16.h),

        // Filters bar
        SalesFiltersBar(filters: state.filters),
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
                  sales: state.pagedSales,
                  selectedSale: state.selectedSale,
                  sortColumn: state.sortColumn,
                  sortDirection: state.sortDirection,
                  filteredTotal: state.filteredSales.length,
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                  pageSize: state.pageSize,
                ),
              ),

              // Right – details panel (30%)  – only when a sale is selected
              if (state.selectedSale != null) ...[
                SizedBox(width: 4.w),
                Expanded(
                  flex: 3,
                  child: SaleDetailsPanel(sale: state.selectedSale!),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}


