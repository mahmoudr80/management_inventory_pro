import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:management_inventory_pro/core/dialogs/app_confirm_dialog.dart';
import 'package:management_inventory_pro/core/utils/app_snackBar.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:management_inventory_pro/features/product/presentation/products/widgets/product_card.dart';

import '../../../../../core/dialogs/dialog_utils.dart';
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
      if(state.products.isNotEmpty){
        return Scrollbar(
          controller: controller,
          thumbVisibility: true,
          child: ListView.separated(
            controller:  controller,
            itemBuilder: (context, index) =>
                ProductCard(product:
                state.products[index],
                  onDelete:()  =>
                      showDeleteConfirmation(
                        context: context,
                        title: 'Delete product',
                        itemName: state.products[index].name,
                        onConfirm: () => _delete(context, state.products[index].id),
                      ))
            , separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 4.h,);
          }, itemCount: state.products.length,
            scrollDirection: Axis.vertical,
            shrinkWrap:true ,
          ),
        );
      }
      else{
       return Lottie.asset(Assets.lottie.notFound);
      }
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
  Future<void> _delete(BuildContext context,String id)  async {

          final deleted = await context.read<ProductCubit>().delete(id);
          if(deleted){
            if(context.mounted){
              AppSnackBar.showSuccess(context, message: "Product $id deleted successfully",duration: 2000);
            }
          }
          else{
            if(context.mounted){
              AppSnackBar.showError(context, message: "Can not delete Product $id");
            }
          }
  }
}
