import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';
import 'package:management_inventory_pro/core/widgets/primary_button.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';
import 'package:management_inventory_pro/features/product/presentation/cubit/product_cubit.dart';
import 'package:management_inventory_pro/features/product/presentation/widgets/product_list.dart';

import '../../../../core/dependency_injection/service_locator.dart';
import '../../../add_product/presentation/screens/add_product_screen.dart';


class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //ScrollController _controller = ScrollController();
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 8.h),
      child: Column(
        children: [
          PageHeader(title: "Product Catalog",
          actions: [
            PrimaryButton(text: "Add Product",
                onPressed:() {
              Navigator.push(context,MaterialPageRoute(builder: (context) => AddProductScreen(),));
                },)
          ],),
          BlocProvider(create:(context) => ProductCubit(getIt<ProductRepository>())..getProducts(),
          child: ProductList(),)

        ],
      ),
    );
  }
}
