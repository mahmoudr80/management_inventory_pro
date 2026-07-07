import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:management_inventory_pro/core/widgets/search_select_dropdown.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';
import 'package:management_inventory_pro/features/product/presentation/products/cubit/product_cubit.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../generated/assets.gen.dart';
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
        final reason = loaded?.adjustment.reason;

        final searchField = BlocBuilder<ProductCubit, ProductState>(
          builder: (context, productState) {
            if (productState is ProductSuccess) {
              return SearchSelectDropdown<StockAdjustmentItemModel>(
                // Always null: this field adds a product and resets,
                // it doesn't hold a persistent selection.
                selected: null,
                items: productState.allProducts
                    .map((product) =>
                        StockAdjustmentItemModel.fromProduct(product))
                    .toList(),
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
              );
            }
            return Lottie.asset(Assets.lottie.notFound);
          },
        );

        final reasonDropdown = ReasonDropdown(
          selected: reason,
          onChanged: cubit.updateReason,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.lg,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < AppBreakpoints.compact) {
                // Stack vertically once space is too tight for the
                // search field and reason dropdown to sit side by side.
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    searchField,
                    const SizedBox(height: AppSpacing.sm),
                    reasonDropdown,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: searchField),
                  const SizedBox(width: AppSpacing.sm),
                  reasonDropdown,
                ],
              );
            },
          ),
        );
      },
    );
  }
}
