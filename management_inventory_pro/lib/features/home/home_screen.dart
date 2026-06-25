import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/components/side_bar_layout.dart';
import 'package:management_inventory_pro/features/category/data/respository/category_repository.dart';
import 'package:management_inventory_pro/features/home/cubit/home_cubit.dart';
import 'package:management_inventory_pro/features/pos/data/repository/pos_repository.dart';
import 'package:management_inventory_pro/features/sale_history/presentation/screens/sales_history_screen.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/respository/stock_entry_repository.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/screens/stock_entry_screen.dart';
import 'package:management_inventory_pro/features/suppliers/data/repository/supplier_repository.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/cubit/suppliers_cubit.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/screens/suppliers_screen.dart';
import 'package:management_inventory_pro/features/unit/data/respository/unit_repository.dart';
import '../../core/dependency_injection/service_locator.dart';
import '../category/presentation/cubit/category_cubit.dart';
import '../pos/presentation/cubit/pos_cubit.dart';
import '../pos/presentation/screens/pos_screen.dart';
import '../product/data/respository/product_repository.dart';
import '../product/presentation/products/cubit/product_cubit.dart';
import '../product/presentation/products/screens/product_screen.dart';
import '../stock_receipts/presentation/cubit/stock_entry_cubit.dart';
import '../unit/presentation/cubit/unit_cubit.dart';

List<Widget>screens = [Placeholder(),
  MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoryCubit(getIt<CategoryRepository>())),
        BlocProvider(create: (_) => UnitCubit(getIt<UnitRepository>())),
        BlocProvider(create: (_) =>
        ProductCubit(getIt<ProductRepository>())
          ..getProducts()),
      ], child: ProductScreen()),
  SupplierScreen(),
  MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) =>
        ProductCubit(getIt<ProductRepository>())
          ..getProducts()),
        BlocProvider(create: (_) =>
        SuppliersCubit(getIt<SupplierRepository>())
          ..loadSuppliers()),
        BlocProvider(
          create: (context) =>
          StockEntryCubit(getIt<StockEntryRepository>())
            ..loadEntries(),
        ),
      ], child: StockEntryScreen()),
  MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => ProductCubit(getIt<ProductRepository>())..getProducts(),
      ),
      BlocProvider(
        create: (context) => PosCubit(getIt<PosRepository>()),
      ),

    ],
    child: PosScreen(),
  ),
  SalesHistoryScreen(),
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
