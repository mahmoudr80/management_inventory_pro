import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'sale_table_footer.dart';
import 'sale_table_header.dart';
import '../../../data/models/sale_model.dart';
import '../../cubit/sales_history_cubit.dart';
import 'sale_row.dart';

class SalesTable extends StatelessWidget {
  const SalesTable({
    super.key,
    required this.sales,
    required this.selectedSale,
    required this.sortColumn,
    required this.sortDirection,
    required this.filteredTotal,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
  });

  final List<SaleModel> sales;
  final SaleModel? selectedSale;
  final SortColumn sortColumn;
  final SortDirection sortDirection;
  final int filteredTotal;
  final int currentPage;
  final int totalPages;
  final int pageSize;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          SaleTableHeader(
            sortColumn: sortColumn,
            sortDirection: sortDirection,
            onSort: cubit.sortBy,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Rows
          Expanded(
            child: ListView.separated(
              itemCount: sales.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
              itemBuilder: (context, index) {
                final sale = sales[index];
                return SaleRow(
                  sale: sale,
                  isSelected: selectedSale?.id == sale.id,
                  onTap: () => cubit.selectSale(sale),
                );
              },
            ),
          ),

          // Footer / Pagination
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          SaleTableFooter(
            filteredTotal: filteredTotal,
            currentPage: currentPage,
            totalPages: totalPages,
            pageSize: pageSize,
            onPageChanged: cubit.goToPage,
          ),
        ],
      ),
    );
  }
}
