import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';
import 'package:management_inventory_pro/core/dependency_injection/service_locator.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/features/category/data/respository/category_repository.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';
import 'package:management_inventory_pro/features/unit/data/respository/unit_repository.dart';

import '../cubit/edit_product_cubit.dart';
import '../widgets/edit_product_form.dart';

/// Entry point for the Edit Product feature.
///
/// Push this with the [product] to edit:
///
/// ```dart
/// final result = await Navigator.push<ProductModel>(
///   context,
///   MaterialPageRoute(builder: (_) => EditProductScreen(product: product)),
/// );
/// if (result != null) context.read<ProductCubit>().getProducts();
/// ```
///
/// Pops back with the updated [ProductModel] on a successful save, or
/// with nothing on cancel/discard — the same pop-with-result contract
/// AddProductScreen already uses for Add Product, so the caller decides
/// how/when to refresh (Product List currently just re-fetches).
class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Edit Product',
                subtitle:
                    'Update master data for "${product.name}". Inventory quantity is unaffected.',
              ),
              const SizedBox(height: 24),
              // Same glass-morphism form container as AddProductScreen,
              // so Add/Edit feel like the same app.
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerLow
                            .withAlpha(140),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: BlocProvider(
                        create: (context) => EditProductCubit(
                          getIt<ProductRepository>(),
                          getIt<CategoryRepository>(),
                          getIt<UnitRepository>(),
                        )..loadInitialData(),
                        child: EditProductForm(product: product),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
