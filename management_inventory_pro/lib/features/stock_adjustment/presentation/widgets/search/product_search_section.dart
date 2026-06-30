import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/widgets/search_select_dropdown.dart';
import '../../../data/models/stock_adjustment_item_model.dart';
import '../../cubit/stock_adjustment_cubit.dart';
import '../../cubit/stock_adjustment_state.dart';
import 'reason_dropdown.dart';

class ProductSearchSection extends StatelessWidget {
  const ProductSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StockAdjustmentCubit>();

    return BlocBuilder<StockAdjustmentCubit, StockAdjustmentState>(
      builder: (context, state) {
        final loaded = state is StockAdjustmentLoaded ? state : null;
        // TODO: replace `availableProducts` with whatever field on your
        // loaded state holds the full searchable product list (the old
        // `cubit.searchProducts` query target) — SearchSelectDropdown
        // filters this list locally as the user types, so it needs the
        // full set, not just the last query's results.
        final products = loaded?.adjustment.items ?? <StockAdjustmentItemModel>[];
        final reason = loaded?.adjustment.reason;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SearchSelectDropdown<StockAdjustmentItemModel>(
                  // Always null: this field adds a product and resets,
                  // it doesn't hold a persistent selection.
                  selected: null,
                  items: products,
                  labelBuilder: (p) => p.productName,
                  searchTextBuilder: (p) =>
                      '${p.productName} ${p.sku} ${p.barcode ?? ''}',
                  subtitleBuilder: (p) => p.sku,
                  trailingBuilder: (p) => '${p.currentStock}',
                  itemIcon: Icons.inventory_2_outlined,
                  placeholder: 'Search by SKU, Barcode, or Product Name...',
                  emptyText: 'No products found.',
                  clearable: false,
                  onChanged: (p) {
                    if (p != null) cubit.addProduct(p);
                  },
                ),
              ),
              SizedBox(width: 2.w),
              ReasonDropdown(
                selected: reason,
                onChanged: cubit.updateReason,
              ),
            ],
          ),
        );
      },
    );
  }
}
