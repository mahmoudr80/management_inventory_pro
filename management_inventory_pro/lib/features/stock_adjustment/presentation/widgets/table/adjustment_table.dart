import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubit/stock_adjustment_cubit.dart';
import '../../cubit/stock_adjustment_state.dart';
import '../common/empty_state.dart';
import 'adjustment_row.dart';
import 'adjustment_table_header.dart';

class AdjustmentTable extends StatelessWidget {
  const AdjustmentTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockAdjustmentCubit, StockAdjustmentState>(
      builder: (context, state) {
        if (state is! StockAdjustmentLoaded) return const SizedBox.shrink();
        final cubit = context.read<StockAdjustmentCubit>();
        final items = state.adjustment.items;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFC3C5D9)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          child: Column(
            children: [
              const AdjustmentTableHeader(),
              if (items.isEmpty)
                SizedBox(
                  height: 200.h,
                  child: const EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No products added yet',
                    subtitle: 'Search for products above to add them',
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return AdjustmentRow(
                      index: i,
                      item: item,
                      isSelected: state.selectedRowId == item.id,
                      onTap: () => cubit.selectRow(item.id),
                      onQtyChanged: (qty) =>
                          cubit.updateAdjustmentQty(item.id, qty),
                      onDelete: () => cubit.removeProduct(item.id),
                    );
                  }, separatorBuilder: (BuildContext context, int index) =>SizedBox(height: 8.h,),
                ),
            ],
          ),
        );
      },
    );
  }
}
