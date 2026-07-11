import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:management_inventory_pro/core/utils/app_snackBar.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:management_inventory_pro/features/product/presentation/edit_product/screens/edit_product_screen.dart';
import 'package:management_inventory_pro/features/product/presentation/products/widgets/product_card.dart';
import 'package:management_inventory_pro/features/product/presentation/products/widgets/product_grid.dart';

import '../../../../../core/dialogs/dialog_utils.dart';
import '../../../../../generated/assets.gen.dart';
import '../cubit/product_cubit.dart';
import 'product_view_type.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductSuccess) {
            if (state.products.isEmpty) {
              return Lottie.asset(Assets.lottie.notFound);
            }

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: state.viewType == ProductViewType.grid
                  ? ProductGrid(
                      key: const ValueKey('product-grid'),
                      products: state.products,
                      onDelete: (id) => _confirmDelete(
                        context,
                        state.products,
                        id,
                      ),
                      onEdit: (id) => _editProduct(
                        context,
                        state.products,
                        id,
                      ),
                    )
                  : Scrollbar(
                      key: const ValueKey('product-list'),
                      controller: _controller,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: _controller,
                        itemBuilder: (context, index) => ProductCard(
                          product: state.products[index],
                          onDelete: () => _confirmDelete(
                            context,
                            state.products,
                            state.products[index].id,
                          ),
                          onEdit: () => _editProduct(
                            context,
                            state.products,
                            state.products[index].id,
                          ),
                        ),
                        separatorBuilder: (context, index) => const SizedBox(height: 4),
                        itemCount: state.products.length,
                      ),
                    ),
            );
          } else if (state is ProductLoading) {
            return LottieBuilder.asset(Assets.lottie.loading);
          } else {
            return LottieBuilder.asset(Assets.lottie.notFound);
          }
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    List<ProductModel> products,
    String id,
  ) {
    final product = products.firstWhere((p) => p.id == id);
    showDeleteConfirmation(
      context: context,
      title: 'Delete product',
      itemName: product.name,
      onConfirm: () => _delete(context, id),
    );
  }

  Future<void> _delete(BuildContext context, String id) async {
    final deleted = await context.read<ProductCubit>().delete(id);
    if (deleted) {
      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          message: "Product $id deleted successfully",
          duration: 2000,
        );
      }
    } else {
      if (context.mounted) {
        AppSnackBar.showError(context, message: "Can not delete Product $id");
      }
    }
  }

  void _editProduct(
    BuildContext context,
    List<ProductModel> products,
    String id,
  ) {
    final product = products.firstWhere((p) => p.id == id);
    _openEditScreen(context, product);
  }

  /// Opens Edit Product for [product] and, on a successful save,
  /// re-fetches from the database so the list picks up the resolved
  /// category/unit display names via the join in
  /// ProductLocalDatasource.getProducts — the same refresh pattern
  /// delete() already uses, and it preserves the current view type and
  /// active filters (ProductCubit.getProducts keeps both).
  Future<void> _openEditScreen(BuildContext context, ProductModel product) async {
    final result = await Navigator.push<ProductModel>(
      context,
      MaterialPageRoute(builder: (_) => EditProductScreen(product: product)),
    );
    if (result != null && context.mounted) {
      context.read<ProductCubit>().getProducts();
    }
  }
}
