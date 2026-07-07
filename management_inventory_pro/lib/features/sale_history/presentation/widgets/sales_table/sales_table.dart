import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_decoration.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';
import 'sale_table_footer.dart';
import 'sale_table_header.dart';
import '../../../data/models/sale_model.dart';
import '../../cubit/sales_history_cubit.dart';
import 'sale_row.dart';

class SalesTable extends StatefulWidget {
  const SalesTable({ super.key, required this.sales, required this.selectedSale,
    required this.sortColumn, required this.sortDirection, required this.filteredTotal,
    required this.currentPage, required this.totalPages, required this.pageSize });

  final List<SaleModel> sales;
  final SaleModel? selectedSale;
  final SortColumn sortColumn;
  final SortDirection sortDirection;
  final int filteredTotal;
  final int currentPage;
  final int totalPages;
  final int pageSize;

  @override
  State<SalesTable> createState() => _SalesTableState();
}

class _SalesTableState extends State<SalesTable> {
  final _rowsScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _rowsScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();

    return Container(
      decoration: AppDecorations.elevatedCard(
        color: AppColors.surface,
        borderColor: AppColors.border,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableCore = ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: AppBreakpoints.compact,
              maxWidth: constraints.maxWidth > AppBreakpoints.compact
                  ? constraints.maxWidth
                  : AppBreakpoints.compact,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SaleTableHeader(
                  sortColumn: widget.sortColumn,
                  sortDirection: widget.sortDirection,
                  onSort: cubit.sortBy,
                ),
                const Divider(height: 1, color: AppColors.border),
                Expanded(
                  child: Scrollbar(
                    controller: _rowsScrollController,
                    child: ListView.separated(
                      controller: _rowsScrollController,
                      itemCount: widget.sales.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
                      itemBuilder: (context, index) {
                        final sale = widget.sales[index];
                        return SaleRow(
                          sale: sale,
                          isSelected: widget.selectedSale?.id == sale.id,
                          onTap: () => cubit.selectSale(sale),
                        );
                      },
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                SaleTableFooter(
                  filteredTotal: widget.filteredTotal,
                  currentPage: widget.currentPage,
                  totalPages: widget.totalPages,
                  pageSize: widget.pageSize,
                  onPageChanged: cubit.goToPage,
                ),
              ],
            ),
          );

          // If the allocated width (e.g. table squeezed by an open details
          // panel) is below the table's minimum comfortable width, scroll
          // horizontally instead of overflowing. Vertical layout (the
          // Expanded row list above) is unaffected since this only scrolls
          // the horizontal axis.
          if (constraints.maxWidth >= AppBreakpoints.compact) {
            return tableCore;
          }
          return Scrollbar(
            controller: _horizontalScrollController,
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: constraints.maxHeight,
                child: tableCore,
              ),
            ),
          );
        },
      ),
    );
  }
}


