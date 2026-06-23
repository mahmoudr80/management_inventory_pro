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

  const ProductGrid({
    super.key,
    required this.onProductTap,
    this.selectedId,
    this.onViewAnalytics,
    this.onViewBestSellers,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showAnalytics = constraints.maxWidth >= 700;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showAnalytics) ...[
              SizedBox(
                width: constraints.maxWidth * 0.37,
                child: SalesInsightCard(),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              flex: 3,
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
                          showAnalytics: showAnalytics,
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
  final bool? showAnalytics;

  const _ProductGrid({
    required this.products,
    required this.onTap,
    this.selectedId,
    this.showAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (showAnalytics ?? false) ? 3 : 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: (showAnalytics ?? false) ? 0.7 : 0.8.r,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];

        return ProductCard(
          product: p,
          selected: p.id == selectedId,
          onTap: () => onTap(p),
        );
      },
    );
  }
}

/// Professional empty state shown when [PosState.filteredProducts] is
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
