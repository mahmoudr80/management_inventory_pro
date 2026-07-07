import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';
import 'package:management_inventory_pro/core/widgets/primary_button.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import '../../../../category/presentation/cubit/category_cubit.dart';
import '../../../../home/cubit/home_cubit.dart';
import '../../../../unit/presentation/cubit/unit_cubit.dart';
import '../../add_product/screens/add_product_screen.dart';
import '../cubit/product_cubit.dart';
import '../widgets/product_filter_bar.dart';
import '../widgets/product_list.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final homeState = context.read<HomeCubit>().state;

    if (homeState.action == PageAction.createProduct) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        context.read<HomeCubit>().clearAction();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ProductModel? product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: [
          PageHeader(
            title: "Product Catalog",
            actions: [
              PrimaryButton(
                text: "Add Product",
                onPressed: () async {
                  final data = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddProductScreen()),
                  );
                  print('============================');
                  print(data);
                  product = data;
                  if (context.mounted && product != null) {
                    context.read<ProductCubit>().updateProducts(product);
                  }
                },
              )
            ],
          ),
          const SizedBox(height: 8),
          ProductFilterBar(
            categoryCubit: context.read<CategoryCubit>()..getCategories(),
            unitCubit: context.read<UnitCubit>()..getUnits(),
          ),
          const SizedBox(height: 4),
          const ProductList(),
        ],
      ),
    );
  }
}
