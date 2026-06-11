import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/components/side_bar_layout.dart';
import 'package:management_inventory_pro/features/home/cubit/home_cubit.dart';
import '../../core/dependency_injection/service_locator.dart';
import '../product/data/respository/product_repository.dart';
import '../product/presentation/products/cubit/product_cubit.dart';
import '../product/presentation/products/screens/product_screen.dart';

List<Widget>screens=[Placeholder(),
BlocProvider(create:(context) => ProductCubit(getIt<ProductRepository>())..getProducts(),
child: ProductScreen()),
  Placeholder(),
  Placeholder(),
  Placeholder(),
  Placeholder(),
];
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Row(
                children: [
                  SideBarLayout(selectedIndex:
                  state.currentIndex, onItemSelected: (value) {
                    context.read<HomeCubit>().navigate(value);
                  }, onLogout: () {

                  },),
                  Expanded(child: screens[state.currentIndex])
                ],
              );
            },
          ),

      );
  }
}
