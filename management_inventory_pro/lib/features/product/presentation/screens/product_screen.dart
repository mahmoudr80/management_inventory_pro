import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';
import 'package:management_inventory_pro/core/components/status_chip.dart';
import 'package:management_inventory_pro/core/widgets/primary_button.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';
import 'package:management_inventory_pro/features/product/presentation/cubit/product_cubit.dart';
import 'package:management_inventory_pro/features/product/presentation/widgets/product_card.dart';
import 'package:management_inventory_pro/features/product/presentation/widgets/product_list.dart';

import '../../../../core/dependency_injection/service_locator.dart';
import '../../data/models/product_model.dart';


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

                },)
          ],),
          BlocProvider(create:(context) => ProductCubit(getIt<ProductRepository>())..getProducts(),
          child: ProductList(),)
          // Expanded(
          //   child: Scrollbar(
          //     controller: _controller,
          //     thumbVisibility: true,
          //     child: ListView.separated(
          //
          //       controller:  _controller,
          //       itemBuilder: (context, index) =>
          //           ProductCard(product:
          //       ProductModel(sku: 'sku',
          //           name: 'name', category: 'category',
          //           stock:5, status: StatusType.pending,
          //           statusText: '[In Stock]'),
          //           onDelete:() {
          //
          //           },), separatorBuilder: (BuildContext context, int index) {
          //         return SizedBox(height: 4.h,);
          //     }, itemCount: 10,
          //       scrollDirection: Axis.vertical,
          //       shrinkWrap:true ,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
