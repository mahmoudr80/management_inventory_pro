import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:management_inventory_pro/core/widgets/product_dropdown.dart';

import '../../features/product/presentation/products/cubit/product_cubit.dart';
import '../../features/stock_receipts/data/models/product_ref.dart';
import '../../generated/assets.gen.dart';

class ProductSelector extends StatelessWidget {
  final ProductRef? selected;
  final ValueChanged<ProductRef?> onChanged;

  const ProductSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is! ProductSuccess) {
          return Lottie.asset(Assets.lottie.notFound);
        }

        return ProductDropdown(
          selected: selected,
          products: state.allProducts
              .map(ProductRef.fromProductModel)
              .toList(),
          onChanged: onChanged,
        );
      },
    );
  }
}