import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';
import 'package:management_inventory_pro/core/widgets/primary_button.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';

import '../../../../../core/dependency_injection/service_locator.dart';
import '../../add_product/screens/add_product_screen.dart';
import '../cubit/product_cubit.dart';
import '../widgets/product_list.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

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
          ProductList(),

        ],
      ),
    );
  }
}
