import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:management_inventory_pro/features/product/presentation/products/cubit/product_cubit.dart';
import '../../theme/pos_theme_extension.dart';
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
    const horizontalPadding = 32.0;

    final available = width - horizontalPadding;

    return ((available + spacing) / (desiredCardWidth + spacing))
        .floor()
        .clamp(2, 8);
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _columnsForWidth(constraints.maxWidth);

        return GridView.builder(
          key:  ValueKey(crossAxisCount),
          controller: controller,
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
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
            decoration: BoxDecoration(
              color: context.posColors.summaryBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 30,
              color: context.posColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: context.posColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasQuery ? 'Try another search term' : 'No products available yet',
            style: TextStyle(
              fontSize: 13,
              color: context.posColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}