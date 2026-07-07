import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:management_inventory_pro/features/product/presentation/products/cubit/product_cubit.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../data/models/pos_product.dart';
import '../../cubit/pos_cubit.dart';
import '../../cubit/pos_state.dart';
import 'product_card.dart';
import '../analytics/sales_insight_card.dart';

class ProductGrid extends StatelessWidget {
  final String? selectedId;
  final void Function(PosProduct) onProductTap;
  final VoidCallback? onViewAnalytics;
  final VoidCallback? onViewBestSellers;
  final bool showAnalytics;
  final bool showCart;
  final ScrollController?controller;

  const ProductGrid({
    super.key,
    required this.onProductTap,
    this.selectedId,
    this.onViewAnalytics,
    this.onViewBestSellers,
    this.showAnalytics = true,  this.showCart=false, this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldShowAnalytics = showAnalytics && constraints.maxWidth >= 900;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (shouldShowAnalytics) ...[
              SizedBox(
                width:( constraints.maxWidth * 0.25).clamp(230,240),
                child: SalesInsightCard(),
              ),
            ],
            Expanded(
              //flex: 3,
              // ProductCubit owns fetching from the repository (loading /
              // success / error). PosCubit owns what's actually rendered
              // (search-filtered results). The listener below is the only
              // bridge between the two: every time the repository delivers
              // a fresh product list, it's handed to PosCubit once — after
              // that, search never touches the network again.
              child: BlocConsumer<ProductCubit, ProductState>(
                listenWhen: (previous, current) => current is ProductSuccess,
                listener: (context, state) {
                  if (state is ProductSuccess) {
                    final products = state.products
                        .map((product) => PosProduct.fromProduct(product))
                        .toList(growable: false);
                    context.read<PosCubit>().setProducts(products);
                  }
                },
                builder: (context, productState) {
                  if (productState is ProductLoading) {
                    return LottieBuilder.asset(Assets.lottie.loading);
                  }

                  if (productState is ProductSuccess) {
                    return BlocBuilder<PosCubit, PosState>(
                      buildWhen: (previous, current) =>
                          previous.filteredProducts !=
                              current.filteredProducts ||
                          previous.searchQuery != current.searchQuery,
                      builder: (context, posState) {
                        if (posState.filteredProducts.isEmpty) {
                          return _EmptySearchState(
                            searchQuery: posState.searchQuery,
                          );
                        }
                        return _ProductGrid(
                          products: posState.filteredProducts,
                          onTap: onProductTap,
                          selectedId: selectedId,
                          showAnalytics: shouldShowAnalytics,
                          showCart: showCart,
                          controller: controller,

                        );
                      },
                    );
                  }

                  return LottieBuilder.asset(Assets.lottie.notFound);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List<PosProduct> products;
  final void Function(PosProduct) onTap;
  final String? selectedId;
  final bool showAnalytics;
  final bool showCart;
  final ScrollController?controller;

  const _ProductGrid({
    required this.products,
    required this.onTap,
    this.selectedId,
    this.showAnalytics=false, this.showCart =false, this.controller,
  });
  int _columnsForWidth(double width) {
    const desiredCardWidth = 240.0;
    const spacing = 10.0;
    const horizontalPadding = 32.0; // 16 left + 16 right

    final available = width - horizontalPadding;

    return ((available + spacing) / (desiredCardWidth + spacing))
        .floor()
        .clamp(2, 8);
  }
  //  int _columnsForWidth(double width) {
  //   if (width >= 1600){
  //      if(showCart||showAnalytics){
  //       return 6;
  //     }
  //     else{
  //       return 7;
  //     }
  //   }
  //   else if (width >= 1300) {
  //    if(showCart||showAnalytics){
  //       return 5;
  //     }
  //     else{
  //       return 6;
  //     }
  //
  //   }
  //   else if (width >= 1100) {
  //      if(showCart||showAnalytics){
  //       return 4;
  //     }
  //     else{
  //       return 5;
  //     }
  //
  //   }
  //   else if (width >= 900) {
  //       if(showCart||showAnalytics){
  //         return 3;
  //       }
  //       else{
  //         return 4;
  //       }
  //
  //   }
  //   else{
  //     if(showCart&&showAnalytics){
  //       return 1;
  //     }
  //     else if(showCart||showAnalytics){
  //       return 2;
  //     }
  //     else{
  //       return 3;
  //     }
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _columnsForWidth(constraints.maxWidth);

        const cardWidth = 230.0;
        const spacing = 10.0;

        // final crossAxisCount =
        // ((constraints.maxWidth + spacing) /
        //     (cardWidth + spacing))
        //     .floor()
        //     .clamp(2, 8);

        return GridView.builder(
          key:  ValueKey(crossAxisCount),
          controller: controller,
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: crossAxisCount==3?1.1:0.9,
          ),
          itemCount: products.length,
          itemBuilder: (_, index) => ProductCard(
            product: products[index],
            selected: products[index].id == selectedId,
            onTap: () => onTap(products[index]),
          ),
        );
      },
    );

  }
}

/// Professional empty states shown when [PosState.filteredProducts] is
/// empty. Purely presentational — never triggers a refetch.
class _EmptySearchState extends StatelessWidget {
  final String searchQuery;

  const _EmptySearchState({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final hasQuery = searchQuery.isNotEmpty;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.posSummaryBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 30,
              color: AppColors.posPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No products found',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.posTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasQuery ? 'Try another search term' : 'No products available yet',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.posTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
