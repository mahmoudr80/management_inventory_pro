import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';
import 'package:management_inventory_pro/core/widgets/primary_button.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';

import '../../../../../core/dependency_injection/service_locator.dart';
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
        Navigator.push(context,MaterialPageRoute(builder: (context) => AddProductScreen(),));
        context.read<HomeCubit>().clearAction();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    ProductModel ? product;
    //ScrollController _controller = ScrollController();
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 8.h),
      child: Column(
        children: [
          PageHeader(title: "Product Catalog",
          actions: [
            PrimaryButton(text: "Add Product",
                onPressed:() async {
            final data=  await Navigator.push(context,MaterialPageRoute(builder: (context) => AddProductScreen(),));
              print('============================');
              print(data);
              product = data;
              context.read<ProductCubit>().updateProducts(product);
            },)
          ],),
          SizedBox(height: 8.h),
          ProductFilterBar(
            categoryCubit: context.read<CategoryCubit>()..getCategories(),
            unitCubit: context.read<UnitCubit>()..getUnits(),
          ),
          SizedBox(height: 4.h),
          ProductList(),

        ],
      ),
    );
  }
}
