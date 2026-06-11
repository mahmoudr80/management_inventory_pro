import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:management_inventory_pro/features/product/presentation/products/widgets/product_card.dart';

import '../../../../../generated/assets.gen.dart';
import '../cubit/product_cubit.dart';
class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return  Expanded(
      child: BlocBuilder<ProductCubit,ProductState>(
  builder: (context, state) {
    if(state is ProductSuccess){
      return Scrollbar(
        controller: controller,
        thumbVisibility: true,
        child: ListView.separated(
          controller:  controller,
          itemBuilder: (context, index) =>
              ProductCard(product:
              state.products[index],
                onDelete:() {
                },), separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 4.h,);
        }, itemCount: 10,
          scrollDirection: Axis.vertical,
          shrinkWrap:true ,
        ),
      );
    }
    else if(state is ProductLoading){
      return LottieBuilder.asset(Assets.lottie.loading);
    }
    else{
      return LottieBuilder.asset(Assets.lottie.notFound);
    }

  },
),
    );
  }
}
