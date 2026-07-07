import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/details/sale_details_panel.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sales_filters_bar.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sales_summary_section.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/widgets/sales_table/sales_table.dart';
import '../../../../../core/theme/app_dimens.dart';

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
        if (widget.state.selectedSale == null) ...[
          // Summary cards
          SalesSummarySection(summary: widget.state.summary),
          const SizedBox(height: AppSpacing.lg),

          // Filters bar
          SalesFiltersBar(filters: widget.state.filters),
          const SizedBox(height: AppSpacing.lg),
        ],

        // Main two-column area
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < AppBreakpoints.medium;
              final tableWidget = SalesTable(
                sales: widget.state.pagedSales,
                selectedSale: widget.state.selectedSale,
                sortColumn: widget.state.sortColumn,
                sortDirection: widget.state.sortDirection,
                filteredTotal: widget.state.filteredSales.length,
                currentPage: widget.state.currentPage,
                totalPages: widget.state.totalPages,
                pageSize: widget.state.pageSize,
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: tableWidget),
                    if (widget.state.selectedSale != null)
                      SizedBox(
                        height: constraints.maxHeight * 0.45,
                        child: SaleDetailsPanel(sale: widget.state.selectedSale!),
                      ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 7,
                    child: tableWidget,
                  ),
                  if (widget.state.selectedSale != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 3,
                      child: SaleDetailsPanel(sale: widget.state.selectedSale!),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
